//
//  ActivityRecordDBRepository.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation
import Combine
import CoreData

protocol ActivityRecordDBRepository {
    
    func store(activityRecords: [ActivityRecord], for userProfileId: UUID) -> AnyPublisher<Void, Error>
    
    func edit(activityRecord: ActivityRecord) -> AnyPublisher<Void, Error>
    
    func delete(activityRecordId: UUID) -> AnyPublisher<Void, Error>
    
    func fetch(for userProfileId: UUID) -> AnyPublisher<[ActivityRecord], Error>
    
}

struct ActivityRecordDBRepositoryImpl: ActivityRecordDBRepository {
    
    let persistentStore: PersistentStore
    
    init(
        persistentStore: PersistentStore
    ) {
        self.persistentStore = persistentStore
    }
    
    func store(activityRecords: [ActivityRecord], for userProfileId: UUID) -> AnyPublisher<Void, any Error> {
        persistentStore.update { context in
            do {
                let parentRequest = UserProfileMO.currentUser(userProfileId)
                guard let parent = try context.fetch(parentRequest).first else {
                    throw AppError.domain(.data(.notFound))
                }
                for record in activityRecords {
                    record.store(in: context, user: parent)
                }
            } catch {
                throw error
            }
        }
    }
    
    func edit(activityRecord: ActivityRecord) -> AnyPublisher<Void, any Error> {
        persistentStore.update { context in
            do {
                let parentRequest = UserProfileMO.currentUser(activityRecord.userId)
                guard let userProfileMO = try context.fetch(parentRequest).first else {
                    throw AppError.domain(.data(.notFound))
                }
                
                let selfRequest = ActivityRecordMO.getRecord(activityRecord.id)
                guard let activityRecordMO = try context.fetch(selfRequest).first else {
                    throw AppError.domain(.data(.notFound))
                }
                
                activityRecordMO.user = userProfileMO
                // TODO: finish
                activityRecordMO.timestamp = activityRecord.timestamp
            } catch {
                throw error
            }
        }
    }
    
    func delete(activityRecordId: UUID) -> AnyPublisher<Void, any Error> {
        persistentStore.update { context in
            do {
                let request = ActivityRecordMO.getRecord(activityRecordId)
                guard let activityRecordMO = try context.fetch(request).first else {
                    throw AppError.domain(.data(.notFound))
                }
                context.delete(activityRecordMO)
            } catch {
                throw error
            }
        }
    }
    
    func fetch(for userProfileId: UUID) -> AnyPublisher<[ActivityRecord], any Error> {
        let fetchRequest: NSFetchRequest<ActivityRecordMO> = ActivityRecordMO.records(for: userProfileId)
        return persistentStore.fetch(fetchRequest) { activityRecordMO in
            return ActivityRecord(managedObject: activityRecordMO)
        }
    }
    
}

extension ActivityRecordMO {
    static func getRecord(_ id: UUID) -> NSFetchRequest<ActivityRecordMO> {
        let request = NSFetchRequest<ActivityRecordMO>(entityName: ActivityRecordMO.entityName)
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return request
    }
    
    static func records(
        for userProfileId: UUID
    ) -> NSFetchRequest<ActivityRecordMO> {
        let request = NSFetchRequest<ActivityRecordMO>(entityName: ActivityRecordMO.entityName)
        
        let predicate = NSPredicate(format: "user.userId == %@", userProfileId as CVarArg)
        
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        return request
    }
}

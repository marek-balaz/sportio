//
//  ActivityRecordService.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation
import Combine

protocol ActivityRecordService {
    
    func add(activityRecord: ActivityRecord, storage: Storage) -> AnyPublisher<EmptyEntity, Error>
    
    func loadActivityRecords() -> AnyPublisher<[ActivityRecord], Error>
    
}

struct ActivityRecordServiceImpl: ActivityRecordService {
    
    let appState: Store<AppState>
    
    let activityRecordWebRepository: ActivityRecordWebRepository
    
    let activityRecordDBRepository: ActivityRecordDBRepository
    
    init(
        appState: Store<AppState>,
        activityRecordWebRepository: ActivityRecordWebRepository,
        activityRecordDBRepository: ActivityRecordDBRepository
    ) {
        self.appState = appState
        self.activityRecordWebRepository = activityRecordWebRepository
        self.activityRecordDBRepository = activityRecordDBRepository
    }
    
    func loadActivityRecords() -> AnyPublisher<[ActivityRecord], Error> {
        guard let userId = appState[\.userData.userProfile].value?.id else {
            return Fail(error: AppError.domain(.business(.userNotFound)))
                .eraseToAnyPublisher()
        }
        
        let localPublisher = activityRecordDBRepository
            .fetch(for: userId)
            .map { records in
                records.map { record in
                    var modifiedRecord = record
                    modifiedRecord.source = .local
                    return modifiedRecord
                }
            }
            .eraseToAnyPublisher()
        
        let remotePublisher = activityRecordWebRepository
            .loadActivityRecords()
            .map { records in
                records.map { record in
                    var modifiedRecord = record
                    modifiedRecord.source = .remote
                    return modifiedRecord
                }
            }
            .eraseToAnyPublisher()
        
        return Publishers.Merge(
            localPublisher,
            remotePublisher
        )
        .collect()
        .map {
            $0
            .flatMap { $0 }
            .sorted(by: { $0.dateFrom > $1.dateFrom }) }
        .eraseToAnyPublisher()
    }
    
    func add(activityRecord: ActivityRecord, storage: Storage) -> AnyPublisher<EmptyEntity, Error> {
        switch storage {
        case .local:
            return activityRecordDBRepository
                .store(activityRecords: [activityRecord], for: activityRecord.userId)
                .map { _ in EmptyEntity() }
                .eraseToAnyPublisher()
        case .remote:
            return activityRecordWebRepository.add(activityRecord: activityRecord)
        case .both:
            return Fail(error: AppError.domain(.business(.notSupported)))
                .eraseToAnyPublisher()
        }
    }
    
}

//
//  StubActivityRecordDBRepository.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation
import Combine

struct StubActivityRecordDBRepository: ActivityRecordDBRepository {
    
    func store(activityRecords: [ActivityRecord], for userProfileId: UUID) -> AnyPublisher<Void, any Error> {
        Future { promise in
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
    
    func edit(activityRecord: ActivityRecord) -> AnyPublisher<Void, any Error> {
        Future { promise in
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
    
    func delete(activityRecordId: UUID) -> AnyPublisher<Void, any Error> {
        Future { promise in
            promise(.success(()))
        }
        .eraseToAnyPublisher()
    }
    
    func fetch(for userProfileId: UUID) -> AnyPublisher<[ActivityRecord], any Error> {
        Future { promise in
            promise(.success(([])))
        }
        .eraseToAnyPublisher()
    }
    
}

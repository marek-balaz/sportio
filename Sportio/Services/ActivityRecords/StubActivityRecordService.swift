//
//  StubActivityRecordService.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation
import Combine

struct StubActivityRecordService: ActivityRecordService {
    
    func add(activityRecord: ActivityRecord, storage: Storage) -> AnyPublisher<EmptyEntity, Error> {
        Fail(error: AppError.domain(.data(.unexpectedError))).eraseToAnyPublisher()
    }
    
    func loadActivityRecords() -> AnyPublisher<[ActivityRecord], Error> {
        Fail(error: AppError.domain(.data(.unexpectedError))).eraseToAnyPublisher()
    }
    
}

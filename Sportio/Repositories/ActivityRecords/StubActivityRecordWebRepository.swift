//
//  StubActivityRecordWebRepository.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation
import Combine
import Alamofire

struct StubActivityRecordWebRepository: ActivityRecordWebRepository {
    
    var session: Session
    
    var baseURL: String
    
    var bgQueue: DispatchQueue
    
    init() {
        self.session = .init(configuration: .default)
        self.baseURL = Const.getStringFor(key: "SupabaseAPI")
        self.bgQueue = .init(label: "bg.queue")
    }
    
    func add(activityRecord: ActivityRecord) -> AnyPublisher<EmptyEntity, Error> {
        Fail(error: AppError.domain(.data(.unexpectedError))).eraseToAnyPublisher()
    }
    
    func loadActivityRecords() -> AnyPublisher<[ActivityRecord], Error> {
        Fail(error: AppError.domain(.data(.unexpectedError))).eraseToAnyPublisher()
    }
    
}

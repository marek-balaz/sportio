//
//  ActivityRecordWebRepository.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation
import Combine
import Alamofire

protocol ActivityRecordWebRepository: WebRepository {
    
    func add(activityRecord: ActivityRecord) -> AnyPublisher<EmptyEntity, Error>
    
//    func edit(activityRecord: ActivityRecord) -> AnyPublisher<EmptyResponse, Error>
//    
//    func delete(activityRecordId: UUID) -> AnyPublisher<EmptyResponse, Error>
    
    func loadActivityRecords() -> AnyPublisher<[ActivityRecord], Error>
    
}

struct ActivityRecordWebRepositoryImpl: ActivityRecordWebRepository {
    
    var session: Session
    
    var baseURL: String
    
    var bgQueue: DispatchQueue = .init(label: "bg.queue")
    
    init(
        session: Session,
        baseURL: String
    ) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func add(activityRecord: ActivityRecord) -> AnyPublisher<EmptyEntity, Error> {
        request(
            path: "rest/v1/activity_records",
            method: .post,
            body: activityRecord
        )
    }
    
//    func edit(activityRecord: ActivityRecord) -> AnyPublisher<EmptyResponse, Error> {
//        <#code#>
//    }
//    
//    func delete(activityRecordId: UUID) -> AnyPublisher<EmptyResponse, Error> {
//        <#code#>
//    }
    
    func loadActivityRecords() -> AnyPublisher<[ActivityRecord], Error> {
        request(
            path: "rest/v1/activity_records",
            method: .get
        )
    }
    
}

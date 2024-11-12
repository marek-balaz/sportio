//
//  UsersWebRepository.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation
import Alamofire

protocol UsersWebRepository: WebRepository {
    
}

struct UsersWebRepositoryImpl: UsersWebRepository {
    
    var session: Session
    
    var baseURL: String
    
    let bgQueue: DispatchQueue = .init(label: "bg.queue")
    
    init(
        session: Session,
        baseURL: String
    ) {
        self.session = session
        self.baseURL = baseURL
    }
    
}

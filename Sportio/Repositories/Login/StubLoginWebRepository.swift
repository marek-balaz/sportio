//
//  StubLoginWebRepository.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation
import Combine
import Alamofire

struct StubLoginWebRepository: LoginWebRepository {
    
    var session: Session
    
    var baseURL: String
    
    var bgQueue: DispatchQueue
    
    init() {
        self.session = .init(configuration: .default)
        self.baseURL = Const.getStringFor(key: "SupabaseAPI")
        self.bgQueue = .init(label: "bg.queue")
    }
    
    func refreshToken() -> AnyPublisher<RefreshTokenResponse, Error> {
        Future { promise in
            promise(.failure(AppError.domain(.data(.unexpectedError))))
        }
        .eraseToAnyPublisher()
    }
    
    func anonLogin() -> AnyPublisher<RefreshTokenResponse, Error> {
        Future { promise in
            promise(.failure(AppError.domain(.data(.unexpectedError))))
        }
        .eraseToAnyPublisher()
    }
    
}

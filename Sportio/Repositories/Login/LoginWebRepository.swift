//
//  LoginWebRepository.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation
import Combine
import Alamofire

protocol LoginWebRepository: WebRepository {
    
    func refreshToken() -> AnyPublisher<RefreshTokenResponse, Error>
    
    func anonLogin() -> AnyPublisher<RefreshTokenResponse, Error>
    
}

struct LoginWebRepositoryImpl: LoginWebRepository {
    
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
    
    func refreshToken() -> AnyPublisher<RefreshTokenResponse, Error> {
        guard let refreshToken = UserDefaults.standard.refreshToken else {
            return Fail(error: AppError.domain(.data(.notFound)))
                .eraseToAnyPublisher()
        }
        
        return request(
            path: "auth/v1/token?grant_type=refresh_token",
            method: .post,
            body: ["refresh_token": refreshToken]
        )
    }
    
    func anonLogin() -> AnyPublisher<RefreshTokenResponse, Error> {
        request(
            path: "auth/v1/signup",
            method: .post,
            body: EmptyRequest()
        )
    }
    
}

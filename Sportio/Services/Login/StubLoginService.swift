//
//  StubLoginService.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation
import Combine

struct StubLoginService: LoginService {
    
    func refreshToken(completion: @escaping (Result<Void, Error>) -> Void) {
        
    }
    
    func anonLogin(completion: @escaping (Result<Void, Error>) -> Void) {
        
    }
    
}

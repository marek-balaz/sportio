//
//  RefreshTokenResponse.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation

struct RefreshTokenResponse: Codable {
    
    let accessToken: String
    
    let tokenType: String
    
    let expiresIn: Int
    
    let expiresAt: Int
    
    let refreshToken: String
    
    let user: User
    
}

struct User: Codable {
    
    let id: String

    let email: String
    
}

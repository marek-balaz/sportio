//
//  APIError.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation

struct APIError: Codable {
    
    let code: Int
    
    let errorCode: String
    
    let msg: String
    
}

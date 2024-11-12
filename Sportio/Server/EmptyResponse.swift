//
//  EmptyResponse.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Alamofire

struct EmptyRequest: Encodable {}

struct EmptyEntity: Codable, EmptyResponse {
    
    static func emptyValue() -> EmptyEntity {
        return EmptyEntity.init()
    }
}

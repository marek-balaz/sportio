//
//  StorageType.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation

enum Storage: String, CaseIterable, RawRepresentable {
    case both
    case local
    case remote
    
    var name: String {
        switch self {
        case .both: return "All"
        case .local: return "Local"
        case .remote: return "Remote"
        }
    }
}

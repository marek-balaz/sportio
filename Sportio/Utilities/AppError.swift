//
//  AppError.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation

enum AppError: Error, LocalizedError {
    
    case domain(Domain)
    
    var errorDescription: String? {
        switch self {
        case .domain(let domainError):
            return domainError.errorDescription
        }
    }
    
    enum Domain: Error, LocalizedError {
        case presentation(Presentation)
        case business(Business)
        case data(Data)
        
        var errorDescription: String? {
            switch self {
            case .presentation(let presentationError):
                return presentationError.errorDescription
            case .business(let businessError):
                return businessError.errorDescription
            case .data(let dataError):
                return dataError.errorDescription
            }
        }
        
        enum Presentation: Error, LocalizedError {
            case notValid
            
            public var errorDescription: String? {
                switch self {
                case .notValid:
                    return String(localized: "error_form_validation")
                }
            }
        }
        
        enum Business: Error, LocalizedError {
            case userNotFound
            case notSupported
            
            public var errorDescription: String? {
                switch self {
                case .userNotFound:
                    return String(localized: "error_user_not_found")
                case .notSupported:
                    return String(localized: "error_not_supported")
                }
            }
        }
        
        enum Data: Error, LocalizedError {
            case unexpectedError
            case notFound
            
            public var errorDescription: String? {
                switch self {
                case .unexpectedError:
                    return String(localized: "global_unexpected_error")
                case .notFound:
                    return String(localized: "error_not_found")
                }
            }
        }
    }
}

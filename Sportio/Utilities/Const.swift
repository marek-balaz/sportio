//
//  Const.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation

class Const {
    
    static func getFor(key: String) -> Any? {
        return Bundle.main.object(forInfoDictionaryKey: key)
    }
    
    static func getStringFor(key: String) -> String {
        guard let value = getFor(key: key) as? String else {
            Log.d("Plist value for key \(key) not found.")
            return ""
        }
        return value
    }
    
    static func getVersion() -> String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            Log.d("Could not retrieve app version.")
            return "unknown"
        }
        return version
    }

    static func getBuild() -> String {
        guard let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            Log.d("Could not retrieve app build number.")
            return "unknown"
        }
        return build
    }
    
}

//
//  UserDefaultsExtension.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation
import SwiftUI

extension UserDefaults {
    
    public struct C {
        static let userLocaleKey = "user_locale"
        static let userThemeKey = "user_theme"
        static let userSelectedProfileIdKey = "user_selected_user_id"
        static let accessTokenKey = "access_token"
        static let refreshTokenKey = "refresh_token"
    }
    
    @objc var userLocale: String? {
        get { string(forKey: C.userLocaleKey) }
        set { setValue(newValue, forKey: C.userLocaleKey) }
    }
    
    @objc var userTheme: String {
        get { string(forKey: C.userThemeKey) ?? "" }
        set { setValue(newValue, forKey: C.userThemeKey) }
    }
    
    @objc var userSelectedProfileId: String? {
        get { string(forKey: C.userSelectedProfileIdKey) }
        set { setValue(newValue, forKey: C.userSelectedProfileIdKey) }
    }
    
    @objc var accessToken: String? {
        get { string(forKey: C.accessTokenKey) }
        set { setValue(newValue, forKey: C.accessTokenKey) }
    }
    
    @objc var refreshToken: String? {
        get { string(forKey: C.refreshTokenKey) }
        set { setValue(newValue, forKey: C.refreshTokenKey) }
    }
}
    

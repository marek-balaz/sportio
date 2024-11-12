//
//  SportioApp.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import SwiftUI
import SwiftData
import Combine

@main
struct SportioApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @Environment(\.locale) private var defaultLocale: Locale
    
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.di) private var di
    
    @State private var locale: Locale?
    
    @State private var theme: Theme?
    
    @State private var cancelBag: CancelBag = .init()
    
    var body: some Scene {
        WindowGroup {
            DashboardScreen()
                .onReceive(localeUpdate) { locale in
                    if let locale = locale {
                        self.locale = locale
                    }
                }
                .onReceive(colorSchemeUpdate) { theme in
                    self.theme = theme
                }
                .preferredColorScheme(currentColorScheme)
                .environment(\.locale, currentLocale)
                .environment(\.di, delegate.appEnvironment.container)
        }
    }

}

extension SportioApp {
    var localeUpdate: AnyPublisher<Locale?, Never> {
        di.appState.updates(for: \.system.locale)
    }
    
    var localeBinding: Binding<Locale?> {
        $locale.dispatched(to: di.appState, \.system.locale)
    }
    
    var currentLocale: Locale {
        if locale?.identifier.isEmpty == false {
            return locale ?? defaultLocale
        }
        
        if di.appState[\.system].locale?.identifier.isEmpty == false {
            return di.appState[\.system].locale ?? defaultLocale
        }
        
        return defaultLocale
    }
}

extension SportioApp {
    var colorSchemeUpdate: AnyPublisher<Theme?, Never> {
        delegate.appEnvironment.container.appState.updates(for: \.system.theme)
    }
    
    var colorSchemeBinding: Binding<Theme?> {
        $theme.dispatched(to: delegate.appEnvironment.container.appState, \.system.theme)
    }
    
    var currentColorScheme: ColorScheme? {
        theme?.colorScheme ?? di.appState[\.system].theme?.colorScheme
    }
}

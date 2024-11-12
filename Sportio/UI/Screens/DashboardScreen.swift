//
//  DashboardScreen.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation
import SwiftUI
import Combine

struct DashboardScreen: View {
    
    @Environment(\.di) private var di
    
    @State private var userProfile: Loadable<UserProfile> = .notRequested
    var userProfileUpdate: AnyPublisher<Loadable<UserProfile>, Never> {
        di.appState.updates(for: \.userData.userProfile)
    }
    
    @State var showLogin: Bool = UserDefaults.standard.accessToken == nil ? true : false
    
    var body: some View {
        content
            .onAppear {
                di.services.usersService.getSelectedUser(id: nil)
            }
            .fullScreenCover(isPresented: $showLogin) {
                LoginScreen()
            }
            .onReceive(userProfileUpdate) {
                userProfile = $0
            }
    }
}

extension DashboardScreen {
    @ViewBuilder
    var content: some View {
        switch userProfile {
        case .isLoading, .notRequested, .failed:
            ProgressView()
        case .loaded:
            TabView {
                OverviewRootView {
                    OverviewScreen()
                }
                .tabItem {
                    Label(LocalizedStringKey("title_overview"), systemImage: "house")
                }
                
                SettingsRootView {
                    SettingsScreen()
                }
                .tabItem {
                    Label(LocalizedStringKey("title_settings"), systemImage: "gearshape")
                }
            }
        }
    }
}

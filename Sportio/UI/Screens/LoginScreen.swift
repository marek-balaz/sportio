//
//  StartupScreen.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation
import SwiftUI

struct LoginScreen: View {
    
    @Environment(\.di) private var di
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var apiError: (Error?, Bool) = (nil, false)
    
    @State var isAuthenticated: Bool = false
    
    var body: some View {
        content
            .onAppear {
                checkAuth()
            }
    }
    
}

// MARK: - UI

extension LoginScreen {
    
    @ViewBuilder
    var content: some View {
        if let error = apiError.0, apiError.1 == true {
            PlaceholderView(
                title: String(localized: "global_cancel"),
                subtitle: error.localizedDescription
            ) {
                Button {
                    anonlogin()
                } label: {
                    Text(String(localized: "global_try_again"))
                }
            }
        } else {
            ProgressView()
        }
    }
    
}

// MARK: - API

extension LoginScreen {
    
    func checkAuth() {
        if UserDefaults.standard.accessToken != nil {
            dismiss()
        } else {
            anonlogin()
        }
    }

    func anonlogin() {
        di.services.loginService.anonLogin { result in
            switch result {
            case .success:
                di.services.usersService.getSelectedUser(id: nil) // should be in service
                dismiss()
            case .failure(let e):
                apiError = (e, true)
            }
        }
    }
    
}

#Preview {
    LoginScreen()
}

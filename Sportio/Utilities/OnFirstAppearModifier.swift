//
//  OnFirstAppearModifier.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import SwiftUI

struct OnFirstAppearModifier: ViewModifier {

    @State private var viewAppeared = false
    
    private let action: () -> Void

    func body(content: Content) -> some View {
        content.onAppear {
            guard !viewAppeared else {
                return
            }
            viewAppeared = true
            DispatchQueue.main.async {
                action()
            }
        }
    }
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
}

extension View {
    func onFirstAppear(_ action: @escaping () -> Void) -> some View {
        modifier(OnFirstAppearModifier(action: action))
    }
}

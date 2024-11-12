//
//  PrimaryButton.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation
import SwiftUI

struct ButtonStyleViewModifier: ViewModifier {
    
    enum Style {
        case primary
    }
    
    let style: Style
    
    let stretched: Bool
    
    func body(content: Content) -> some View {
        switch style {
        case .primary:
            content
                .buttonStyle(PrimaryButton(stretched: stretched))
        }
    }
    
}

struct PrimaryButton: ButtonStyle {
    
    let stretched: Bool
    
    @Environment(\.isEnabled) private var isEnabled
    
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .bold))
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .foregroundColor(Color.white)
            .frame(height: 50)
            .padding(.horizontal, 20)
            .if(stretched) {
                $0.frame(maxWidth: .infinity)
            }
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color("primary-2"))
                    .shadow(color: Color("primary-2").opacity(0.32), radius: 8, x: 0, y: 4)
            }
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(
                .easeInOut(duration: 0.06),
                value: configuration.isPressed
            )
    }
}

extension View {
    
    func buttonStyle(_ style: ButtonStyleViewModifier.Style, stretched: Bool = false) -> some View {
        modifier(ButtonStyleViewModifier(style: style, stretched: stretched))
    }
    
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

#Preview {
    Button("Primary button") {
        
    }
    .buttonStyle(.primary)
}

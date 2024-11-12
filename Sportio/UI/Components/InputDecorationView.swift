//
//  InputDecorationView.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation
import SwiftUI

struct InputDecorationView<T: View>: View {
    
    let hint: String
    
    let content: () -> T
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(hint)
                .font(.system(size: 14))
                .foregroundStyle(.gray)
            
            content()
        }
    }
}

#Preview {
    InputDecorationView(hint: "Sport activity") {
        FormularTextField(
            text: .constant("")
        )
    }
}

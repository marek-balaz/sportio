//
//  FormularTextField.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation
import SwiftUI

struct FormularTextField: View {
    
    @Binding var text: String
    
    var body: some View {
        TextField("", text: $text)
            .font(.system(size: 16, weight: .bold))
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color("primary-2").opacity(0.1))
            )
    }
}

#Preview {
    FormularTextField(
        text: .constant("")
    )
}

//
//  ActivityView.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation
import SwiftUI

struct ActivityView: View {
    
    let title: String
    
    let location: String
    
    let dateFrom: Date
    
    let dateTo: Date
    
    let storage: Storage
    
    var body: some View {
        content
    }
    
}

extension ActivityView {
    var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            topPart
            
            Color.gray.opacity(0.25)
                .frame(height: 1)
            
            bottomPart
            
        }
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(UIColor.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.25), lineWidth: 1)
                )
        }
        .padding(.horizontal)
    }
    
    var icon: some View {
        Image(systemName: "figure.run")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(Color("primary-2"))
            .padding(14)
            .background {
                Circle()
                    .fill(Color("primary-2").opacity(0.1))
            }
            .frame(width: 50, height: 50)
    }
    
    var topPart: some View {
        HStack {
            icon
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                Text(location)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            // TODO: Edit
            // Image(systemName: "arrow.up.forward")
            
        }
        .padding(12)
    }
    
    var bottomPart: some View {
        HStack {
            
            switch storage {
            case .local:
                Image(systemName: "icloud.slash")
            case .remote, .both:
                Image(systemName: "icloud")
            }
            
            Spacer()
            
            HStack {
                Image(systemName: "clock")
                
                Text(dateFrom, style: .time)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.gray)
                
                Image(systemName: "calendar")
                
                Text(dateFrom, style: .date)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.gray)
            }
            
        }
        .padding(12)
    }

}

#Preview {
    ActivityView(
        title: "Some activity",
        location: "Somewhere",
        dateFrom: Date(),
        dateTo: Date(),
        storage: .local
    )
}

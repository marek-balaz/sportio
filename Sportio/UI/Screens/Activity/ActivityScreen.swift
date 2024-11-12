//
//  ActivityScreen.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation
import SwiftUI

struct ActivityScreen: View {
    
    @Environment(\.di) private var di
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewState: ActivityState = ActivityState()
    
    let onSave: ClosureWrapper2
    
    var body: some View {
        content
            .navigationTitle(viewState.title())
            .alert(isPresented: $viewState.apiError.1) {
                Alert(
                    title: Text("\(viewState.apiError.0?.localizedDescription ?? NSLocalizedString("global_not_available", comment: ""))"),
                    dismissButton: .default(Text(LocalizedStringKey("global_ok")))
                )
            }
    }
    
}

// MARK: - UI

extension ActivityScreen {
    var content: some View {
        ZStack {
            form
            saveBtn
        }
    }
    
    var form: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                InputDecorationView(hint: String(localized: "activity_form_name")) {
                    FormularTextField(
                        text: $viewState.activityName
                    )
                }
                
                InputDecorationView(hint: String(localized: "activity_form_location")) {
                    FormularTextField(
                        text: $viewState.location
                    )
                }
                
                InputDecorationView(hint: String(localized: "activity_form_date_from")) {
                    DatePicker("", selection: $viewState.dateFrom)
                        .fixedSize()
                        .padding(.horizontal, -8)
                }

                InputDecorationView(hint: String(localized: "activity_form_date_to")) {
                    DatePicker("", selection: $viewState.dateTo)
                        .fixedSize()
                        .padding(.horizontal, -8)
                }
                
                InputDecorationView(hint: String(localized: "activity_form_storage")) {
                    Picker("", selection: $viewState.storage) {
                        ForEach([Storage.local, Storage.remote], id: \.self) { segment in
                            Text(segment.rawValue).tag(segment)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .padding()
        }
    }
    
    var saveBtn: some View {
        Button(String(localized: "activity_save_btn")) {
            if viewState.validate() {
                addActivityRecord()
            } else {
                viewState.apiError = (AppError.domain(.presentation(.notValid)), true)
            }
        }
        .buttonStyle(.primary, stretched: true)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
}

// MARK: - API

extension ActivityScreen {
    
    func addActivityRecord() {
        guard let userId = di.appState[\.userData.userProfile].value?.id else {
            return
        }
        
        di.services.activityRecordService.add(
            activityRecord: .init(
                userId: userId,
                sportName: viewState.activityName,
                dateFrom: viewState.dateFrom,
                dateTo: viewState.dateTo,
                location: viewState.location,
                lat: nil, // TODO: in future
                lon: nil,
                timestamp: Date()
            ),
            storage: viewState.storage
        )
        .receive(on: DispatchQueue.main)
        .sink { result in
            switch result {
            case .finished:
                onSave.callback()
                dismiss()
            case .failure(let e):
                viewState.apiError = (e, true)
            }
        } receiveValue: { _ in
            // skip
        }
        .store(in: viewState.cancelBag)
    }
    
}

#Preview {
    ActivityScreen(onSave: .init(callback: {
        // skip
    }))
}

//
//  OverviewScreen.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation
import SwiftUI
import Combine

struct OverviewScreen: View {
    
    @Environment(\.di) private var di
    
    @State private var cancelBag = CancelBag()
    
    @State private var apiError: (Error?, Bool) = (nil, false)
    
    // Impl
    
    @State private var selectedStorage: Storage = .both

    @State private var activityRecords: Loadable<[ActivityRecord]> = .notRequested
    
    var body: some View {
        
        content
            .alert(isPresented: $apiError.1) {
                Alert(
                    title: Text("\(apiError.0?.localizedDescription ?? NSLocalizedString("global_not_available", comment: ""))"),
                    dismissButton: .default(Text(LocalizedStringKey("global_ok")))
                )
            }
            .background {
                Rectangle()
                    .fill(Color("primary-2"))
                    .frame(height: 200)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .ignoresSafeArea()
            }
            .onFirstAppear {
                loadActivityRecords()
            }
    }
    
}

// MARK: - UI

extension OverviewScreen {
    
    @ViewBuilder
    var content: some View {
        VStack {
            greeting
            
            switch activityRecords {
            case .notRequested, .isLoading:
                ProgressView()
            case .loaded(let records):
                if records.isEmpty {
                    PlaceholderView(title: String(localized: "activity_empty"))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    filter
                    
                    activities(records)
                }
            case .failed(let e):
                PlaceholderView(title: e.localizedDescription) {
                    Button {
                        loadActivityRecords()
                    } label: {
                        Text(String(localized: "global_try_again"))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    var filter: some View {
        Picker("", selection: $selectedStorage) {
            ForEach(Storage.allCases, id: \.self) { segment in
                Text(segment.name).tag(segment)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .background(Color.white.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal)
    }
    
    var greeting: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(String(localized: "activity_subtitle"))
                    .font(.system(size: 16))
                    .foregroundStyle(Color.gray)
                
                Spacer()
                
                Button {
                    let callback = ClosureWrapper2 {
                        loadActivityRecords()
                    }
                    di.appState[\.routerOverview].append(.addNewActivity(callback))
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.white)
                }
            }
            Text(String(localized: "activity_header"))
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color.white)
        }
        .padding()
        .background {
            Color("primary-2")
        }
    }
    
    func activities(_ activityRecords: [ActivityRecord]) -> some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filterByStorage(activityRecords), id: \.id) { activityRecord in
                    ActivityView(
                        title: activityRecord.sportName,
                        location: activityRecord.location,
                        dateFrom: activityRecord.dateFrom,
                        dateTo: activityRecord.dateTo,
                        storage: activityRecord.source
                    )
                }
            }
        }
    }
    
}

extension OverviewScreen {
    
    func filterByStorage(_ activityRecords: [ActivityRecord]) -> [ActivityRecord] {
        switch selectedStorage {
        case .both:
            return activityRecords
        case .local, .remote:
            return activityRecords.filter{ $0.source == selectedStorage }
        }
    }
    
    func loadActivityRecords() {
        activityRecords.setIsLoading(cancelBag: cancelBag)
        di.services.activityRecordService.loadActivityRecords()
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .finished:
                    break
                case .failure(let e):
                    activityRecords = .failed(e)
                }
            } receiveValue: { records in
                withAnimation {
                    activityRecords = .loaded(records)
                }
            }
            .store(in: cancelBag)
    }

}

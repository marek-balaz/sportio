//
//  ActivityState.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation
import Combine

class ActivityState: ObservableObject {
    
    @Published
    var apiError: (Error?, Bool) = (nil, false)
    
    @Published
    var isLoading: Bool = false
    
    @Published
    var cancelBag = CancelBag()
    
    @Published
    var acitivtyRecord: ActivityRecord?
    
    @Published
    var activityName: String = ""
    
    @Published
    var location: String = ""
    
    @Published
    var dateFrom: Date = Date()
    
    @Published
    var dateTo: Date = Date()
    
    @Published
    var storage: Storage = .remote
    
    init(activityRecord: ActivityRecord? = nil) {
        if let activityRecord {
            self.acitivtyRecord = activityRecord
            self.activityName = activityRecord.sportName
            self.location = activityRecord.location
            self.dateFrom = activityRecord.dateFrom
            self.dateTo = activityRecord.dateTo
            self.storage = activityRecord.source
        }
    }
    
    func validate() -> Bool {
        !activityName.isEmpty && !location.isEmpty
    }
    
    func title() -> String {
        acitivtyRecord == nil ? String(localized: "activity_add_title") : String(localized: "activity_edit_title")
    }
    
}

//
//  ActivityRecord.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation
import Alamofire
import CoreData

struct ActivityRecord: Codable, Equatable, Hashable, Sendable {
    
    let recordId: UUID
    
    let userId: UUID
    
    let sportName: String
    
    let dateFrom: Date
    
    let dateTo: Date
    
    let location: String
    
    let lat: Double?
    
    let lon: Double?
    
    let timestamp: Date
    
    var source: Storage = .local
    
    enum CodingKeys: String, CodingKey {
        case recordId
        case userId
        case sportName
        case dateFrom
        case dateTo
        case location
        case lat
        case lon
        case timestamp
    }
    
    init(recordId: UUID = UUID(), userId: UUID, sportName: String, dateFrom: Date, dateTo: Date, location: String, lat: Double?, lon: Double?, timestamp: Date) {
        self.recordId = recordId
        self.userId = userId
        self.sportName = sportName
        self.dateFrom = dateFrom
        self.dateTo = dateTo
        self.location = location
        self.lat = lat
        self.lon = lon
        self.timestamp = timestamp
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let recordIdString = try values.decode(String.self, forKey: .recordId)
        guard let recordId = UUID(uuidString: recordIdString) else {
            throw DecodingError.dataCorruptedError(forKey: .recordId, in: values, debugDescription: "Invalid UUID string.")
        }
        self.recordId = recordId
        
        let userIdString = try values.decode(String.self, forKey: .userId)
        guard let userId = UUID(uuidString: userIdString) else {
            throw DecodingError.dataCorruptedError(forKey: .userId, in: values, debugDescription: "Invalid UUID string.")
        }
        self.userId = userId
        
        sportName = try values.decode(String.self, forKey: .sportName)
        dateFrom = try values.decode(Date.self, forKey: .dateFrom)
        dateTo = try values.decode(Date.self, forKey: .dateTo)
        location = try values.decode(String.self, forKey: .location)
        lat = try values.decodeIfPresent(Double.self, forKey: .lat)
        lon = try values.decodeIfPresent(Double.self, forKey: .lon)
        timestamp = try values.decode(Date.self, forKey: .timestamp)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(sportName, forKey: .sportName)
        try container.encode(dateFrom, forKey: .dateFrom)
        try container.encode(dateTo, forKey: .dateTo)
        try container.encode(location, forKey: .location)
        try container.encodeIfPresent(lat, forKey: .lat)
        try container.encodeIfPresent(lon, forKey: .lon)
        try container.encode(timestamp, forKey: .timestamp)
    }
}

extension ActivityRecord {
    var id: UUID { recordId }
}

extension ActivityRecordMO: ManagedEntity { }

extension ActivityRecord {
    
    init?(managedObject: ActivityRecordMO) {
        guard
            let recordId = managedObject.recordId,
            let userId = managedObject.user?.userId,
            let sportName = managedObject.sportName,
            let dateFrom = managedObject.dateFrom,
            let dateTo = managedObject.dateTo,
            let location = managedObject.location,
            let timestamp = managedObject.timestamp
        else {
            return nil
        }
        
        self.init(
            recordId: recordId,
            userId: userId,
            sportName: sportName,
            dateFrom: dateFrom,
            dateTo: dateTo,
            location: location,
            lat: managedObject.lat,
            lon: managedObject.lon,
            timestamp: timestamp
        )
    }
    
    @discardableResult
    func store(in context: NSManagedObjectContext,
               user: UserProfileMO
    ) -> ActivityRecordMO? {
        guard let activityRecord = ActivityRecordMO.insertNew(in: context)
            else { return nil }
        activityRecord.recordId = recordId
        activityRecord.user = user
        activityRecord.dateFrom = dateFrom
        activityRecord.dateTo = dateTo
        activityRecord.location = location
        activityRecord.sportName = sportName
        if let lat, let lon {
            activityRecord.lat = lat
            activityRecord.lon = lon
        }
        activityRecord.timestamp = timestamp
        return activityRecord
    }
    
}

//
//  UserProfile.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation
import CoreData
import UIKit
import SwiftUI

struct UserProfile: Equatable, Hashable {

    let userId: UUID
    
    let name: String
    
    let avatar: Data?
    
    let birthDate: Date
    
    let weight: Double
    
    let height: Double
    
}

extension UserProfile: Identifiable {
    var id: UUID { userId }
}

extension UserProfile {
    func avatarImg() -> Image? {
        guard let data = avatar, let avatar = UIImage(data: data) else { return nil }
        return Image(uiImage: avatar)
    }
}

extension UserProfileMO: ManagedEntity { }

extension UserProfile {
    
    init?(managedObject: UserProfileMO) {
        guard
            let id = managedObject.userId,
            let name = managedObject.name,
            let birthDate = managedObject.birthDate
        else {
            return nil
        }
        
        self.init(
            userId: id,
            name: name,
            avatar: managedObject.avatar,
            birthDate: birthDate,
            weight: managedObject.weight,
            height: managedObject.height
        )
    }
    
    @discardableResult
    func store(in context: NSManagedObjectContext) -> UserProfileMO? {
        guard let userProfile = UserProfileMO.insertNew(in: context)
            else { return nil }
        userProfile.userId = userId
        userProfile.name = name
        userProfile.avatar = avatar
        userProfile.birthDate = birthDate
        userProfile.weight = weight
        userProfile.height = height
        return userProfile
    }
    
}

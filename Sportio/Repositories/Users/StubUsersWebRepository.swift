//
//  StubUsersWebRepository.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation
import Alamofire

struct StubUsersWebRepository: UsersWebRepository {
    
    var session: Session
    
    var baseURL: String
    
    var bgQueue: DispatchQueue
    
    init() {
        self.session = .init(configuration: .default)
        self.baseURL = Const.getStringFor(key: "SupabaseAPI")
        self.bgQueue = .init(label: "bg.queue")
    }
    
}

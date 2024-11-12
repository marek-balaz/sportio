//
//  DIContainer.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import SwiftUI
import SwiftData

struct DIContainer: EnvironmentKey {
    
    let appState: Store<AppState>
    let services: Services
    let repositories: Repositories
    
    init(appState: Store<AppState>, services: Services, repositories: Repositories) {
        self.appState = appState
        self.services = services
        self.repositories = repositories
    }
    
    init(appState: AppState, services: Services, repositories: Repositories) {
        self.init(appState: Store<AppState>(appState), services: services, repositories: repositories)
    }
    
    static var defaultValue: Self {
        Self.default
    }
    
    private static let `default` = Self(
        appState: .preview,
        services: .stub,
        repositories: .stub
    )
}

extension EnvironmentValues {
    
    var di: DIContainer {
        get { self[DIContainer.self] }
        set { self[DIContainer.self] = newValue }
    }
}

extension DIContainer {
    
    struct Services {
        
        let loginService: LoginService
        let usersService: UsersService
        let activityRecordService: ActivityRecordService
        
        static let stub = Self(
            loginService: StubLoginService(),
            usersService: StubUsersService(),
            activityRecordService: StubActivityRecordService()
        )
    }
    
    struct Repositories {
        
        let loginWebRepository: LoginWebRepository
        let usersRepository: UsersDBRepository
        let activityRecordWebRepository: ActivityRecordWebRepository
        let acitvityRecordDBRepository: ActivityRecordDBRepository
        
        static let stub = Self(
            loginWebRepository: StubLoginWebRepository(),
            usersRepository: StubUsersDBRepository(),
            activityRecordWebRepository: StubActivityRecordWebRepository(),
            acitvityRecordDBRepository: StubActivityRecordDBRepository()
        )
    }
    
    static let preview = Self(
        appState: .preview,
        services: .stub,
        repositories: .stub
    )
}

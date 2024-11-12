//
//  AppEnvironment.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation
import Alamofire

struct AppEnvironment {
    
    let container: DIContainer
    
}

extension AppEnvironment {
    
    static func bootstrap() -> AppEnvironment {
        
        let appState = Store<AppState>(
            AppState(
                system: .init(
                    locale: .init(identifier: UserDefaults.standard.userLocale ?? ""),
                    theme: .init(rawValue: UserDefaults.standard.userTheme)
                )
            )
        )
        
        let repositories = dbRepositories(appState: appState)
        
        return AppEnvironment(
            container: .init(
                
                appState: appState,
                
                services: services(appState: appState, dbRepositories: repositories),
                
                repositories: repositories
            )
        )
    }
    
    private static func services(
        appState: Store<AppState>,
        dbRepositories: DIContainer.Repositories
    ) -> DIContainer.Services {
        
        let loginService = LoginServiceImpl(
            appState: appState,
            loginRepository: dbRepositories.loginWebRepository,
            usersRepository: dbRepositories.usersRepository
        )
        
        let usersService = UsersServiceImpl(
            appState: appState,
            usersRepository: dbRepositories.usersRepository
        )
        
        let activityRecordService = ActivityRecordServiceImpl(
            appState: appState,
            activityRecordWebRepository: dbRepositories.activityRecordWebRepository,
            activityRecordDBRepository: dbRepositories.acitvityRecordDBRepository
        )
        
        return .init(
            loginService: loginService,
            usersService: usersService,
            activityRecordService: activityRecordService
        )
    }
    
    private static func dbRepositories(
        appState: Store<AppState>
    ) -> DIContainer.Repositories {
        
        let session = configuredURLSession()
        
        let persistentStore = CoreDataStack(version: CoreDataStack.Version.actual)
        
        let loginWebRepository = LoginWebRepositoryImpl(
            session: session,
            baseURL: Const.getStringFor(key: "SupabaseAPI")
        )
        
        let usersDBRepository = UsersDBRepositoryImpl(persistentStore: persistentStore)
        
        let activityRecordWebRepository = ActivityRecordWebRepositoryImpl(
            session: session,
            baseURL: Const.getStringFor(key: "SupabaseAPI")
        )
        
        let activityRecordDBRepository = ActivityRecordDBRepositoryImpl(
            persistentStore: persistentStore
        )
        
        return .init(
            loginWebRepository: loginWebRepository,
            usersRepository: usersDBRepository,
            activityRecordWebRepository: activityRecordWebRepository,
            acitvityRecordDBRepository: activityRecordDBRepository
        )
    }
        
    private static func configuredURLSession() -> Session {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .reloadRevalidatingCacheData
        configuration.urlCache = .shared
        return Alamofire.Session(configuration: configuration)
    }

}

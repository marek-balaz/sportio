//
//  UserProfileService.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation
import Combine

protocol UsersService {
    
    func getSelectedUser(id: UUID?)
    
    func addUser(_ userProfile: UserProfile) -> AnyPublisher<Void, Error>
    
    func editUser(_ userProfile: UserProfile) -> AnyPublisher<Void, Error>
    
    func deleteUser(_ id: UUID) -> AnyPublisher<Void, Error>
    
    func fetchUsers(search: String) -> AnyPublisher<[UserProfile], Error>
    
}

struct UsersServiceImpl: UsersService {
    
    let appState: Store<AppState>
    
    let usersRepository: UsersDBRepository
    
    init(
        appState: Store<AppState>,
        usersRepository: UsersDBRepository
    ) {
        self.appState = appState
        self.usersRepository = usersRepository
    }
    
    func getSelectedUser(id: UUID? = nil) {
        let userId = id?.uuidString ?? UserDefaults.standard.userSelectedProfileId
        
        let cancelBag = CancelBag()
        appState[\.userData.userProfile].setIsLoading(cancelBag: cancelBag)
        
        fetchUsers(search: "")
            .receive(on: DispatchQueue.main)
            .sink { event in
                if case let .failure(error) = event {
                    appState[\.userData.userProfile] = .failed(error)
                }
            } receiveValue: {
                guard let profile = $0.first(where: { $0.id.uuidString == userId }) ?? $0.first else {
                    appState[\.userData.userProfile] = .failed(AppError.domain(.business(.userNotFound)))
                    return
                }
                
                appState[\.userData.userProfile] = .loaded(profile)
            }
            .store(in: cancelBag)
    }
    
    func addUser(_ userProfile: UserProfile) -> AnyPublisher<Void, Error> {
        return usersRepository.store(userProfile: userProfile)
    }
    
    func editUser(_ userProfile: UserProfile) -> AnyPublisher<Void, Error> {
        return usersRepository.edit(userProfile: userProfile)
    }
    
    func deleteUser(_ id: UUID) -> AnyPublisher<Void, Error> {
        return usersRepository.delete(userProfileId: id)
    }
    
    func fetchUsers(search: String) -> AnyPublisher<[UserProfile], Error> {
        return usersRepository.fetch(search: search)
    }
    
}

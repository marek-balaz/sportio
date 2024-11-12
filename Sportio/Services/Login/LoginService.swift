//
//  LoginService.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation
import Combine
import Alamofire

protocol LoginService {
    
    func refreshToken(completion: @escaping (Result<Void, Error>) -> Void)
    
    func anonLogin(completion: @escaping (Result<Void, Error>) -> Void)
    
}

struct LoginServiceImpl: LoginService {
    
    static let shared = LoginServiceImpl(
        appState: .init(.preview),
        loginRepository: LoginWebRepositoryImpl(
            session: Alamofire.Session(configuration: .default),
            baseURL: Const.getStringFor(key: "SupabaseAPI")
        ),
        usersRepository: StubUsersDBRepository()
    )

    let appState: Store<AppState>
    
    let loginRepository: LoginWebRepository
    
    let usersRepository: UsersDBRepository
    
    let cancelBag: CancelBag = .init()
    
    init(
        appState: Store<AppState>,
        loginRepository: LoginWebRepository,
        usersRepository: UsersDBRepository
    ) {
        self.appState = appState
        self.loginRepository = loginRepository
        self.usersRepository = usersRepository
    }
    
    func refreshToken(completion: @escaping (Result<Void, Error>) -> Void) {
        loginRepository.refreshToken()
            .sink { result in
                switch result {
                case .finished:
                    completion(.success(()))
                case .failure(let e):
                    completion(.failure(e))
                }
            } receiveValue: { response in
                UserDefaults.standard.accessToken = response.accessToken
                UserDefaults.standard.refreshToken = response.refreshToken
            }
            .store(in: cancelBag)
    }
    
    func anonLogin(completion: @escaping (Result<Void, Error>) -> Void) {
        loginRepository.anonLogin()
            .flatMap { response -> AnyPublisher<Void, Error> in
                UserDefaults.standard.accessToken = response.accessToken
                UserDefaults.standard.refreshToken = response.refreshToken

                // TODO: refactor
                let userProfile = UserProfile(
                    userId: UUID(uuidString: response.user.id)!,
                    name: "",
                    avatar: nil,
                    birthDate: Date(),
                    weight: 0,
                    height: 0
                )
                
                return usersRepository.store(userProfile: userProfile)
            }
            .sink { result in
                switch result {
                case .finished:
                    completion(.success(()))
                case .failure(let e):
                    completion(.failure(e))
                }
            } receiveValue: { _ in
                // skip
            }
            .store(in: cancelBag)
    }

    
}

//
//  NetworkInterceptor.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Combine
import Foundation
import Alamofire

@propertyWrapper
struct Atomic<Value> {
    private var value: Value
    private let lock = NSLock()

    init(wrappedValue: Value) {
        self.value = wrappedValue
    }

    var wrappedValue: Value {
        get {
            lock.lock()
            defer { lock.unlock() }
            return value
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            value = newValue
        }
    }
}

final class NetworkInterceptor: RequestInterceptor, @unchecked Sendable {
    
    let retryLimit = 3
    
    let retryDelay: TimeInterval = 2
    
    @Atomic
    private var isRetrying = false
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var urlRequest = urlRequest

        if let accessToken = UserDefaults.standard.accessToken {
            urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "authorization")
        }
        
        urlRequest.setValue(APIKeys.supabase, forHTTPHeaderField: "apikey")
        completion(.success(urlRequest))
    }
    
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        let response = request.task?.response as? HTTPURLResponse
        if request.retryCount < self.retryLimit {
            guard let statusCode = response?.statusCode else {
                // Handle the case when there is no valid response (e.g., network timeouts)
                completion(.retryWithDelay(self.retryDelay))
                return
            }
            
            if statusCode == 401, !isRetrying {
                self.isRetrying = true
                self.determineError(
                    for: session,
                    error: error,
                    completion: completion
                )
            } else if statusCode >= 500, !isRetrying {
                completion(.retryWithDelay(self.retryDelay))
            } else {
                session.cancelAllRequests()
                completion(.doNotRetry)
            }
        } else {
            // Exceeded retry limit, do not retry
            session.cancelAllRequests()
            completion(.doNotRetry)
        }
    }
        
    private func determineError(
        for session: Session,
        error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        if let afError = error as? AFError {
            switch afError {
            case .responseValidationFailed(let reason):
                self.determineResponseValidationFailed(
                    for: session,
                    reason: reason,
                    completion: completion
                )
            default:
                self.isRetrying = false
                completion(.retryWithDelay(self.retryDelay))
            }
        }
    }
        
    private func determineResponseValidationFailed(
        for session: Session,
        reason: AFError.ResponseValidationFailureReason,
        completion: @escaping (RetryResult) -> Void
    ) {
        switch reason {
        case .unacceptableStatusCode(let code):
            switch code {
            case 401:
                LoginServiceImpl.shared.refreshToken { _ in
                    self.isRetrying = false
                    completion(.retryWithDelay(self.retryDelay))
                }
            default:
                self.isRetrying = false
                session.cancelAllRequests()
                // Redirect to the login page
                completion(.doNotRetry)
            }
        default:
            self.isRetrying = false
            completion(.retryWithDelay(self.retryDelay))
        }
    }
}

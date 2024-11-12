//
//  WebRepository.swift
//  Sportio
//
//  Created by Marek Baláž on 10/11/2024.
//

import Foundation
import Alamofire
import Combine

protocol WebRepository {
    
    var session: Session { get }
    
    var baseURL: String { get }
    
    var bgQueue: DispatchQueue { get }
    
}

extension WebRepository {
    
    func request<T: Decodable, B: Encodable>(
        path: String,
        method: HTTPMethod,
        body: B? = Optional<Bool>.none,
        headers: [String: String] = [:]
    ) -> AnyPublisher<T, Error> {
        return Future { promise in
            let interceptor = NetworkInterceptor()
            
            var requestBody: Parameters?
            if let body = body {
                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = .iso8601
                encoder.keyEncodingStrategy = .convertToSnakeCase
                
                do {
                    let jsonData = try encoder.encode(body)
                    requestBody = try JSONSerialization.jsonObject(with: jsonData, options: []) as? Parameters
                } catch {
                    promise(.failure(error))
                    return
                }
            }
            
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            session.request(
                baseURL.path(path),
                method: method,
                parameters: requestBody,
                encoding: JSONEncoding.default,
                headers: HTTPHeaders(headers),
                interceptor: interceptor
            )
            .cURLDescription(calling: { curl in
                Log.d(curl)
            })
            .validate()
            .customValidate(of: T.self, decoder: decoder)
            .responseDecodable(
                of: T.self,
                decoder: decoder,
                emptyResponseCodes: .init([201])
            ) { response in
                switch response.result {
                case .success(let value):
                    promise(.success(value))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .extractUnderlyingError()
        .eraseToAnyPublisher()
    }
}

extension String {
    func path(_ path: String = "") -> String {
        [self, path].joined(separator: "/")
    }
}

extension DataRequest {
    func customValidate<Value>(of type: Value.Type = Value.self, decoder: JSONDecoder) -> Self where Value: Decodable {
        return self.validate { request, response, data -> Request.ValidationResult in
            if let data = data {
                do {
                    _ = try decoder.decode(type.self, from: data)
                } catch {
                    dump(error)
                }
                
                if let jsonString = String(data: data, encoding: .utf8) {
                    Log.d("JSON payload: \(jsonString)")
                }
            }
            let statusCode = response.statusCode
            if statusCode != 401 {
                return .success(())
            } else {
                return .failure(AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: statusCode)))
            }
        }
    }
}

private extension Error {
    var underlyingError: Error? {
        let nsError = self as NSError
        if nsError.domain == NSURLErrorDomain && nsError.code == -1009 {
            // "The Internet connection appears to be offline."
            return self
        }
        return nsError.userInfo[NSUnderlyingErrorKey] as? Error
    }
}

extension Publisher {
    func extractUnderlyingError() -> Publishers.MapError<Self, Failure> {
        mapError {
            ($0.underlyingError as? Failure) ?? $0
        }
    }
}


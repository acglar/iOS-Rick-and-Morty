//
//  RMService.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 23.05.2023.
//

import Foundation

final class RMService {
    static let instance = RMService()
    
    private init() { }
    
    /// Sends API call
    /// - Parameters:
    ///   - request: Instance of the request
    ///   - type: The of the object we expect to return
    ///   - onComplete: Callback with data or error
    public func execute<T: Codable>(_ request: RMRequest, expecting type: T.Type, onComplete: @escaping (Result<T, Error>) -> Void) {
        guard let urlRequest = self.request(from: request) else {
            onComplete(.failure(RMServiceError.failedToCreateRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data, error == nil else {
                onComplete(.failure(error ?? RMServiceError.failedToGetData))
                return
            }
            
            // Decode response
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                onComplete(.success(result))
            } catch {
                onComplete(.failure(error))
            }
        }
        task.resume()
    }
    
    private func request(from rmRequest: RMRequest) -> URLRequest? {
        guard let url = rmRequest.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        return request
    }
}

//
//  RMService.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 23.05.2023.
//

import Foundation

final class RMService {
    static let instance = RMService()
    
    private let cacheManager = RMAPICacheManager()
    
    private init() { }
    
    /// Sends API call
    /// - Parameters:
    ///   - request: Instance of the request
    ///   - type: The of the object we expect to return
    ///   - onComplete: Callback with data or error
    public func execute<T: Codable>(_ request: RMRequest, expecting type: T.Type, onComplete: @escaping (Result<T, Error>) -> Void) {
        if let cachedData = cacheManager.cachedResponse(for: request.endPoint, url: request.url) {
            do {
                let result = try JSONDecoder().decode(type.self, from: cachedData)
                onComplete(.success(result))
            } catch {
                onComplete(.failure(error))
            }
            
            return
        }
        
        guard let urlRequest = self.request(from: request) else {
            onComplete(.failure(RMServiceError.failedToCreateRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                onComplete(.failure(error ?? RMServiceError.failedToGetData))
                return
            }
            
            // Decode response
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                self?.cacheManager.setCache(for: request.endPoint, url: request.url, data: data)
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

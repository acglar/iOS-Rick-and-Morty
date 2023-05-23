//
//  RMRequest.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 23.05.2023.
//

import Foundation

final class RMRequest {
    private let endPoint: RMEndpoint
    private let pathComponents: Set<String>
    private let queryParameters: [URLQueryItem]
    
    private var urlString: String {
        var components: String = ""
        var queries: String = ""
        
        if !pathComponents.isEmpty {
            components = pathComponents.joined(separator: "/")
        }
        
        if !queryParameters.isEmpty {
            let argument = queryParameters.compactMap({
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            
            queries = "?\(argument)"
        }
        
        return "\(Constants.baseUrl)/\(endPoint.rawValue)/\(components)\(queries)"
    }
    
    public var url: URL? {
        return URL(string: urlString)
    }
    
    public let httpMethod = "GET"
    
    public init(endPoint: RMEndpoint, pathComponents: Set<String> = [], queryParameters: [URLQueryItem] = []) {
        self.endPoint = endPoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
    private struct Constants {
        static let baseUrl: String = "https://rickandmortyapi.com/api"
    }
}

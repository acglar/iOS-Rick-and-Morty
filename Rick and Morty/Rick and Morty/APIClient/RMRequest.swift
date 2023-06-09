//
//  RMRequest.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 23.05.2023.
//

import Foundation

final class RMRequest {
    public let endPoint: RMEndpoint
    private let pathComponents: [String]
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
    
    public init(endPoint: RMEndpoint, pathComponents: [String] = [], queryParameters: [URLQueryItem] = []) {
        self.endPoint = endPoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl) {
            return nil
        }
        let trimmed = string.replacingOccurrences(of: Constants.baseUrl+"/", with: "")
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointString = components[0] // Endpoint
                var pathComponents: [String] = []
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst()
                }
                if let rmEndpoint = RMEndpoint(
                    rawValue: endpointString
                ) {
                    self.init(endPoint: rmEndpoint, pathComponents: pathComponents)
                    return
                }
            }
        } else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endpointString = components[0]
                let queryItemsString = components[1]
                // value=name&value=name
                let queryItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else {
                        return nil
                    }
                    let parts = $0.components(separatedBy: "=")
                    
                    return URLQueryItem(
                        name: parts[0],
                        value: parts[1]
                    )
                })
                
                if let rmEndpoint = RMEndpoint(rawValue: endpointString) {
                    self.init(endPoint: rmEndpoint, queryParameters: queryItems)
                    return
                }
            }
        }
        
        return nil
    }
    
    private struct Constants {
        static let baseUrl: String = "https://rickandmortyapi.com/api"
    }
}

extension RMRequest {
    static let listCharactersRequest = RMRequest(endPoint: .character)
    static let listEpisodesRequest = RMRequest(endPoint: .episode)
}

//
//  File.swift
//  
//
//  Created by Ahmed Yamany on 17/07/2024.
//

import Foundation

public protocol APIClient {
    associatedtype EndpointType: APIEndPoint
    associatedtype ResponseType: Decodable
    
    func request(_ endpoint: EndpointType) async throws -> ResponseType
}

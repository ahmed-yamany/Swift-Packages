//
//  File.swift
//  
//
//  Created by Ahmed Yamany on 14/07/2024.
//

import Foundation

public typealias Parameters = [String: Any]

public protocol APIEndPoint {
    var url: String { get }
    var method: APIHTTPMethod { get }
    var query: Parameters? { get }
    var body: Parameters? { get }
    var headers: [String: String] { get }
}

//
//  File.swift
//
//
//  Created by Ahmed Yamany on 18/07/2024.
//

import Foundation

public enum APIHTTPMethod: String, CaseIterable {
    case connect = "CONNECT"
    case delete = "DELETE"
    case get = "GET"
    case head = "HEAD"
    case options = "OPTIONS"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
    case query = "QUERY"
    case trace = "TRACE"
}

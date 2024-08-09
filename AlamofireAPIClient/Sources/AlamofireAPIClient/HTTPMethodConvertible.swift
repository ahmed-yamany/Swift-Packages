//
//  HTTPMethodConvertible.swift
//  
//
//  Created by Ahmed Yamany on 18/07/2024.
//

import Foundation
import Alamofire
import APIClient

protocol HTTPMethodConvertible {
    func asHTTPMethod() -> HTTPMethod
}

extension APIHTTPMethod: HTTPMethodConvertible {
    func asHTTPMethod() -> HTTPMethod {
        switch self {
            case .connect: .connect
            case .delete: .delete
            case .get: .get
            case .head: .head
            case .options: .options
            case .patch: .patch
            case .post: .post
            case .put: .put
            case .query: .query
            case .trace: .trace
        }
    }
}

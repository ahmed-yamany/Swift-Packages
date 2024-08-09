//
//  AlamofireAPIClient.swift
//  
//
//  Created by Ahmed Yamany on 18/07/2024.
//

import Foundation
import Alamofire
import APIClient

public typealias AlamofireAPIClientError = Error & Decodable

open class AlamofireAPIClient<
    EndpointType: APIEndPoint,
    ResponseType: Decodable,
    ErrorResponseType: AlamofireAPIClientError
>: APIClient {
    
    public init() {}
    
    public func request(_ endpoint: EndpointType) async throws -> ResponseType {
        let method: HTTPMethod = endpoint.method.asHTTPMethod()
        let encoding = encoding(for: method)
        let parameters = parameters(for: endpoint)
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                endpoint.url,
                method: method,
                parameters: parameters,
                encoding: encoding,
                headers: HTTPHeaders(endpoint.headers)
            ).responseDecodable(of: ResponseType.self) { response in
                switch response.result {
                    case let .success(data):
                        continuation.resume(returning: data)
                    case let .failure(error):
                        if let data = response.data,
                           let errorResponse = try? JSONDecoder().decode(ErrorResponseType.self, from: data) {
                            continuation.resume(throwing: errorResponse)
                        } else {
                            continuation.resume(throwing: error)
                        }
                }
            }
        }
    }
    
    private func encoding(for method: HTTPMethod) -> ParameterEncoding {
        method == .get ? URLEncoding.default : JSONEncoding.default
    }
    
    private func parameters(for endpoint: EndpointType) -> Parameters? {
        endpoint.method == .get ? endpoint.query : endpoint.body
    }
}

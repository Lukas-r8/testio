//
//  Request.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol Request {
    var method: HTTPMethod { get }
    var queryParams: [URLQueryItem] { get }
    var body: Data? { get }
    var path: String { get }
}

extension Request {
    func configure(_ urlRequest: inout URLRequest) {
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = body
        urlRequest.url?.append(path: path)
        urlRequest.url?.append(queryItems: queryParams)
    }
}

struct GetRequest: Request {
    var method: HTTPMethod { .get }
    let queryParams: [URLQueryItem] = []
    let body: Data? = nil
    let path: String
}

struct PostRequest: Request {
    var method: HTTPMethod { .post }
    var queryParams: [URLQueryItem] = []
    var body: Data?
    var path: String
}

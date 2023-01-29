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
}

protocol Request {
    var method: HTTPMethod { get }
    var path: String { get }
    func configure(_ urlRequest: inout URLRequest)
}

struct GetRequest: Request {
    let method: HTTPMethod = .get
    let path: String
    let queryParams: [URLQueryItem] = []

    func configure(_ urlRequest: inout URLRequest) {
        urlRequest.httpMethod = method.rawValue
        urlRequest.url?.append(path: path)
        urlRequest.url?.append(queryItems: queryParams)
    }
}

struct PostRequest: Request {
    let method: HTTPMethod = .post
    let body: Data?
    let path: String

    func configure(_ urlRequest: inout URLRequest) {
        urlRequest.httpMethod = method.rawValue
        urlRequest.url?.append(path: path)
        urlRequest.httpBody = body
    }
}

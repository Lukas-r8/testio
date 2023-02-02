//
//  RequestSession.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 02.02.23.
//

import Foundation

protocol RequestSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: RequestSession { }

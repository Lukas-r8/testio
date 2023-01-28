//
//  Client.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation

final class APIClient {
    private let baseUrl = "https://playground.tesonet.lt/v1"
    private var token: String = ""

    func send<T: Codable>(_ request: Request) async throws -> T {
        guard var url = URL(string: baseUrl + request.path) else { throw NetworkError.badRequest  }
        url.append(queryItems: request.queryParams)
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            if let error = sanitise(reponse: response) { throw error }
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.unknown(error: error)
        }
    }

    func setToken(_ token: String) {
        self.token = token
    }
}

private extension APIClient {
    func sanitise(reponse: URLResponse) -> NetworkError? {
        .badRequest
    }
}

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
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        if let error = sanitise(response: response) { throw error }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.unknown(description: "Could not parse")
        }
    }

    func setToken(_ token: String) {
        self.token = token
    }
}

private extension APIClient {
    func sanitise(response: URLResponse) -> NetworkError? {
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return nil }
        switch statusCode {
        case 401: return .unauthorized
        default: return nil
        }
    }
}

//
//  Client.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation

final class APIClient {
    private let baseUrl = "https://playground.tesonet.lt/v1"
    private var token: String?

    func send<T: Codable>(_ request: Request) async throws -> T {
        guard let url = URL(string: baseUrl) else { throw NetworkError.badRequest  }
        var urlRequest = URLRequest(url: url)
        token.map { urlRequest.addValue("Bearer \($0)", forHTTPHeaderField: "Authorization")  }
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.configure(&urlRequest)

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            if let error = check(response) { throw error }
            return try JSONDecoder().decode(T.self, from: data)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.unknown(description: error.localizedDescription)
        }
    }

    func setToken(_ token: String?) {
        self.token = token
    }
}

private extension APIClient {
    func check(_ response: URLResponse) -> NetworkError? {
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return nil }
        switch statusCode {
        case 401: return .unauthorized
        default: return nil
        }
    }
}

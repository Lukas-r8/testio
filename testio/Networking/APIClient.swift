//
//  Client.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation

protocol APIClientInterface: AnyObject {
    func send<T: Codable>(_ request: Request) async throws -> T
    func setToken(_ token: String?)
}

final class APIClient: APIClientInterface {
    private let baseUrl = "https://playground.tesonet.lt/v1"
    private var token: String?
    private let requestSession: RequestSession

    init(requestSession: RequestSession = URLSession.shared) {
        self.requestSession = requestSession
    }

    func send<T: Codable>(_ request: Request) async throws -> T {
        guard let url = URL(string: baseUrl) else { throw NetworkError.badRequest  }
        var urlRequest = URLRequest(url: url)
        token.map { urlRequest.addValue("Bearer \($0)", forHTTPHeaderField: "Authorization")  }
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.configure(&urlRequest)

        do {
            let (data, response) = try await requestSession.data(for: urlRequest)
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
        case 401, 403: return .unauthorized
        case 400: return .badRequest
        case 500: return .serverError
        case 404: return .notFound
        case 200 ... 299: return nil
        default: return .unknown(description: "Failed with status code \(statusCode)")
        }
    }
}

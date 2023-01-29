//
//  Repository.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation

protocol Persistable: Codable { }

protocol SecurelyPersistable: Persistable {
    static var uniqueId: String { get }
}

protocol Repository {
    associatedtype Element: Persistable

    func fetch() async throws -> Element
    func save(_ item: Element) async throws
    func delete(_ item: Element) async throws
}

extension Array: Persistable where Element: Persistable { }
extension Optional: Persistable where Wrapped: Persistable { }

extension Optional: SecurelyPersistable where Wrapped: SecurelyPersistable {
    static var uniqueId: String { Wrapped.uniqueId }
}

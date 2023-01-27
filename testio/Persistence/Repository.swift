//
//  Repository.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation

protocol Persistable: Codable {
    var id: String { get }
}

protocol Repository {
    func fetch<T: Persistable>() throws -> T
    func save<T: Persistable>(_ item: T) throws
    func delete<T: Persistable>(_ item: T) throws
    func update<T: Persistable>(_ transform: (T) -> Void) throws
}

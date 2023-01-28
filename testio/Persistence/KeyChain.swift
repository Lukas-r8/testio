//
//  KeyChain.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//

import Foundation

final class KeyChain: Repository {


    func fetch<T: Persistable>() throws -> T {
        fatalError()
    }

    func save<T: Persistable>(_ item: T) throws {
        fatalError()
    }

    func delete<T: Persistable>(_ item: T) throws {
        fatalError()
    }

    func update<T: Persistable>(_ transform: (T) -> Void) throws {
        fatalError()
    }
}

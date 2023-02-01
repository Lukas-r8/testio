//
//  MockDispatcher.swift
//  testioTests
//
//  Created by Lucas Alves Da Silva on 01.02.23.
//

@testable import testio

final class MockDispatcher: Dispatcher {
    static let shared = MockDispatcher()

    private init() { }

    func async(execute work: @escaping () -> Void) {
        work()
    }
}

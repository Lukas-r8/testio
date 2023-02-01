//
//  KeychainTests.swift
//  testioTests
//
//  Created by Lucas Alves Da Silva on 29.01.23.
//

import XCTest
@testable import testio

final class KeychainTests: XCTestCase {
    private let sut = Keychain.default

    override func setUp() {
        super.setUp()
    }

    func testThatKeychainCanSaveAndRetrieve() throws {
        let mock = AuthResponse(token: "an example token")
        try sut.save(mock)
        let retrievedToken = try sut.fetch(AuthResponse.self).token
        XCTAssertEqual(retrievedToken, "an example token")
    }

    func testThatDataIsDeleted() throws {
        let mock = AuthResponse(token: "an example token")
        try sut.save(mock)
        try sut.delete(AuthResponse.self)
        XCTAssertThrowsError(try sut.fetch(AuthResponse.self))
    }
}

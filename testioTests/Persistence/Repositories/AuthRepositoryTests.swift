//
//  AuthRepositoryTests.swift
//  testioTests
//
//  Created by Lucas Alves Da Silva on 31.01.23.
//

import XCTest
@testable import testio

final class AuthRepositoryTests: XCTestCase {
    private var sut: AuthRepository!
    private var keyChain: Keychain!

    private var mockAuthResponse = AuthResponse(token: "a.fake.token")

    override func setUp() {
        super.setUp()
        keyChain = .default
        sut = AuthRepository(keychain: keyChain)

    }

    override func tearDown() {
        super.tearDown()
        keyChain = nil
        sut = nil
    }

    func testThatRepositorySavesEntitY() async throws {
        try sut.save(mockAuthResponse)

        let fetchedEntity = try keyChain.fetch(AuthResponse.self)

        XCTAssertEqual(mockAuthResponse, fetchedEntity)
    }

    func testThatRepositoryFetchesEntity() async throws {
        try keyChain.save(mockAuthResponse)

        let response = try sut.fetch()
        XCTAssertEqual(mockAuthResponse, response)
    }

    func testThatRepositoryDeletesEntity() async throws {
        try keyChain.save(mockAuthResponse)
        try sut.delete(nil)
        let response = try? sut.fetch()
        XCTAssertNil(response)
    }

    func testThatRepositoryUpdatesEntities() async throws {
        try sut.save(mockAuthResponse)
        let responseBeforeUpdate = try sut.fetch()

        let newToken = AuthResponse(token: "a.brand.new.token")
        try sut.save(newToken)

        let responseAfterUpdate = try sut.fetch()

        XCTAssertEqual(responseBeforeUpdate, mockAuthResponse)
        XCTAssertEqual(responseAfterUpdate, newToken)
    }
}

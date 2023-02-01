//
//  ServerDataSourceTests.swift
//  testioTests
//
//  Created by Lucas Alves Da Silva on 31.01.23.
//

import XCTest
@testable import testio

final class ServerDataSourceTests: XCTestCase {
    private var sut: ServerDataSource<MockServerRepository>!
    private var networkService: MockNetworkService<[Server]>!
    private var repository: MockServerRepository!

    private let mockServers = [Server(name: "test1", distance: 123),
                               Server(name: "test2", distance: 456),
                               Server(name: "test3", distance: 789)]

    override func setUp() {
        super.setUp()
        networkService = MockNetworkService()
        repository = MockServerRepository()
        sut = ServerDataSource(networkServicing: networkService, serverRepository: repository)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        networkService = nil
        repository = nil
    }

    func testThatFetchListSucceedsWhenFetchingFromNetwork() async throws {
        networkService.expectedFetchResult = mockServers

        let fetched = try await sut.fetchList(forceRefresh: false)
        XCTAssertEqual(fetched, mockServers)

        XCTAssertEqual(repository.fetchCallCount, 1)
        XCTAssertEqual(networkService.fetchCallCount, 1)

        let getRequest = networkService.fetchCalledWith as! GetRequest
        XCTAssertEqual(getRequest.method, .get)
        XCTAssertEqual(getRequest.path, "/servers")
        XCTAssertEqual(getRequest.queryParams, [])
    }

    func testThatFetchListSucceedsWhenFetchingFromDisk() async throws {
        repository.expectedResponse = [Server(name: "stored1", distance: 111)]

        let fetched = try await sut.fetchList(forceRefresh: false)

        XCTAssertEqual(fetched, [Server(name: "stored1", distance: 111)])
        XCTAssertEqual(repository.fetchCallCount, 1)

        XCTAssertEqual(networkService.fetchCallCount, 0)
        XCTAssertNil(networkService.fetchCalledWith)
    }

    func testThatFetchListSucceedsWhenFetchingFromCacheInMemory() async throws {
        repository.expectedResponse = [Server(name: "stored1", distance: 111)]

        let firstfetchedList = try await sut.fetchList(forceRefresh: false)

        repository.expectedResponse = [Server(name: "stored that should be ignored in favour of memory cache", distance: 111)]

        let secondFetchedList = try await sut.fetchList(forceRefresh: false)

        XCTAssertEqual(firstfetchedList, [Server(name: "stored1", distance: 111)])
        XCTAssertEqual(secondFetchedList, [Server(name: "stored1", distance: 111)])

        XCTAssertEqual(repository.fetchCallCount, 1)
        XCTAssertEqual(networkService.fetchCallCount, 0)
        XCTAssertNil(networkService.fetchCalledWith)
    }

    func testThatFetchWillByPassCacheOnDiskWhenForceRefreshing() async throws {
        networkService.expectedFetchResult = [Server(name: "downloaded1", distance: 999)]
        repository.expectedResponse = [Server(name: "stored1", distance: 111)]

        let fetchedList = try await sut.fetchList(forceRefresh: true)

        XCTAssertEqual(fetchedList, [Server(name: "downloaded1", distance: 999)])
        XCTAssertEqual(repository.fetchCallCount, 1)
        XCTAssertEqual(networkService.fetchCallCount, 1)
        XCTAssertNotNil(networkService.fetchCalledWith)
    }

    func testThatFetchWillByPassCacheInMemoryWhenForceRefreshing() async throws {
        networkService.expectedFetchResult = [Server(name: "downloaded1", distance: 999)]
        repository.expectedResponse = [Server(name: "stored1", distance: 111)]

        let firstfetchedList = try await sut.fetchList(forceRefresh: false)

        repository.expectedResponse = [Server(name: "stored that should be ignored in favour of forceRefresh", distance: 111)]

        let secondFetchedList = try await sut.fetchList(forceRefresh: true)

        XCTAssertEqual(firstfetchedList, [Server(name: "stored1", distance: 111)])
        XCTAssertEqual(secondFetchedList, [Server(name: "downloaded1", distance: 999)])
        XCTAssertEqual(repository.fetchCallCount, 2)
        XCTAssertEqual(networkService.fetchCallCount, 1)
        XCTAssertNotNil(networkService.fetchCalledWith)
    }

    func testThatFetchServerFailsWhenNetworkFails() async {
        networkService.expectedFailure = .serverError
        repository.expectedResponse = []

        let errorThrown = await XCTAssertThrowsAsync(try await sut.fetchList(forceRefresh: false), ofType: AppError.self)

        XCTAssertEqual(errorThrown, .network(.serverError))
    }

    func testThatFetchServerFailsWhenRepositoryFails() async {
        repository.expectedFailure = .fetchFailed(reason: "mock reason!")

        let errorThrown = await XCTAssertThrowsAsync(try await sut.fetchList(forceRefresh: false), ofType: AppError.self)

        XCTAssertEqual(errorThrown, .persistence(.fetchFailed(reason: "mock reason!")))
    }
}

//
//  XCTAssertThrowsAsync.swift
//  testioTests
//
//  Created by Lucas Alves Da Silva on 01.02.23.
//

import XCTest

/// This function asserts not only that an error was thrown but also asserts the type of error and returns the failure for further assertions.
func XCTAssertThrowsAsync<E: Error>(_ function: @autoclosure () async throws -> Any,
                                    ofType errorType: E.Type = Error.self) async -> E? {
    do {
        _ = try await function()
        XCTFail("Function should have failed!")
    } catch let error as E {
        return error
    } catch {
        XCTFail("Error should be of type \(E.self) but it was of type \(type(of: error))")
    }
    return nil
}

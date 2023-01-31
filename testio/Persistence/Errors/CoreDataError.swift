//
//  CoreDataError.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 30.01.23.
//

import Foundation

enum CoreDataError: LocalizedError {
    case saveFailed(String)
    case deleteFailed(String)
    case fetchFailed(String)
    case clearFailed

    var errorDescription: String? {
        switch self {
        case .saveFailed(let reason): return "CoreData: \(reason)"
        case .deleteFailed(let reason): return "CoreData: \(reason)"
        case .fetchFailed(let reason): return "CoreData: \(reason)"
        case .clearFailed: return "CoreData: Could not clear database"
        }
    }
}

//
//  Persistence.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 26.01.23.
//

import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()

    private let container: NSPersistentContainer

    var mainContext: NSManagedObjectContext {
        let context = container.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }

    lazy var backgroundContext: NSManagedObjectContext = {
        let context = container.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
    }()

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "testio")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Failed to load persistent store with Error: \(error), \(error.userInfo)")
            }
        }
    }

    func write(_ block: @escaping (NSManagedObjectContext) -> Void, on context: NSManagedObjectContext? = nil) async throws {
        let context = context ?? mainContext
        try await context.perform {
            block(context)
            try context.save()
        }
    }

    func read<Entity, Result>(_ request: NSFetchRequest<Entity>, on context: NSManagedObjectContext? = nil, parse: @escaping (Entity) -> Result) async throws -> [Result] {
        let context = context ?? mainContext
        return try await context.perform {
            let fetchResult = try context.fetch(request)
            return fetchResult.map(parse)
        }
    }

    func delete(_ batchDeleteRequest: NSBatchDeleteRequest, on context: NSManagedObjectContext? = nil) async throws {
        let context = context ?? mainContext
        try await context.perform {
            batchDeleteRequest.resultType = .resultTypeObjectIDs
            let batchDelete = try context.execute(batchDeleteRequest) as? NSBatchDeleteResult

            guard let deleteResult = batchDelete?.result as? [NSManagedObjectID] else { return }

            let deletedObjects = [NSDeletedObjectsKey: deleteResult]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: deletedObjects, into: [context])
        }
    }
}

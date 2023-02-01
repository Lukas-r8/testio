//
//  Persistence.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 26.01.23.
//

import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()
    static let modelName = "testio"
    static let model: NSManagedObjectModel = {
      let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!
      return NSManagedObjectModel(contentsOf: modelURL)!
    }()

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
        container = NSPersistentContainer(name: CoreDataStack.modelName, managedObjectModel: CoreDataStack.model)
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Failed to load persistent store with Error: \(error), \(error.userInfo)")
            }
        }
    }

    func write(on context: NSManagedObjectContext? = nil, _ block: @escaping (NSManagedObjectContext) throws -> Void) async throws {
        let context = context ?? mainContext
        do {
            try await context.perform {
                try block(context)
                try context.save()
            }
        } catch {
            throw CoreDataError.saveFailed(error.localizedDescription)
        }
    }

    func read<Entity, Result>(_ request: NSFetchRequest<Entity>, on context: NSManagedObjectContext? = nil, parse: @escaping (Entity) -> Result) async throws -> [Result] {
        let context = context ?? mainContext
        do {
            return try await context.perform {
                let fetchResult = try context.fetch(request)
                return fetchResult.map(parse)
            }
        } catch {
            throw CoreDataError.fetchFailed("Could not fetch entity of type \(Entity.self), reason: \(error.localizedDescription)")
        }
    }

    func delete(_ batchDeleteRequest: NSBatchDeleteRequest, on context: NSManagedObjectContext? = nil) async throws {
        let context = context ?? mainContext
        do {
            try await context.perform {
                batchDeleteRequest.resultType = .resultTypeObjectIDs
                let batchDelete = try context.execute(batchDeleteRequest) as? NSBatchDeleteResult

                guard let deleteResult = batchDelete?.result as? [NSManagedObjectID] else { return }

                let deletedObjects = [NSDeletedObjectsKey: deleteResult]
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: deletedObjects, into: [context])
            }
        } catch {
            throw CoreDataError.deleteFailed(error.localizedDescription)
        }
    }

    func clear() async throws {
        let persistedEntitiesNames = container.managedObjectModel.entities.compactMap { $0.name }
        for entityName in persistedEntitiesNames {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try await delete(batchDeleteRequest, on: mainContext)
            } catch {
                throw CoreDataError.clearFailed
            }
        }
    }
}

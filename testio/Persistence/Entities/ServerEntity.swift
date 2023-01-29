//
//  ServerEntity+CoreDataClass.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//
//

import Foundation
import CoreData

final class ServerEntity: NSManagedObject {
     static func fetchRequest() -> NSFetchRequest<ServerEntity> {
        return NSFetchRequest<ServerEntity>(entityName: "ServerEntity")
    }

    static func deleteRequest(for names: [String]) -> NSBatchDeleteRequest {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ServerEntity")
        fetchRequest.predicate = NSPredicate(format: "name IN %@", names)
        return NSBatchDeleteRequest(fetchRequest: fetchRequest)
    }

    @NSManaged public var name: String
    @NSManaged public var distance: Int
}

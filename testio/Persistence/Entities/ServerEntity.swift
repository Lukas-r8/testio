//
//  ServerEntity+CoreDataClass.swift
//  testio
//
//  Created by Lucas Alves Da Silva on 27.01.23.
//
//

import Foundation
import CoreData

class ServerEntity: NSManagedObject {
     static func fetchRequest() -> NSFetchRequest<ServerEntity> {
        return NSFetchRequest<ServerEntity>(entityName: "ServerEntity")
    }

    @NSManaged public var name: String?
}

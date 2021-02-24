//
//  Memo+CoreDataProperties.swift
//  CloudNotes
//
//  Created by Wonhee on 2021/02/24.
//
//

import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var title: String?
    @NSManaged public var body: Date?
    @NSManaged public var lastModified: NSObject?

}

extension Memo : Identifiable {

}

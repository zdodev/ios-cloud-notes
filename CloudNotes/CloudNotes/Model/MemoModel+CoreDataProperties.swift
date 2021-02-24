//
//  MemoModel+CoreDataProperties.swift
//  CloudNotes
//
//  Created by Zero DotOne on 2021/02/25.
//
//

import Foundation
import CoreData


extension MemoModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemoModel> {
        return NSFetchRequest<MemoModel>(entityName: "MemoModel")
    }

    @NSManaged public var body: String?
    @NSManaged public var lastModified: Double
    @NSManaged public var title: String?

}

extension MemoModel : Identifiable {

}

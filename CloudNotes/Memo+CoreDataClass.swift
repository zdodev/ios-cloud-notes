//
//  Memo+CoreDataClass.swift
//  CloudNotes
//
//  Created by Wonhee on 2021/02/24.
//
//

import Foundation
import CoreData

@objc(Memo)
public class Memo: NSManagedObject {
    func dateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: self.lastModified ?? Date())
    }
}

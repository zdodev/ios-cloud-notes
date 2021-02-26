//
//  MemoModel+CoreDataProperties.swift
//  CloudNotes
//
//  Created by Zero DotOne on 2021/02/26.
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
    @NSManaged public var index: Int64

}

extension MemoModel : Identifiable {
    var dateTimeToString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale.autoupdatingCurrent
        let date = Date(timeIntervalSinceReferenceDate: lastModified)
        return dateFormatter.string(from: date)
    }
    
    func setupIndex(_ index: Int64) {
        self.index = index
    }
}

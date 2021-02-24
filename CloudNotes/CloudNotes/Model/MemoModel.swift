//
//  MemoModel.swift
//  CloudNotes
//
//  Created by Wonhee on 2021/02/19.
//
//
//import Foundation
//
//struct MemoModel: Decodable {
//    let title: String
//    let body: String
//    let lastModified: TimeInterval
//    
//    enum CodingKeys: String, CodingKey {
//        case title
//        case body
//        case lastModified = "last_modified"
//    }
//}
//
//extension MemoModel {
//    var dateTimeToString: String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        dateFormatter.locale = Locale.autoupdatingCurrent
//        let date = Date(timeIntervalSince1970: lastModified)
//        return dateFormatter.string(from: date)
//    }
//}

import UIKit
import CoreData

class MemoModel {
    static let shared = MemoModel()
    private init() {}
    
    var list: [Memo] = []
    
    func save(title: String, body: String) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let object = NSEntityDescription.insertNewObject(forEntityName: "Memo", into: context)
        object.setValue(title, forKey: "title")
        object.setValue(body, forKey: "body")
        object.setValue(Date(), forKey: "lastModified")
        
        do {
            try context.save()
            self.list.append(object as! Memo)
            
            print("❗️ \(list.count)")
            return true
        } catch {
            context.rollback()
            return false
        }
    }
}

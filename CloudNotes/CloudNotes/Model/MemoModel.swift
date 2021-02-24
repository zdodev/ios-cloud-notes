//
//  MemoModel.swift
//  CloudNotes
//
//  Created by Wonhee on 2021/02/19.
//

import UIKit
import CoreData

class MemoModel {
    static let shared = MemoModel()
    private init() {}
    
    var list: [Memo] = []
    
    func save(title: String, body: String) throws -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw MemoError.saveMemo
        }
        let context = appDelegate.persistentContainer.viewContext
        let object = NSEntityDescription.insertNewObject(forEntityName: "Memo", into: context)
        object.setValue(title, forKey: "title")
        object.setValue(body, forKey: "body")
        object.setValue(Date(), forKey: "lastModified")
        guard let memoObject = object as? Memo else {
            throw MemoError.saveMemo
        }
        
        do {
            try context.save()
            self.list.append(memoObject)
            return true
        } catch {
            context.rollback()
            throw error
        }
    }
    
    func fetch() throws -> [Memo] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw MemoError.fetchMemo
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Memo")
        do {
            let result = try context.fetch(fetchRequest)
            guard let memoObjectList = result as? [Memo] else {
                throw MemoError.fetchMemo
            }
            return memoObjectList
        } catch {
            throw error
        }
    }
    
    func delete(index: Int) throws -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw MemoError.deleteMemo
        }
        let context = appDelegate.persistentContainer.viewContext
        context.delete(list[index])
        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            throw MemoError.deleteMemo
        }
    }
    
    func update(index: Int, title: String, body: String) throws -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            throw MemoError.updateMemo
        }
        let context = appDelegate.persistentContainer.viewContext
        let object = list[index]
        object.setValue(title, forKey: "title")
        object.setValue(body, forKey: "body")
        object.setValue(Date(), forKey: "lastModified")
        
        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            throw MemoError.updateMemo
        }
    }
}

//
//  MemoModel+CoreDataClass.swift
//  CloudNotes
//
//  Created by Zero DotOne on 2021/02/26.
//
//

import Foundation
import CoreData
import UIKit

@objc(MemoModel)
public class MemoModel: NSManagedObject {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}

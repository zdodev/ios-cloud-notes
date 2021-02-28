//
//  DateExtension.swift
//  CloudNotes
//
//  Created by Wonhee on 2021/02/28.
//

import Foundation

extension Date {
    func dateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: self)
    }
}

//
//  Memo.swift
//  CloudNotes
//
//  Created by Wonhee on 2021/02/16.
//

import Foundation

struct Memo: Decodable {
    let title: String
    let body: String
    let lastModified: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case lastModified = "last_modified"
    }
}

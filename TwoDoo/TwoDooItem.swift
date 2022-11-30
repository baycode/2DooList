//
//  TwoDooItem.swift
//  TwoDoo
//
//  Created by Bayram Ayyildiz on 2022-11-20.
//

import Foundation


struct TwoDooItem: Codable {
    var name: String
    var date: Date
    var notes: String
    var reminderSet: Bool
    var notitificationID: String?
    var completed: Bool
    
}

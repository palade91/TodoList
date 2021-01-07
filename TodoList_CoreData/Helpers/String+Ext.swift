//
//  String+Ext.swift
//  TodoList_CoreData
//
//  Created by Catalin Palade on 07/01/2021.
//

import Foundation

extension String {
    func date() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        formatter.locale = .current
        return formatter.date(from: self)
    }
}

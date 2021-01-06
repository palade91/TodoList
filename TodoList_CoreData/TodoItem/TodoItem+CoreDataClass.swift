//
//  TodoItem+CoreDataClass.swift
//  TodoList_CoreData
//
//  Created by Catalin Palade on 06/01/2021.
//
//

import Foundation
import CoreData

@objc(TodoItem)
public class TodoItem: NSManagedObject, Comparable {
    
    public static func < (lhs: TodoItem, rhs: TodoItem) -> Bool {
        lhs.taskDate < rhs.taskDate
    }
    

}

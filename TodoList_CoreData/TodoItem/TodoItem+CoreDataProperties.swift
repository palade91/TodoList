//
//  TodoItem+CoreDataProperties.swift
//  TodoList_CoreData
//
//  Created by Catalin Palade on 06/01/2021.
//
//

import Foundation
import CoreData


extension TodoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoItem> {
        return NSFetchRequest<TodoItem>(entityName: "TodoItem")
    }

    @NSManaged public var taskTitle: String
    @NSManaged public var taskDescription: String
    @NSManaged public var taskDate: Date
    @NSManaged public var isCompleted: Bool

}

extension TodoItem : Identifiable {

}

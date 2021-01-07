//
//  CoreDataManager.swift
//  TodoList_CoreData
//
//  Created by Catalin Palade on 07/01/2021.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //
    func getAllTodoItems() -> [TodoItem] {
        var items: [TodoItem] = []
        do {
           items = try context.fetch(TodoItem.fetchRequest())
        } catch let error {
            print(error.localizedDescription)
        }
        return items
    }
    
    func saveNewTodoItem(title: String, description: String, date: Date) {
        let newTodoItem = TodoItem(context: context)
        
        newTodoItem.taskTitle = title
        newTodoItem.taskDescription = description
        newTodoItem.taskDate = date
        newTodoItem.isCompleted = false
        
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func delete(item: TodoItem) {
        context.delete(item)
        
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func updateItem(item: TodoItem, newTitle: String?, newDescription: String?, newDate: Date?) {
        if let title = newTitle {
            item.taskTitle = title
        }
        if let description = newDescription {
            item.taskDescription = description
        }
        if let date = newDate {
            item.taskDate = date
        }
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func markAsCompleted(item: TodoItem) {
        item.isCompleted = true
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

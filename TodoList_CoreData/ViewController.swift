//
//  ViewController.swift
//  TodoList_CoreData
//
//  Created by Catalin Palade on 06/01/2021.
//

import UIKit

class ViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items: [TodoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    fileprivate func getAllTodoItems() {
        do {
            items = try context.fetch(TodoItem.fetchRequest())
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    fileprivate func saveNewTodoItem(title: String, description: String, date: Date) {
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
    
    fileprivate func delete(item: TodoItem) {
        context.delete(item)
        
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    fileprivate func updateItem(item: TodoItem, newTitle: String? = nil, newDescription: String? = nil, newIsCompleted: Bool? = nil, newDate: Date? = nil) {
        
        if let title = newTitle {
            item.taskTitle = title
        }
        
        if let description = newDescription {
            item.taskDescription = description
        }
        
        if let isCompleted = newIsCompleted {
            item.isCompleted = isCompleted
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

}


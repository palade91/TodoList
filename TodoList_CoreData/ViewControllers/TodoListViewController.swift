//
//  TodoListViewController.swift
//  TodoList_CoreData
//
//  Created by Catalin Palade on 06/01/2021.
//

import UIKit

class TodoListViewController: UIViewController {

    // delegate and datasource set up in storyboard
    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items: [TodoItem] = []
    
    // MARK: Viewcontroller lifecycle
    override func viewWillAppear(_ animated: Bool) {
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //
    fileprivate func setupView() {
        
    }

    // MARK: Coredata
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

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todo_item", for: indexPath) as! TodoItemCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

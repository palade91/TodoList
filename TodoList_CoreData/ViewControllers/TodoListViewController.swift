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
        // setup cell for tableview
        tableView.register(UINib(nibName: "TodoItemCell", bundle: nil), forCellReuseIdentifier: "todo_item")
        
        // tableview hide empty rows
        tableView.tableFooterView = UIView()
        
        // navigation bar title
        self.title = "Todo List"
        
        // navigation bar right button
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        addBarButton.tintColor = .black
        navigationItem.rightBarButtonItem = addBarButton
    }
    
    @objc func addTapped() {
        
    }

    // MARK: Coredata
    fileprivate func getAllTodoItems() {
        do {
            items = try context.fetch(TodoItem.fetchRequest())
            tableView.reloadData()
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
    
    fileprivate func updateItem(item: TodoItem, newTitle: String?, newDescription: String?, newDate: Date?) {
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

}

// MARK: UITableViewDelegate, UITableViewDataSource
extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todo_item", for: indexPath) as! TodoItemCell
        let item = items[indexPath.row]
        cell.setupCellWith(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let detailsVC = TodoItemDetailsVC(type: .edit, item: item)
        detailsVC.delegate = self
        navigationController?.present(detailsVC, animated: true)
    }
}

// MARK: TodoItemDetailsDelegate
extension TodoListViewController: TodoItemDetailsDelegate {
    func didEditItem(item: TodoItem, title: String?, description: String?, date: Date?) {
        updateItem(item: item, newTitle: title, newDescription: description, newDate: date)
        tableView.reloadData()
    }
    
    func didMarkAsComplete(item: TodoItem) {
        item.isCompleted = true
        tableView.reloadData()
    }
    
    func didDelete(item: TodoItem) {
        delete(item: item)
        tableView.reloadData()
    }
    
    func didAddItem(title: String, description: String, date: Date) {
        saveNewTodoItem(title: title, description: description, date: date)
    }
}
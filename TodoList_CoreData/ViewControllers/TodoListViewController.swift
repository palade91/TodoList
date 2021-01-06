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
    
    var items: [TodoItem] = [] {
        didSet {
            items.sort()
            tableView.reloadData()
        }
    }
    
    // MARK: Viewcontroller lifecycle
    override func viewWillAppear(_ animated: Bool) {
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getAllTodoItems()
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
        let detailsVC = TodoItemDetailsVC(type: .create)
        detailsVC.delegate = self
        self.present(detailsVC, animated: true)
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
        let detailsVC = TodoItemDetailsVC(type: .display, item: item)
        detailsVC.delegate = self
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .normal, title: "Leading & .normal") { (contextualAction, view, boolValue) in
                print("Leading Action style .normal")
            }
            let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

            return swipeActions
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Trailing & .destructive") { (contextualAction, view, boolValue) in
                print("Trailing Action style .destructive")
            }
            let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

            return swipeActions
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            items.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
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

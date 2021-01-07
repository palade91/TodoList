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
    
    //
    var items: [TodoItem] = [] {
        didSet {
            items.sort()
            tableView.reloadData()
        }
    }
    
    // MARK: Viewcontroller lifecycle
    override func viewWillAppear(_ animated: Bool) {
        getAllTodoItems()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNotificationObserver()
    }
    
    //
    @objc fileprivate func getAllTodoItems() {
        items = CoreDataManager.shared.getAllTodoItems()
    }
    
    fileprivate func setupNotificationObserver() {
        let notification = NotificationCenter.default
        notification.addObserver(self,
                                 selector: #selector(getAllTodoItems),
                                 name: Notification.Name("refresh_items"),
                                 object: nil)
    }
    
    fileprivate func setupView() {
        // setup cell for tableview
        tableView.register(UINib(nibName: "TodoItemCell", bundle: nil), forCellReuseIdentifier: "todo_item")
        tableView.rowHeight = 100
        
        // tableview hide empty rows
        tableView.tableFooterView = UIView()
        
        // navigation bar title
        self.title = "Todo List"
        
        // navigation bar right button
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = addBarButton
    }
    
    @objc func addTapped() {
        let detailsVC = TodoItemDetailsVC(type: .create)
        self.present(detailsVC, animated: true)
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
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .normal, title: "Mark as completed") { (_, _, _) in
            
            let item = self.items[indexPath.row]
            CoreDataManager.shared.markAsCompleted(item: item)
            item.isCompleted = true
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            
        }
        contextItem.backgroundColor = UIColor.green
        
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            
            let item = self.items[indexPath.row]
            CoreDataManager.shared.delete(item: item)
    
            self.getAllTodoItems()
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        return swipeActions
    }
}

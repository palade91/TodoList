//
//  TodoItemDetailsVC.swift
//  TodoList_CoreData
//
//  Created by Catalin Palade on 06/01/2021.
//

import UIKit

enum ViewControllerType {
    case create
    case edit
}

class TodoItemDetailsVC: UIViewController {

    let type: ViewControllerType
    let item: TodoItem?
    
    /// Using TodoItemDetailsVC for creating and displaying the todo item
    /// - Parameters:
    ///   - type: .create (item = nil) / .edit (display item)
    ///   - item: TodoItem
    init(type: ViewControllerType, item: TodoItem? = nil) {
        self.type = type
        self.item = item
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    

}

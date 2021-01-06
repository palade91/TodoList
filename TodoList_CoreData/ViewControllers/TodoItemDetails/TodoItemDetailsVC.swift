//
//  TodoItemDetailsVC.swift
//  TodoList_CoreData
//
//  Created by Catalin Palade on 06/01/2021.
//

import UIKit

enum ViewControllerType {
    case create
    case display
}

protocol TodoItemDetailsDelegate {
    func didEditItem(item: TodoItem, title: String?, description: String?, date: Date?)
    func didMarkAsComplete(item: TodoItem)
    func didDelete(item: TodoItem)
    func didAddItem(title: String, description: String, date: Date)
}

class TodoItemDetailsVC: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var createTitleField: UITextField!
    @IBOutlet weak var createDescriptionText: UITextView!
    
    @IBOutlet weak var createStack: UIStackView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var displayTitleLabel: UILabel!
    @IBOutlet weak var displayDescriptionLabel: UILabel!
    @IBOutlet weak var displayDateLabel: UILabel!
    
    @IBOutlet weak var markAsCompletedOutlet: UIButton!
    @IBOutlet weak var deleteOutlet: UIButton!
    
    @IBOutlet weak var displayStack: UIStackView!
    @IBOutlet weak var buttonStack: UIStackView!
    
    //
    let type: ViewControllerType
    let item: TodoItem?
    
    var delegate: TodoItemDetailsDelegate?
    
    
    /// Using TodoItemDetailsVC for creating and displaying the todo item
    /// - Parameters:
    ///   - type: .create (item = nil) / .display (display item + edit button to update item details)
    ///   - item: TodoItem
    init(type: ViewControllerType, item: TodoItem? = nil) {
        self.type = type
        self.item = item
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ViewController Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        setupView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //
    fileprivate func setupView() {
        switch type {
        case .create:
            
            // show
            createStack.isHidden = false
            
            // hide
            displayStack.isHidden = true
            buttonStack.isHidden = true
            
            
            
            
        case .display:
            
            // show
            displayStack.isHidden = false
            buttonStack.isHidden = false
            
            // hide
            createStack.isHidden = true
            
            if let item = item {
                displayTitleLabel.text = item.taskTitle
                displayDescriptionLabel.text = item.taskDescription
                
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM d, h:mm a"
                formatter.locale = .current
                displayDateLabel.text = formatter.string(from: item.taskDate)
            }
        }
        
        //
        markAsCompletedOutlet.layer.cornerRadius = 10
        deleteOutlet.layer.cornerRadius = 10
        
        createDescriptionText.layer.borderWidth = 1
        createDescriptionText.layer.borderColor = UIColor.lightGray.cgColor
        createDescriptionText.layer.cornerRadius = 6
        
        // hide date picker by default
        datePicker.isHidden = true
        
        // navigation bar right button
        let editBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        editBarButton.tintColor = .black
        navigationItem.rightBarButtonItem = editBarButton
    }
    
    @objc func editTapped() {
        
    }
    
    // MARK: IBActions
    @IBAction func createDateTapped(_ sender: UIButton) {
        datePicker.isHidden = false
    }
    @IBAction func markAsCompletedTapped(_ sender: UIButton) {
        
    }
    @IBAction func deleteTapped(_ sender: UIButton) {
        
    }
    
    

}

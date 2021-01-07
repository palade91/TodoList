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
    case display
}

class TodoItemDetailsVC: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var createTitleField: UITextField!
    @IBOutlet weak var createDescriptionText: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var createStack: UIStackView!
    
    @IBOutlet weak var displayTitleLabel: UILabel!
    @IBOutlet weak var displayDescriptionLabel: UILabel!
    @IBOutlet weak var displayDateLabel: UILabel!
    
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var redButtonOutlet: UIButton!
    
    @IBOutlet weak var displayStack: UIStackView!
    
    //
    var type: ViewControllerType
    let item: TodoItem?
    
    // using the same vc for creating, editing and display
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
        setupNavigation()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()

        greenButton.layer.cornerRadius = 10
        redButtonOutlet.layer.cornerRadius = 10
        
        createDescriptionText.layer.borderWidth = 0.7
        createDescriptionText.layer.borderColor = UIColor.lightGray.cgColor
        createDescriptionText.layer.cornerRadius = 6
    }

    //
    fileprivate func setupView() {
        switch type {
        case .create, .edit:
            
            // show
            createStack.isHidden = false
            
            // hide
            displayStack.isHidden = true
            
            // set title for buttons
            greenButton.setTitle("Save", for: .normal)
            redButtonOutlet.setTitle("Dismiss", for: .normal)
            
            if let _ = item {
                createTitleField.text = displayTitleLabel.text
                createDescriptionText.text = displayDescriptionLabel.text
                if let date = displayDateLabel.text?.date() {
                    datePicker.date = date
                }
            }
            
        case .display:
            
            // show
            displayStack.isHidden = false
            
            // hide
            createStack.isHidden = true
            
            // set title for buttons
            greenButton.setTitle("Mark as complete", for: .normal)
            redButtonOutlet.setTitle("Delete", for: .normal)
            
            if let item = item {
                displayTitleLabel.text = item.taskTitle
                displayDescriptionLabel.text = item.taskDescription
                displayDateLabel.text = item.taskDate.stringDate()
            }
        }
        if let item = item {
            if !item.isCompleted || type == .edit {
                greenButton.isHidden = false
            } else {
                greenButton.isHidden = true
            }
        }
    }
    
    fileprivate func setupNavigation() {
        // navigation bar right button
        let editBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
        navigationItem.rightBarButtonItem = editBarButton
    }
    
    @objc func editTapped() {
        type = .edit
        setupView()
    }
    
    // MARK: IBActions
    @IBAction func greenTapped(_ sender: UIButton) {
        
        switch type {
        case .create:
            
            CoreDataManager.shared.saveNewTodoItem(title: createTitleField.text ?? "",
                                                   description: createDescriptionText.text ?? "",
                                                   date: datePicker.date)
            
            // refresh items in TodoListVC
            let notification = NotificationCenter.default
            notification.post(name: Notification.Name("refresh_items"), object: nil)
            
            self.dismiss(animated: true)
        
        case .edit:
            guard let item = item else { return }
            
            CoreDataManager.shared.updateItem(item: item,
                                              newTitle: createTitleField.text,
                                              newDescription: createDescriptionText.text,
                                              newDate: datePicker.date)
            // update view
            displayTitleLabel.text = createTitleField.text
            displayDescriptionLabel.text = createTitleField.text
            displayDateLabel.text = item.taskDate.stringDate()
            
            type = .display
            setupView()
            
        case .display:
            guard let item = item else { return }
            CoreDataManager.shared.markAsCompleted(item: item)
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func redTapped(_ sender: UIButton) {
        
        switch type {
        case .create:
            dismiss(animated: true)
            
        case .edit:
            type = .display
            setupView()
            
        case .display:
            guard let item = item else { return }
            CoreDataManager.shared.delete(item: item)
            navigationController?.popViewController(animated: true)
        }
    }
}

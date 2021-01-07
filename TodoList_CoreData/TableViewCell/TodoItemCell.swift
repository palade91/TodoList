//
//  TodoItemCell.swift
//  TodoList_CoreData
//
//  Created by Catalin Palade on 06/01/2021.
//

import UIKit

class TodoItemCell: UITableViewCell {
    
    // IBOutlets
    @IBOutlet weak var checkMarkImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellWith(item: TodoItem) {
        
        titleLabel.text = item.taskTitle
        descriptionLabel.text = item.taskDescription
        dateLabel.text = item.taskDate.stringDate()
        
        if item.isCompleted {
            checkMarkImage.tintColor = .green
        } else {
            checkMarkImage.tintColor = .gray
        }
        
    }
    
}

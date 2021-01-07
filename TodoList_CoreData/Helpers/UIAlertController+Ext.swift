//
//  UIAlertController+Ext.swift
//  TodoList_CoreData
//
//  Created by Catalin Palade on 07/01/2021.
//

import UIKit

extension UIAlertController {
    class func presentAlertOK(view: UIViewController, title: String? = nil, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.async {
            view.present(alert, animated: true)
        }
    }
}

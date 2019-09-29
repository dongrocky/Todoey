//
//  ViewController.swift
//  Todoey
//
//  Created by Mac4_0 on 9/29/19.
//  Copyright © 2019 BananaLovers. All rights reserved.
//

import UIKit

class ItemListViewController: UITableViewController {
    
    private var items = ["bug grocery", "send money to Joel"]
    
    private var addAction: UIAlertAction?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK - UITableViewDelegate
    
    
    // MARK - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    // Mark - Add new items
    
    @IBAction func didTapAddItem(_ sender: UIBarButtonItem) {
        let alertView = UIAlertController(title: "Add Todo Item", message: "", preferredStyle: .alert)
        var textField: UITextField = UITextField()
        alertView.addTextField { (textFieldAdded) in
            textField = textFieldAdded
            textField.placeholder = "Write a todo item title"
            textField.addTarget(self, action: #selector(ItemListViewController.textFieldDidChange), for: .editingChanged)
        }
        addAction = UIAlertAction(title: "Add", style: .default) { [weak self] action in
            self?.items.append(textField.text!)
            self?.tableView.reloadData()
        }
        
        guard let addAction = addAction else {
            return
        }
        addAction.isEnabled = false
        alertView.addAction(addAction)
        present(alertView, animated: true)
    }
    
    @objc func textFieldDidChange(sender: UITextField) {
        guard let length = sender.text?.count else {
            return
        }
        addAction?.isEnabled = length > 0
    }
}


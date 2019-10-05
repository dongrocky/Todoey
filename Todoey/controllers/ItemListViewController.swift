//
//  ViewController.swift
//  Todoey
//
//  Created by Mac4_0 on 9/29/19.
//  Copyright © 2019 BananaLovers. All rights reserved.
//

import UIKit

class ItemListViewController: UITableViewController {
    
    private var items: [Item] = []
    
    private let encoder = PropertyListEncoder()
    private let decoder = PropertyListDecoder()
    private let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    private var addAction: UIAlertAction?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }

    // MARK - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        item.done = !item.done
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    // MARK - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
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
            let item = Item(title:textField.text!)
            guard let strongSelf = self else { return }
            strongSelf.items.append(item)
            strongSelf.saveItems()
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
    
    func saveItems() {
        do {
            let encoded = try encoder.encode(items)
            if let filePath = dataFilePath {
                try encoded.write(to: filePath)
            }
        } catch {
            print("Error encoding items list.")
        }
    }
    
    func loadItems() {
        guard let filePath = dataFilePath else {
            NSLog("Failed to get the plist file url.")
            return
        }
        do {
            let encoded = try Data(contentsOf: filePath)
            items = try decoder.decode([Item].self, from: encoded)
        } catch {
            NSLog("Failed to decode items array list.")
        }
    }
}


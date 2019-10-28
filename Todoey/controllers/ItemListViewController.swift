//
//  ViewController.swift
//  Todoey
//
//  Created by Mac4_0 on 9/29/19.
//  Copyright © 2019 BananaLovers. All rights reserved.
//

import UIKit
import RealmSwift

class ItemListViewController: UITableViewController {
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    private var items: Results<Item>?
    private let realm = try! Realm()
    
    private var addAction: UIAlertAction?

    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = items?[indexPath.row] else { return }
        
        // delte item instead
        do {
            try realm.write {
                realm.delete(item)
//                item.done = !item.done
            }
        } catch {
            NSLog("Failed to toggle item")
        }
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let item = items?[indexPath.row]
        cell.textLabel?.text = item?.title ?? "No items has been added"
        let done = item?.done ?? false
        cell.accessoryType = done ? .checkmark : .none
        return cell
    }
    
    // MARK: - Add new items
    
    @IBAction func didTapAddItem(_ sender: UIBarButtonItem) {
        let alertView = UIAlertController(title: "Add Todo Item", message: "", preferredStyle: .alert)
        var textField: UITextField = UITextField()
        alertView.addTextField { (textFieldAdded) in
            textField = textFieldAdded
            textField.placeholder = "Write a todo item title"
            textField.addTarget(self, action: #selector(ItemListViewController.textFieldDidChange), for: .editingChanged)
        }
        addAction = UIAlertAction(title: "Add", style: .default) { [weak self] action in
            guard let strongSelf = self else { return }
            
            do {
                try strongSelf.realm.write {
                    let item = Item()
                    item.title = textField.text!
                    strongSelf.selectedCategory?.items.append(item)
                }
            } catch {
                NSLog("Error saving new items")
            }
            strongSelf.tableView.reloadData()
        }
        
        guard let addAction = addAction else {
            return
        }
        addAction.isEnabled = false
        alertView.addAction(addAction)
        present(alertView, animated: true)
    }
    
    // MARK: - Private
    
    @objc func textFieldDidChange(sender: UITextField) {
        guard let length = sender.text?.count else {
            return
        }
        addAction?.isEnabled = length > 0
    }
    
    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

extension ItemListViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        loadItems(with: request, predicate: predicate)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        guard searchBar.text?.count == 0 else { return }
//        loadItems()
//        DispatchQueue.main.async {
//            searchBar.resignFirstResponder()
//        }
//    }
}

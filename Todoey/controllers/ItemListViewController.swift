//
//  ViewController.swift
//  Todoey
//
//  Created by Mac4_0 on 9/29/19.
//  Copyright © 2019 BananaLovers. All rights reserved.
//

import UIKit
import CoreData

class ItemListViewController: UITableViewController {
    
    private var items: [Item] = []
    private let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var addAction: UIAlertAction?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }

    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        item.done = !item.done
        
        // delte item instead
//        coreDataContext.delete(item)
//        items.remove(at: indexPath.row)
        saveItems()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - UITableViewDataSource
    
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
            let item = Item(context: strongSelf.coreDataContext)
            item.title = textField.text!
            item.done = false
            strongSelf.items.append(item)
            strongSelf.saveItems()
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
    
    func saveItems() {
        do {
            try coreDataContext.save()
        } catch {
            NSLog("Error saving item list into core data")
        }
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            items = try coreDataContext.fetch(request)
        } catch {
            NSLog("Failed to load item list from the core data")
        }
    }
}

extension ItemListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchBar.text?.count == 0 else { return }
        loadItems()
        tableView.reloadData()
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
}

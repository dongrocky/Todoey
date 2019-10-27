//
//  CategoryViewControllerTableViewController.swift
//  Todoey
//
//  Created by Mac4_0 on 10/6/19.
//  Copyright © 2019 BananaLovers. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    private var categories: Results<Category>?
    private var addAction: UIAlertAction?
    private let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categories?[indexPath.row]
        cell.textLabel?.text = category?.name ?? "No categories created"
        return cell
    }
    
    // MARK: - Table view delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ItemListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = self.categories?[indexPath.row]
        }
    }
    
    // MARK: - Navigation bar
    
    @IBAction func didTapAddButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alertView = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        alertView.addTextField { (textFieldAdded) in
            textField = textFieldAdded
            textField.placeholder = "Write a category name"
            textField.addTarget(self, action: #selector(CategoryViewController.textFieldDidChange), for: .editingChanged)
        }
        addAction = UIAlertAction(title: "Add", style: .default, handler: { [weak self] (action) in
            guard let strongSelf = self else { return }
            let category = Category()
            category.name = textField.text!
            strongSelf.save(category: category)
            strongSelf.tableView.reloadData()
        })
        alertView.addAction(addAction!)
        present(alertView, animated: true)
    }
    
    @objc func textFieldDidChange(sender: UITextField) {
        guard let textLength = sender.text?.count else { return }
        addAction?.isEnabled = textLength > 0
    }
    
    // MARK: - Private
    func loadCategories() {
        categories = realm.objects(Category.self)
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            NSLog("Failed to save categories")
        }
    }
}

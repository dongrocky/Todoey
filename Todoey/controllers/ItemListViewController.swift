//
//  ViewController.swift
//  Todoey
//
//  Created by Mac4_0 on 9/29/19.
//  Copyright © 2019 BananaLovers. All rights reserved.
//

import UIKit

class ItemListViewController: UITableViewController {
    
    private var items = ["bug grocery", "send money to Joel"];

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
}


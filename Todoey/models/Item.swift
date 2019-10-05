//
//  Item.swift
//  Todoey
//
//  Created by Mac4_0 on 9/29/19.
//  Copyright © 2019 BananaLovers. All rights reserved.
//

import Foundation

class Item: Codable {
    var title: String
    var done: Bool
    
    init(title: String = "", done: Bool = false) {
        self.title = title
        self.done = done
    }
}

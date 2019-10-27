import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var done: Bool = false
    let items = List<Item>()
}

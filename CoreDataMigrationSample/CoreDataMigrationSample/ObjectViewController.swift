//
//  ObjectViewController.swift
//

import UIKit

class ObjectViewController : UITableViewController {
    static let ObjectCellIdentifier = "ObjectCell"
    
    private enum Section: Int {
        case attributes
        case relationships
        
        static var count: Int {
            return 2
        }
    }
    
    var object: NSManagedObject!
    private var attributeNames: [String]!
    private var relationshipNames: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attributeNames = Array(self.object.entity.attributesByName.keys)
        relationshipNames = Array(self.object.entity.relationshipsByName.keys)
        
        title = "\(object.entity.name!) object"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .attributes:
            return "Attributes"
        case .relationships:
            return "Relationships"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .attributes:
            return attributeNames.count
        case .relationships:
            return relationshipNames.count
       }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ObjectViewController.ObjectCellIdentifier, for: indexPath)
        
        switch Section(rawValue: indexPath.section)! {
        case .attributes:
            let key = attributeNames[indexPath.row]
            cell.textLabel?.text = key
            if let value = object.value(forKey: key) {
                cell.detailTextLabel?.text = "\(value)"
            } else {
                cell.detailTextLabel?.text = "null"
            }
        case .relationships:
            let key = relationshipNames[indexPath.row]
            cell.textLabel?.text = key
            let relationship = object.value(forKey: key)
            if let value = (relationship as AnyObject).value(forKey: NameKey) {
                cell.detailTextLabel?.text = "\(value)"
            } else {
                cell.detailTextLabel?.text = "null"
            }
        }
        
        return cell
    }
}

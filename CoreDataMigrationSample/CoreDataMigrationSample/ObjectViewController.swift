//
//  ObjectViewController.swift
//

import UIKit

class ObjectViewController : UITableViewController {
    static let ObjectCellIdentifier = "ObjectCell"
    
    private enum Section: Int {
        case Attributes
        case Relationships
        
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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Section.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .Attributes:
            return "Attributes"
        case .Relationships:
            return "Relationships"
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .Attributes:
            return attributeNames.count
        case .Relationships:
            return relationshipNames.count
       }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ObjectViewController.ObjectCellIdentifier, forIndexPath: indexPath)
        
        switch Section(rawValue: indexPath.section)! {
        case .Attributes:
            let key = attributeNames[indexPath.row]
            cell.textLabel?.text = key
            if let value = object.valueForKey(key) {
                cell.detailTextLabel?.text = "\(value)"
            } else {
                cell.detailTextLabel?.text = "null"
            }
        case .Relationships:
            let key = relationshipNames[indexPath.row]
            cell.textLabel?.text = key
            let relationship = object.valueForKey(key)
            if let value = relationship?.valueForKey(NameKey) {
                cell.detailTextLabel?.text = "\(value)"
            } else {
                cell.detailTextLabel?.text = "null"
            }
        }
        
        return cell
    }
}

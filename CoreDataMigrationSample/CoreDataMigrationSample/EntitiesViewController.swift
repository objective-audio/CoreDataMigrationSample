//
//  EntitiesViewController.swift
//

import UIKit

class EntitiesViewController : UITableViewController {
    static let InformationCellIdentifier: String = "InformationCell"
    static let EntitiesCellIdentifier: String = "EntitiesCell";
    
    private enum Section: Int {
        case Information
        case Entities
        
        static var count: Int {
            return 2
        }
        
        var cellIdentifier: String {
            switch self {
            case .Information:
                return InformationCellIdentifier
            case .Entities:
                return EntitiesCellIdentifier
            }
        }
    }
    
    private enum InformationRow: Int {
        case ModelName
        case ModelIdentifier
        case MigrationTime
        
        static var count: Int {
            return 3
        }
        
        var title: String {
            switch self {
            case .ModelName:
                return "Model Name"
            case .ModelIdentifier:
                return "Model Identifier"
            case .MigrationTime:
                return "Migration Time"
            }
        }
    }
    
    var dataController : DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController = segue.destinationViewController as? ObjectsViewController, cell = sender as? UITableViewCell {
            if let indexPath = tableView.indexPathForCell(cell) {
                viewController.context = dataController.dataStore.mainContext
                viewController.entityName = dataController.entityName(indexPath.row)
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Section.count
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .Information:
            return "Information"
        case .Entities:
            return "Entities"
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .Information:
            return InformationRow.count
        case .Entities:
            return dataController.entityCount()
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = Section(rawValue: indexPath.section)!
        let cell = tableView.dequeueReusableCellWithIdentifier(section.cellIdentifier, forIndexPath: indexPath)
        
        switch section {
        case .Information:
            let row = InformationRow(rawValue: indexPath.row)!
            
            cell.textLabel?.text = row.title
            
            switch row {
            case .ModelName:
                cell.detailTextLabel?.text = dataController.dataStore.modelName
            case .ModelIdentifier:
                let metaData = dataController.metaData()
                let identifiers = metaData[NSStoreModelVersionIdentifiersKey]
                cell.detailTextLabel?.text = identifiers?.componentsJoinedByString("/")
            case .MigrationTime:
                cell.detailTextLabel?.text = String(format: "%fs", dataController!.migrationTime)
            }
        case .Entities:
            cell.textLabel?.text = dataController.entityName(indexPath.row)
        }
        
        return cell
    }
}

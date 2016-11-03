//
//  EntitiesViewController.swift
//

import UIKit

class EntitiesViewController : UITableViewController {
    private enum Section: Int {
        case information
        case entities
        
        static var count: Int {
            return 2
        }
        
        var cellIdentifier: String {
            switch self {
            case .information:
                return "InformationCell"
            case .entities:
                return "EntitiesCell"
            }
        }
    }
    
    private enum InformationRow: Int {
        case modelName
        case modelIdentifier
        case migrationTime
        
        static var count: Int {
            return 3
        }
        
        var title: String {
            switch self {
            case .modelName:
                return "Model Name"
            case .modelIdentifier:
                return "Model Identifier"
            case .migrationTime:
                return "Migration Time"
            }
        }
    }
    
    var dataController : DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? ObjectsViewController, let cell = sender as? UITableViewCell {
            if let indexPath = tableView.indexPath(for: cell) {
                viewController.context = dataController.dataStore.mainContext
                viewController.entityName = dataController.entityName(indexPath.row)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .information:
            return "Information"
        case .entities:
            return "Entities"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .information:
            return InformationRow.count
        case .entities:
            return dataController.entityCount
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Section(rawValue: indexPath.section)!
        let cell = tableView.dequeueReusableCell(withIdentifier: section.cellIdentifier, for: indexPath)
        
        switch section {
        case .information:
            let row = InformationRow(rawValue: indexPath.row)!
            
            cell.textLabel?.text = row.title
            
            switch row {
            case .modelName:
                cell.detailTextLabel?.text = dataController.dataStore.modelName
            case .modelIdentifier:
                let metaData = dataController.metaData
                if let identifiers = metaData[NSStoreModelVersionIdentifiersKey] {
                    cell.detailTextLabel?.text = (identifiers as AnyObject).componentsJoined(by: "/")
                }
            case .migrationTime:
                cell.detailTextLabel?.text = String(format: "%fs", dataController!.migrationTime)
            }
        case .entities:
            cell.textLabel?.text = dataController.entityName(indexPath.row)
        }
        
        return cell
    }
}

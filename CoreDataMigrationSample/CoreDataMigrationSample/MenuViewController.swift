//
//  MenuViewController.swift
//

import UIKit

class MenuViewController : UITableViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController = segue.destinationViewController as? SetupViewController, identifier = segue.identifier {
            switch identifier {
            case LightweightMigrationSetupSegueIdentifier:
                viewController.migrationController = LightweightMigrationController()
            case CustomMigrationSetupSegueIdentifier:
                viewController.migrationController = CustomMigrationController()
            case SeparateMigrationSetupSegueIdentifier:
                viewController.migrationController = SeparateMigrationController()
            default: break
            }
        }
    }
}

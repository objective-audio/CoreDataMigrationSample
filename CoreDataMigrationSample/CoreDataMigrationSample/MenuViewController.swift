//
//  MenuViewController.swift
//

import UIKit

class MenuViewController : UITableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? SetupViewController, let identifier = segue.identifier {
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

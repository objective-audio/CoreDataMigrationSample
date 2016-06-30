//
//  MigrationViewController.swift
//

import UIKit

class MigrationViewController : UIViewController {
    private enum JoinFlag : UInt32 {
        case Appear
        case Migrate
        
        static var count: UInt32 {
            return 2
        }
    }
    
    var migrationController : MigrationController?
    var dataController : DataController?
    var join: Join?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if migrationController == nil {
            fatalError()
        }
        
        self.navigationItem.hidesBackButton = true
        
        join = Join.init(count: JoinFlag.count) { [unowned self] in
            self.performSegueWithIdentifier(EntitiesSegueIdentifier, sender: self)
        }
        
        migrationController?.migrate { [unowned self] (dataController: DataController?) in
            self.dataController = dataController
            self.join?.setFlag(JoinFlag.Migrate.rawValue)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        join?.setFlag(JoinFlag.Appear.rawValue)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController = segue.destinationViewController as? EntitiesViewController where segue.identifier == EntitiesSegueIdentifier {
            viewController.dataController = dataController
        }
    }
}

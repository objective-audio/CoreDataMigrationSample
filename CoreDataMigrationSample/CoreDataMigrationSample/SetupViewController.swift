//
//  SetupViewController.swift
//

import UIKit

class SetupViewController : UIViewController {
    private enum JoinFlag : UInt32 {
        case Appear
        case Setup
        
        static var count: UInt32 {
            return 2
        }
    }
    
    var migrationController : MigrationController?
    var join: Join?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if migrationController == nil {
            fatalError()
        }
        
        self.navigationItem.hidesBackButton = true
        
        join = Join.init(count: JoinFlag.count) { [unowned self] in
            self.performSegueWithIdentifier(MigrationSegueIdentifier, sender: self)
        }
        
        migrationController?.setup { [unowned self] in
            self.join?.setFlag(JoinFlag.Setup.rawValue)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        join?.setFlag(JoinFlag.Appear.rawValue)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController = segue.destinationViewController as? MigrationViewController where segue.identifier == MigrationSegueIdentifier {
            viewController.migrationController = migrationController
        }
    }
}

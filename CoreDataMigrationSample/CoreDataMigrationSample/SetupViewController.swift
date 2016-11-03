//
//  SetupViewController.swift
//

import UIKit

class SetupViewController : UIViewController {
    private enum JoinFlag : UInt32 {
        case appear
        case setup
        
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
            self.performSegue(withIdentifier: MigrationSegueIdentifier, sender: self)
        }
        
        migrationController?.setup { [unowned self] in
            self.join?.setFlag(JoinFlag.setup.rawValue)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        join?.setFlag(JoinFlag.appear.rawValue)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? MigrationViewController, segue.identifier == MigrationSegueIdentifier {
            viewController.migrationController = migrationController
        }
    }
}

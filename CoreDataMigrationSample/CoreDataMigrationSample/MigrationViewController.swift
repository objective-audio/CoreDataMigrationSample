//
//  MigrationViewController.swift
//

import UIKit

class MigrationViewController : UIViewController {
    private enum JoinFlag : UInt32 {
        case appear
        case migrate
        
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
            self.performSegue(withIdentifier: EntitiesSegueIdentifier, sender: self)
        }
        
        migrationController?.migrate { [unowned self] (dataController: DataController?) in
            self.dataController = dataController
            self.join?.setFlag(JoinFlag.migrate.rawValue)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        join?.setFlag(JoinFlag.appear.rawValue)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? EntitiesViewController, segue.identifier == EntitiesSegueIdentifier {
            viewController.dataController = dataController
        }
    }
}

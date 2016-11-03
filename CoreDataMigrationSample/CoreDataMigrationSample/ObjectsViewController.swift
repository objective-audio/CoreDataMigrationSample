//
//  ObjectsViewController.swift
//

import UIKit

class ObjectsViewController : UITableViewController {
    static let ObjectsCellIdentifier: String = "ObjectsCell"
    
    var context: NSManagedObjectContext!
    var entityName: String!
    var fetchResultsController: NSFetchedResultsController<NSManagedObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let context = context, let entityName = entityName else {
            fatalError()
        }
        
        title = "\(entityName) objects"
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: NameKey, ascending: true)]
        
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController.delegate = self
        
        try! fetchResultsController.performFetch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? ObjectViewController, let cell = sender as? UITableViewCell {
            if let indexPath = tableView.indexPath(for: cell) {
                viewController.object = fetchResultsController!.fetchedObjects![indexPath.row]
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultsController.fetchedObjects!.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ObjectsViewController.ObjectsCellIdentifier, for: indexPath)
        if let object = fetchResultsController.fetchedObjects?[indexPath.row], let name = object.value(forKey: NameKey) as? String, let group = object.value(forKey: GroupKey) as? NSNumber {
            cell.textLabel?.text = "Name=\(name) Group=\(group)"
        } else {
            cell.textLabel?.text = nil
        }
        
        return cell
    }
}

extension ObjectsViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}

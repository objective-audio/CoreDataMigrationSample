//
//  ObjectsViewController.swift
//

import UIKit

class ObjectsViewController : UITableViewController {
    static let ObjectsCellIdentifier: String = "ObjectsCell"
    
    var context: NSManagedObjectContext!
    var entityName: String!
    var fetchResultsController: NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let context = context, entityName = entityName else {
            fatalError()
        }
        
        title = "\(entityName) objects"
        
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: NameKey, ascending: true)]
        
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController.delegate = self
        
        try! fetchResultsController.performFetch()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController = segue.destinationViewController as? ObjectViewController, cell = sender as? UITableViewCell {
            if let indexPath = tableView.indexPathForCell(cell) {
                viewController.object = fetchResultsController!.fetchedObjects![indexPath.row] as! NSManagedObject
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultsController.fetchedObjects!.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ObjectsViewController.ObjectsCellIdentifier, forIndexPath: indexPath)
        if let object = fetchResultsController.fetchedObjects?[indexPath.row], name = object.valueForKey(NameKey) as? String, group = object.valueForKey(GroupKey) as? NSNumber {
            cell.textLabel?.text = "Name=\(name) Group=\(group)"
        } else {
            cell.textLabel?.text = nil
        }
        
        return cell
    }
}

extension ObjectsViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
}

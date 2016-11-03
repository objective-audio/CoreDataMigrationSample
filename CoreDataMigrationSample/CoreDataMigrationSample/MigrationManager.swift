//
//  MigrationManager.swift
//

class MigrationManager : NSMigrationManager {
    private var _cacheNames = [String: Set<String>]()
    private var _fetchedCacheObjects = [String: [String: NSManagedObject]]()
    
    func fetchRequestForSourceEntityNamed(_ entityName: String, predicate: NSPredicate) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = NSEntityDescription.entity(forEntityName: entityName, in: self.sourceContext)
        request.includesSubentities = false
        request.predicate = predicate
        return request
    }
    
    func addCacheName(_ name: String, entityName: String) {
        if _cacheNames[entityName] == nil {
            _cacheNames[entityName] = Set<String>()
        }
        _cacheNames[entityName]!.insert(name)
    }
    
    func fetchCacheObject(for name: String, entityName: String) -> NSManagedObject? {
        if _fetchedCacheObjects[entityName] == nil && _cacheNames[entityName] != nil {
            let fetchedObjects = fetchObjects(entityName: entityName, forKey: NameKey, sourceValues: _cacheNames[entityName]! as NSSet, in: destinationContext)
            
            var objects = [String: NSManagedObject]()
            
            for object in fetchedObjects {
                let name = object.value(forKey: NameKey) as! String
                objects[name] = object
            }
            
            _fetchedCacheObjects[entityName] = objects
        }
        
        return _fetchedCacheObjects[entityName]![name]
    }
    
    private func fetchObjects(entityName: String, forKey key: String, sourceValues values: NSSet, in context: NSManagedObjectContext) -> [NSManagedObject] {
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        request.includesSubentities = false
        request.predicate = NSPredicate(format: "%K IN %@", key, values)
        return try! context.fetch(request) as! [NSManagedObject]
    }
}

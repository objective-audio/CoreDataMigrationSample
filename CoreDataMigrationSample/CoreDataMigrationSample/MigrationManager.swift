//
//  MigrationManager.swift
//

class MigrationManager : NSMigrationManager {
    private var _cacheNames = [String: Set<String>]()
    private var _fetchedCacheObjects = [String: [String: NSManagedObject]]()
    
    func fetchRequestForSourceEntityNamed(entityName: String, predicate: NSPredicate) -> NSFetchRequest {
        let request = NSFetchRequest()
        request.entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: self.sourceContext)
        request.includesSubentities = false
        request.predicate = predicate
        return request
    }
    
    func addCacheName(name: String, entityName: String) {
        if _cacheNames[entityName] == nil {
            _cacheNames[entityName] = Set<String>()
        }
        _cacheNames[entityName]!.insert(name)
    }
    
    func fetchCacheObjectForName(name: String, entityName: String) -> NSManagedObject? {
        if _fetchedCacheObjects[entityName] == nil && _cacheNames[entityName] != nil {
            let fetchedObjects = fetchObjects(entityName: entityName, forKey: NameKey, sourceValues: _cacheNames[entityName]!, inContext: destinationContext)
            
            var objects = [String: NSManagedObject]()
            
            for object in fetchedObjects {
                let name = object.valueForKey(NameKey) as! String
                objects[name] = object
            }
            
            _fetchedCacheObjects[entityName] = objects
        }
        
        return _fetchedCacheObjects[entityName]![name]
    }
    
    private func fetchObjects(entityName entityName: String, forKey key: String, sourceValues values: NSSet, inContext context: NSManagedObjectContext) -> [NSManagedObject] {
        let request = NSFetchRequest()
        request.entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)
        request.includesSubentities = false
        request.predicate = NSPredicate(format: "%K IN %@", key, values)
        return try! context.executeFetchRequest(request) as! [NSManagedObject]
    }
}

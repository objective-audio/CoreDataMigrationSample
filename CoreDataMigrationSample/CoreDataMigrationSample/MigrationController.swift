//
//  MigrationController.swift
//

typealias MigrateCompletionHandler = (DataController?) -> Void

class MigrationController {
    func setup(completion: VoidHandler) {
        FileUtils.removeDocumentDirectoryContents()
        
        let dataStore = UBICoreDataStore.init(model: FileUtils.model(CoreDataModelName, version: 1),
                                              storeURL: FileUtils.sourceStoreURL())
        
        let privateContext = dataStore.mainContext.newPrivateQueueContext()
        
        privateContext.performBlock { 
            for i : UInt in 0..<10000 {
                let objectA = NSEntityDescription.insertNewObjectForEntityForName(EntityAName, inManagedObjectContext: privateContext)
                objectA.setValue(NSNumber(unsignedInteger: i % MigrationGroupCount), forKey: GroupKey)
                objectA.setValue(String(format: "A-%05u", i), forKey: NameKey)
                
                let objectB = NSEntityDescription.insertNewObjectForEntityForName(EntityBName, inManagedObjectContext: privateContext)
                objectB.setValue(NSNumber(unsignedInteger: i % MigrationGroupCount), forKey: GroupKey)
                objectB.setValue(String(format: "B-%05u", i), forKey: NameKey)
                
                objectA.setValue(objectB, forKey: RelationshipKey)
                
                if (i % 100) == 0 && i > 0 {
                    privateContext.saveToPersistentStore()
                    privateContext.reset()
                }
            }
            
            privateContext.saveToPersistentStore()
            privateContext.reset()
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC)), dispatch_get_main_queue(), { 
                completion()
            })
        }
    }
    
    func migrate(completion: MigrateCompletionHandler) {
        fatalError("Must be overridden")
    }
}

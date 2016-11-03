//
//  MigrationController.swift
//

typealias MigrateCompletionHandler = (DataController?) -> Void

protocol MigrationController {
    func setup(_ completion: @escaping VoidHandler)
    func migrate(_ completion: @escaping MigrateCompletionHandler)
}

extension MigrationController {
    func setup(_ completion: @escaping VoidHandler) {
        FileUtils.removeDocumentDirectoryContents()
        
        let dataStore = UBICoreDataStore.init(model: FileUtils.model(CoreDataModelName, version: 1),
                                              store: FileUtils.sourceStoreURL())
        
        let privateContext = dataStore.mainContext.newPrivateQueue()
        
        privateContext.perform {
            for i : UInt in 0..<10000 {
                let objectA = NSEntityDescription.insertNewObject(forEntityName: EntityAName, into: privateContext)
                objectA.setValue(NSNumber(value: i % MigrationGroupCount as UInt), forKey: GroupKey)
                objectA.setValue(String(format: "A-%05u", i), forKey: NameKey)
                
                let objectB = NSEntityDescription.insertNewObject(forEntityName: EntityBName, into: privateContext)
                objectB.setValue(NSNumber(value: i % MigrationGroupCount as UInt), forKey: GroupKey)
                objectB.setValue(String(format: "B-%05u", i), forKey: NameKey)
                
                objectA.setValue(objectB, forKey: RelationshipKey)
                
                if (i % 100) == 0 && i > 0 {
                    privateContext.saveToPersistentStore()
                    privateContext.reset()
                }
            }
            
            privateContext.saveToPersistentStore()
            privateContext.reset()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
                completion()
            })
        }
    }
}

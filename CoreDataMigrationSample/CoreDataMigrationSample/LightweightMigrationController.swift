//
//  LightweightMigrationController.swift
//

class LightweightMigrationController : MigrationController {
    func migrate(_ completion: @escaping MigrateCompletionHandler) {
        DispatchQueue.global().async {
            let dataController = DataController(store: FileUtils.sourceStoreURL())
            
            let startTime = CFAbsoluteTimeGetCurrent()
            
            dataController.dataStore.mainContext.save()
            
            dataController.migrationTime = CFAbsoluteTimeGetCurrent() - startTime;
            
            DispatchQueue.main.async(execute: { 
                completion(dataController)
            })
        }
    }
}

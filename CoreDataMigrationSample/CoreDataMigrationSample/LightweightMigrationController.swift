//
//  LightweightMigrationController.swift
//

class LightweightMigrationController : MigrationController {
    override func migrate(completion: MigrateCompletionHandler) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let dataController = DataController(storeURL: FileUtils.sourceStoreURL())
            
            let startTime = CFAbsoluteTimeGetCurrent()
            
            dataController.dataStore.mainContext.save()
            
            dataController.migrationTime = CFAbsoluteTimeGetCurrent() - startTime;
            
            dispatch_async(dispatch_get_main_queue(), { 
                completion(dataController)
            })
        }
    }
}

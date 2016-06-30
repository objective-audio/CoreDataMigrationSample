//
//  CustomMigrationController.swift
//

class CustomMigrationController : MigrationController {
    override func migrate(completion: MigrateCompletionHandler) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { 
            let sourceModel = FileUtils.model(CoreDataModelName, version: 1)
            let destinationModel = FileUtils.model(CoreDataModelName, version: 2)
            let mappingModel = FileUtils.mappingModel(CoreDataModelName, sourceVersion: 1, destinationVersion: 2)
            
            var dataController: DataController? = nil
            
            let startTime = CFAbsoluteTimeGetCurrent()
            
            let migrationManager = NSMigrationManager(sourceModel: sourceModel, destinationModel: destinationModel)
            
            do {
                try migrationManager.migrateStoreFromURL(FileUtils.sourceStoreURL(),
                                                         type: NSSQLiteStoreType,
                                                         options: nil,
                                                         withMappingModel: mappingModel,
                                                         toDestinationURL: FileUtils.destinationStoreURL(),
                                                         destinationType: NSSQLiteStoreType,
                                                         destinationOptions: nil)
                
                dataController = DataController(storeURL: FileUtils.destinationStoreURL())
                dataController?.migrationTime = CFAbsoluteTimeGetCurrent() - startTime
            } catch {
                print("migration error : \(error)")
            }
            
            dispatch_async(dispatch_get_main_queue(), { 
                completion(dataController)
            })
        }
    }
}

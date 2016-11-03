//
//  CustomMigrationController.swift
//

class CustomMigrationController : MigrationController {
    func migrate(_ completion: @escaping MigrateCompletionHandler) {
        DispatchQueue.global().async {
            let sourceModel = FileUtils.model(CoreDataModelName, version: 1)
            let destinationModel = FileUtils.model(CoreDataModelName, version: 2)
            let mappingModel = FileUtils.mappingModel(CoreDataModelName, sourceVersion: 1, destinationVersion: 2)
            
            var dataController: DataController? = nil
            
            let startTime = CFAbsoluteTimeGetCurrent()
            
            let migrationManager = NSMigrationManager(sourceModel: sourceModel, destinationModel: destinationModel)
            
            do {
                try migrationManager.migrateStore(from: FileUtils.sourceStoreURL(),
                                                  sourceType: NSSQLiteStoreType,
                                                  options: nil,
                                                  with: mappingModel,
                                                  toDestinationURL: FileUtils.destinationStoreURL(),
                                                  destinationType: NSSQLiteStoreType,
                                                  destinationOptions: nil)
                
                dataController = DataController(store: FileUtils.destinationStoreURL())
                dataController?.migrationTime = CFAbsoluteTimeGetCurrent() - startTime
            } catch {
                print("migration error : \(error)")
            }
            
            DispatchQueue.main.async(execute: {
                completion(dataController)
            })
        }
    }
}

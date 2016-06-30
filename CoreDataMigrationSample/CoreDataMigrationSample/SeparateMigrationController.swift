//
//  SeparateMigrationController.swift
//

class SeparateMigrationController : MigrationController {
    override func migrate(completion: MigrateCompletionHandler) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let originalMappingModel = FileUtils.mappingModel(CoreDataModelName, sourceVersion: 1, destinationVersion: 2)
            var mappingModels = [NSMappingModel]()
            
            // EntityA -> EntityB の順番でそれぞれ8分割したMappingModelを生成
            for entityName in [EntityAName, EntityBName] {
                mappingModels.appendContentsOf(MigrationUtils.mappingModels(entityName, fromMappingModel: originalMappingModel))
            }
            
            let srcModel = FileUtils.model(CoreDataModelName, version: 1)
            let dstModel = FileUtils.model(CoreDataModelName, version: 2)
            
            var success = true
            
            let startTime = CFAbsoluteTimeGetCurrent()
            
            // 分割されたMappingModelの数だけマイグレーションを繰り返す
            for mappingModel in mappingModels {
                autoreleasepool({ 
                    let migrationManager = MigrationManager(sourceModel: srcModel, destinationModel: dstModel)
                    do {
                        try migrationManager.migrateStoreFromURL(FileUtils.sourceStoreURL(),
                            type: NSSQLiteStoreType,
                            options: nil,
                            withMappingModel: mappingModel,
                            toDestinationURL: FileUtils.destinationStoreURL(),
                            destinationType: NSSQLiteStoreType,
                            destinationOptions: nil)
                    } catch {
                        success = false
                    }
                })
                
                if !success {
                    break
                }
            }
            
            var dataController: DataController?
            
            if success {
                dataController = DataController(storeURL: FileUtils.destinationStoreURL())
                dataController!.migrationTime = CFAbsoluteTimeGetCurrent() - startTime
            }
            
            dispatch_async(dispatch_get_main_queue(), { 
                completion(dataController)
            })
        }
    }
}

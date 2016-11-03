//
//  SeparateMigrationController.swift
//

class SeparateMigrationController : MigrationController {
    func migrate(_ completion: @escaping MigrateCompletionHandler) {
        DispatchQueue.global().async {
            let originalMappingModel = FileUtils.mappingModel(CoreDataModelName, sourceVersion: 1, destinationVersion: 2)
            var mappingModels = [NSMappingModel]()
            
            // EntityA -> EntityB の順番でそれぞれ8分割したMappingModelを生成
            for entityName in [EntityAName, EntityBName] {
                mappingModels.append(contentsOf: MigrationUtils.mappingModels(entityName, fromMappingModel: originalMappingModel))
            }
            
            let srcModel = FileUtils.model(CoreDataModelName, version: 1)
            let dstModel = FileUtils.model(CoreDataModelName, version: 2)
            
            var success = true
            
            let startTime = CFAbsoluteTimeGetCurrent()
            
            // 分割されたMappingModelの数だけマイグレーションを繰り返す
            for mappingModel in mappingModels {
                autoreleasepool(invoking: { 
                    let migrationManager = MigrationManager(sourceModel: srcModel, destinationModel: dstModel)
                    do {
                        try migrationManager.migrateStore(from: FileUtils.sourceStoreURL(),
                            sourceType: NSSQLiteStoreType,
                            options: nil,
                            with: mappingModel,
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
                dataController = DataController(store: FileUtils.destinationStoreURL())
                dataController!.migrationTime = CFAbsoluteTimeGetCurrent() - startTime
            }
            
            DispatchQueue.main.async(execute: { 
                completion(dataController)
            })
        }
    }
}

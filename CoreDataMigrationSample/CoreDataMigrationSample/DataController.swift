//
//  DataController.swift
//

class DataController {
    let dataStore: UBICoreDataStore
    var migrationTime: CFTimeInterval
    
    init(storeURL: NSURL) {
        dataStore = UBICoreDataStore.init(modelName: CoreDataModelName, storeURL: storeURL)
        migrationTime = 0.0
    }
    
    func metaData() -> [String: AnyObject] {
        if let coordinator = dataStore.mainContext.persistentStoreCoordinator {
            if let store = coordinator.persistentStores.last {
                return coordinator.metadataForPersistentStore(store)
            }
        }
        return [:]
    }
    
    func entityCount() -> Int {
        return dataStore.managedObjectModel.entities.count
    }
    
    func entityName(index: Int) -> String? {
        return dataStore.managedObjectModel.entities[index].name;
    }
}

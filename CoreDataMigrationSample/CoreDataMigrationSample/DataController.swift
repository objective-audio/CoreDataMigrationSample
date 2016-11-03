//
//  DataController.swift
//

class DataController {
    let dataStore: UBICoreDataStore
    var migrationTime: CFTimeInterval
    
    var entityCount: Int {
        return dataStore.managedObjectModel.entities.count
    }
    
    var metaData: [String: Any] {
        if let coordinator = dataStore.mainContext.persistentStoreCoordinator {
            if let store = coordinator.persistentStores.last {
                return coordinator.metadata(for: store)
            }
        }
        return [:]
    }
    
    // MARK:
    
    init(store storeURL: URL) {
        dataStore = UBICoreDataStore.init(modelName: CoreDataModelName, store: storeURL)
        migrationTime = 0.0
    }
    
    func entityName(_ index: Int) -> String? {
        return dataStore.managedObjectModel.entities[index].name;
    }
}

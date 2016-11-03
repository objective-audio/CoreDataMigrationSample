//
//  MigrationUtils.swift
//

struct MigrationUtils {
    static func mappingModels(_ entityName: String, fromMappingModel: NSMappingModel) -> [NSMappingModel] {
        var mappingModels = [NSMappingModel]()
        
        // "プロジェクト名.マイグレーションポリシー名"で大丈夫か？
        let migrationPolicyClassName = "CoreDataMigrationSample.\(entityName)MigrationPolicy"
        
        // ここでは１つのエンティティにつき8個に分割する
        for groupIndex in 0..<MigrationGroupCount {
            let newMappingModel = fromMappingModel.copy() as! NSMappingModel
            
            for entityMapping in newMappingModel.entityMappings {
                // 必要なエンティティだけ残す
                let sourceEntityName = entityMapping.sourceEntityName
                if sourceEntityName == entityName {
                    // MigrationPolicyのクラス名をセット
                    entityMapping.entityMigrationPolicyClassName = migrationPolicyClassName
                    
                    // Filter Predicateを差し替える（分割以外にフィルターしたい条件があればここで加える）
                    let predicate = NSPredicate(format: "%K == \(groupIndex)", GroupKey)
                    entityMapping.sourceExpression = sourceExpression(entityName, predicate: predicate)
                    newMappingModel.entityMappings = [entityMapping]
                    
                    break
                }
            }
            
            mappingModels.append(newMappingModel)
        }
        
        return mappingModels
    }
    
    static private func sourceExpression(_ entityName: String, predicate: NSPredicate) -> NSExpression {
        let entityNameExpression = NSExpression(forConstantValue: entityName)
        let predicateExpression = NSExpression(forConstantValue: predicate)
        let functionExpression = NSExpression(forFunction: NSExpression(format: "$manager"), selectorName: "fetchRequestForSourceEntityNamed:predicate:", arguments: [entityNameExpression, predicateExpression])
        let contextExpression = NSExpression(format: "$manager.sourceContext")
        return NSFetchRequestExpression.expression(forFetch: functionExpression, context: contextExpression, countOnly: false)
    }
    
    static func copyAttributes(fromSourceInstance sInstance: NSManagedObject, toDestinationInstance dInstance: NSManagedObject, entityMapping: NSEntityMapping) {
        // オブジェクトの属性全てをコピーする
        if let mappings = entityMapping.attributeMappings {
            for propertyMapping in mappings {
                if let name = propertyMapping.name {
                    if let value = propertyMapping.valueExpression?.expressionValue(with: nil, context: ["source": sInstance]) {
                        dInstance.setValue(value, forKey: name)
                    }
                }
            }
        }
    }
}

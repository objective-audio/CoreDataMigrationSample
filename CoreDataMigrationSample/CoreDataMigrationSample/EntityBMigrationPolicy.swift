//
//  EntityBMigrationPolicy.swift
//

class EntityBMigrationPolicy : NSEntityMigrationPolicy {
    enum PolicyError : Error {
        case managerCastFailed
        case sourceInstanceNotFound
        case relationshipMappingsNotFound
    }
    
    override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        guard let manager = manager as? MigrationManager else {
            throw PolicyError.managerCastFailed
        }
        
        // Destinationにオブジェクトを生成
        let dInstance = NSEntityDescription.insertNewObject(forEntityName: EntityBName, into: manager.destinationContext)
        
        // SourceのオブジェクトからDestinationのオブジェクトに属性をコピー
        
        MigrationUtils.copyAttributes(fromSourceInstance: sInstance, toDestinationInstance: dInstance, entityMapping: mapping)
        
        // 関連付けのためにEntityAのIDとなるnameの値を保存
        let sRelationship = sInstance.value(forKey: RelationshipKey)
        if let entityAName = (sRelationship as AnyObject).value(forKey: NameKey) as? String {
            manager.addCacheName(entityAName, entityName: EntityAName)
        }
        
        // 関連のステージを実行するためにMigrationManagerに登録
        manager.associate(sourceInstance: sInstance, withDestinationInstance: dInstance, for: mapping)
    }
    
    override func createRelationships(forDestination dInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        guard let manager = manager as? MigrationManager else {
            throw PolicyError.managerCastFailed
        }
        
        // ここの処理は、モデルの構成によってもっと調整する必要がある
        
        // DestinationのオブジェクトからSourceのオブジェクトを取得
        guard let sInstance = manager.sourceInstances(forEntityMappingName: mapping.name, destinationInstances: [dInstance]).first else {
            throw PolicyError.sourceInstanceNotFound
        }
        
        // EntityMappingから関連を走査
        guard let relationshipMappings = mapping.relationshipMappings else {
            throw PolicyError.relationshipMappingsNotFound
        }
        
        for propertyMapping in relationshipMappings {
            if propertyMapping.valueExpression == nil {
                continue
            }
            
            if propertyMapping.name == RelationshipKey {
                // Sourceのオブジェクトから関連先のEntityAのnameを取得
                let sRelationship = sInstance.value(forKey: RelationshipKey) as AnyObject
                if let name = sRelationship.value(forKey: NameKey) as? String {
                    if let dRelationship = manager.fetchCacheObject(for: name, entityName: EntityAName) {
                        dInstance.setValue(dRelationship, forKey: RelationshipKey)
                    }
                }
            }
        }
    }
}

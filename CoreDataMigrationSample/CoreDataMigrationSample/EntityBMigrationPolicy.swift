//
//  EntityBMigrationPolicy.swift
//

class EntityBMigrationPolicy : NSEntityMigrationPolicy {
    enum Error : ErrorType {
        case ManagerCastFailed
        case SourceInstanceNotFound
        case RelationshipMappingsNotFound
    }
    
    override func createDestinationInstancesForSourceInstance(sInstance: NSManagedObject, entityMapping mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        guard let manager = manager as? MigrationManager else {
            throw Error.ManagerCastFailed
        }
        
        // Destinationにオブジェクトを生成
        let dInstance = NSEntityDescription.insertNewObjectForEntityForName(EntityBName, inManagedObjectContext: manager.destinationContext)
        
        // SourceのオブジェクトからDestinationのオブジェクトに属性をコピー
        
        MigrationUtils.copyAttributes(fromSourceInstance: sInstance, toDestinationInstance: dInstance, entityMapping: mapping)
        
        // 関連付けのためにEntityAのIDとなるnameの値を保存
        let sRelationship = sInstance.valueForKey(RelationshipKey)
        if let entityAName = sRelationship?.valueForKey(NameKey) as? String {
            manager.addCacheName(entityAName, entityName: EntityAName)
        }
        
        // 関連のステージを実行するためにMigrationManagerに登録
        manager.associateSourceInstance(sInstance, withDestinationInstance: dInstance, forEntityMapping: mapping)
    }
    
    override func createRelationshipsForDestinationInstance(dInstance: NSManagedObject, entityMapping mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        guard let manager = manager as? MigrationManager else {
            throw Error.ManagerCastFailed
        }
        
        // ここの処理は、モデルの構成によってもっと調整する必要がある
        
        // DestinationのオブジェクトからSourceのオブジェクトを取得
        guard let sInstance = manager.sourceInstancesForEntityMappingNamed(mapping.name, destinationInstances: [dInstance]).first else {
            throw Error.SourceInstanceNotFound
        }
        
        // EntityMappingから関連を走査
        guard let relationshipMappings = mapping.relationshipMappings else {
            throw Error.RelationshipMappingsNotFound
        }
        
        for propertyMapping in relationshipMappings {
            if propertyMapping.valueExpression == nil {
                continue
            }
            
            if propertyMapping.name == RelationshipKey {
                // Sourceのオブジェクトから関連先のEntityAのnameを取得
                let sRelationship = sInstance.valueForKey(RelationshipKey)
                if let name = sRelationship?.valueForKey(NameKey) as? String {
                    if let dRelationship = manager.fetchCacheObjectForName(name, entityName: EntityAName) {
                        dInstance.setValue(dRelationship, forKey: RelationshipKey)
                    }
                }
            }
        }
    }
}

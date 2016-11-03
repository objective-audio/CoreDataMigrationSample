//
//  EntityAMigrationPolicy.swift
//

class EntityAMigrationPolicy : NSEntityMigrationPolicy {
    override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        // Destinationにオブジェクトを生成
        let dInstance = NSEntityDescription.insertNewObject(forEntityName: EntityAName, into: manager.destinationContext)
        
        // SourceのオブジェクトからDestinationのオブジェクトに属性をコピー
        
        MigrationUtils.copyAttributes(fromSourceInstance: sInstance, toDestinationInstance: dInstance, entityMapping: mapping)
        
        // EntityAはEntityBより先にオブジェクトを生成するので関連付けをしない
    }
}

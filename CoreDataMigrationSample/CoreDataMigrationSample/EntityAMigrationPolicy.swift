//
//  EntityAMigrationPolicy.swift
//

class EntityAMigrationPolicy : NSEntityMigrationPolicy {
    override func createDestinationInstancesForSourceInstance(sInstance: NSManagedObject, entityMapping mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        // Destinationにオブジェクトを生成
        let dInstance = NSEntityDescription.insertNewObjectForEntityForName(EntityAName, inManagedObjectContext: manager.destinationContext)
        
        // SourceのオブジェクトからDestinationのオブジェクトに属性をコピー
        
        MigrationUtils.copyAttributes(fromSourceInstance: sInstance, toDestinationInstance: dInstance, entityMapping: mapping)
        
        // EntityAはEntityBより先にオブジェクトを生成するので関連付けをしない
    }
}

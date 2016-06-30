//
//  Types.swift
//

typealias VoidHandler = (Void) -> Void

let LightweightMigrationSetupSegueIdentifier: String = "lightweight"
let CustomMigrationSetupSegueIdentifier: String = "custom"
let SeparateMigrationSetupSegueIdentifier: String = "separate"
let MigrationSegueIdentifier: String = "migration"
let EntitiesSegueIdentifier: String = "entities"

let CoreDataModelName: String = "Model"
let CoreDataSourceStoreFileName: String = "SourceData.sqlite"
let CoreDataDestinationStoreFileName: String = "DestinationData.sqlite"

let EntityAName: String = "EntityA"
let EntityBName: String = "EntityB"
let NameKey: String = "name"
let GroupKey: String = "group"
let RelationshipKey: String = "relationship"

let MigrationGroupCount: UInt = 8

let CoreDataMigrationSampleErrorDomain: String = "coredata_migration_sample"

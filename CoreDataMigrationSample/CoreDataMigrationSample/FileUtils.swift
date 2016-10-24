//
//  FileUtils.swift
//

struct FileUtils {
    static func sourceStoreURL() -> NSURL {
        return documentDirectoryURL().URLByAppendingPathComponent(CoreDataSourceStoreFileName)!
    }
    
    static func destinationStoreURL() -> NSURL {
        return documentDirectoryURL().URLByAppendingPathComponent(CoreDataDestinationStoreFileName)!
    }
    
    static func documentDirectoryURL() -> NSURL {
        return NSURL(fileURLWithPath: documentDirectoryPath())
    }
    
    static func documentDirectoryPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last!
    }
    
    static func removeDocumentDirectoryContents() {
        let fileManager = NSFileManager()
        let contents = try! fileManager.contentsOfDirectoryAtPath(documentDirectoryPath())
        for content in contents {
            try! fileManager.removeItemAtURL(documentDirectoryURL().URLByAppendingPathComponent(content)!)
        }
    }
    
    static func moveFile(srcURL: NSURL, toURL: NSURL) {
        let fileManager = NSFileManager()
        
        if fileManager.fileExistsAtPath(toURL.path!) {
            try! fileManager.removeItemAtURL(toURL)
        }
        
        try! fileManager.moveItemAtURL(srcURL, toURL: toURL)
    }
    
    static func model(name: String, version: UInt) -> NSManagedObjectModel {
        let versionString = version < 1 ? "" : " \(version)"
        let modelURL = NSBundle.mainBundle().URLForResource("\(name).momd/\(name)\(versionString)", withExtension: "mom")
        return NSManagedObjectModel(contentsOfURL: modelURL!)!
    }
    
    static func mappingModel(name: String, sourceVersion: UInt, destinationVersion: UInt) -> NSMappingModel {
        let mappingModelURL = NSBundle.mainBundle().URLForResource("\(name)\(sourceVersion)-\(destinationVersion)", withExtension: "cdm")
        return NSMappingModel(contentsOfURL: mappingModelURL!)!
    }
}

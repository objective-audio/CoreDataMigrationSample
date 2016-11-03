//
//  FileUtils.swift
//

struct FileUtils {
    static func sourceStoreURL() -> URL {
        return documentDirectoryURL().appendingPathComponent(CoreDataSourceStoreFileName)
    }
    
    static func destinationStoreURL() -> URL {
        return documentDirectoryURL().appendingPathComponent(CoreDataDestinationStoreFileName)
    }
    
    static func documentDirectoryURL() -> URL {
        return URL(fileURLWithPath: documentDirectoryPath())
    }
    
    static func documentDirectoryPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
    }
    
    static func removeDocumentDirectoryContents() {
        let fileManager = FileManager()
        let contents = try! fileManager.contentsOfDirectory(atPath: documentDirectoryPath())
        for content in contents {
            try! fileManager.removeItem(at: documentDirectoryURL().appendingPathComponent(content))
        }
    }
    
    static func moveFile(at srcURL: URL, to dstURL: URL) {
        let fileManager = FileManager()
        
        if fileManager.fileExists(atPath: dstURL.path) {
            try! fileManager.removeItem(at: dstURL)
        }
        
        try! fileManager.moveItem(at: srcURL, to: dstURL)
    }
    
    static func model(_ name: String, version: UInt) -> NSManagedObjectModel {
        let versionString = version < 1 ? "" : " \(version)"
        let modelURL = Bundle.main.url(forResource: "\(name).momd/\(name)\(versionString)", withExtension: "mom")
        return NSManagedObjectModel(contentsOf: modelURL!)!
    }
    
    static func mappingModel(_ name: String, sourceVersion: UInt, destinationVersion: UInt) -> NSMappingModel {
        let mappingModelURL = Bundle.main.url(forResource: "\(name)\(sourceVersion)-\(destinationVersion)", withExtension: "cdm")
        return NSMappingModel(contentsOf: mappingModelURL!)!
    }
}

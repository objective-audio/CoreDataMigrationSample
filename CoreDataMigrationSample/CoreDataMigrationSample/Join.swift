//
//  Join.swift
//

class Join {
    private var joinedHandler: VoidHandler?
    private let count: UInt32
    private var flags: UInt32;
    private let compareFlags: UInt32
    
    init(count: UInt32, joinedHandler: VoidHandler) {
        if (count > UInt32(sizeof(UInt32) * 8)) {
            fatalError()
        }
        
        self.count = count
        self.joinedHandler = joinedHandler
        self.flags = 0
        
        var prepareFlags: UInt32 = 0
        for i: UInt32 in 0..<count {
            prepareFlags |= 1 << i
        }
        compareFlags = prepareFlags
    }
    
    func setFlag(flag: UInt32) {
        if (flag > UInt32(sizeof(UInt32) * 8)) {
            fatalError()
        }
        
        flags |= 1 << flag
        
        if ((self.flags & self.compareFlags) == self.compareFlags) {
            if let handler = joinedHandler {
                handler()
                joinedHandler = nil
            }
        }
    }
}

//
//  FilePresentation.swift
//  Deluge
//
//  Created by Yotam Ohayon on 21/05/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation

class FilePresentation: NSObject, NSCoding {
    
    enum Keys: String {
        case fileName, level, isDir
    }
    
    let fileName: String
    let level: Int
    let isDir: Bool
    
    init(fileName: String, level: Int, isDir: Bool) {
        
        self.fileName = fileName
        self.level = level
        self.isDir = isDir
        
        super.init()
        
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.fileName, forKey: Keys.fileName.rawValue)
        aCoder.encode(self.level, forKey: Keys.level.rawValue)
        aCoder.encode(self.isDir, forKey: Keys.isDir.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        
        guard let fileName = aDecoder.decodeObject(forKey: Keys.fileName.rawValue) as? String else {
            return nil
        }
        
        let level = aDecoder.decodeInteger(forKey: Keys.level.rawValue)
        let isDir = aDecoder.decodeBool(forKey: Keys.isDir.rawValue)
        
        self.init(fileName: fileName, level: level, isDir: isDir)
        
    }
    
}

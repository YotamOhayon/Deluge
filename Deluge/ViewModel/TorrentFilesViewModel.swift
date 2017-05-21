//
//  TorrentFilesViewModel.swift
//  Deluge
//
//  Created by Yotam Ohayon on 16/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Delugion

protocol TorrentFilesViewModeling {
    var torrentFiles: Driver<[FilePresentation]?> { get }
}

class TorrentFilesViewModel: TorrentFilesViewModeling {
    
    let torrentFiles: Driver<[FilePresentation]?>
    
    init(torrentHash: String,
         delugionService: DelugionServicing,
         userDefaults: UserDefaults) {
        
        self.torrentFiles = {
            if let data = userDefaults.torrentArray(forKey: torrentHash) {
                return Driver.just(data)
            }
            else {
                return delugionService.torrentFiles(hash: torrentHash)
                    .map {
                        switch $0 {
                        case .error(_):
                            return nil
                        case .valid(let contents):
                            let ret = contents.orderFiles()
                            userDefaults.set(ret, forKey: torrentHash)
                            return ret
                        }
                    }.asDriver(onErrorJustReturn: nil)
            }
        }()
        
    }
    
}

fileprivate extension TorrentContent {
    
    func orderFiles() -> [FilePresentation] {
        guard let a = self.contents.first else {
            return [FilePresentation]()
        }
        return self.orderFilesHelper(node: a.1, array: [FilePresentation](), level: 0)
    }
    
    func orderFilesHelper(node: TorrentFile,
                          array: [FilePresentation],
                          level: Int) -> [FilePresentation] {
        
        var array = array
        
        array.append(FilePresentation(fileName: node.path,
                                      level: level,
                                      isDir: node.type == "dir"))
        
        node.contents?.forEach{ (key, value) in
            if value.type == "dir" {
                array.append(contentsOf: self.orderFilesHelper(node: value,
                                                               array: [],
                                                               level: level + 1))
            }
            else {
                array.append(FilePresentation(fileName: key,
                                              level: level + 1,
                                              isDir: value.type == "dir"))
            }
        }
        return array.sorted(by: { (a, b) -> Bool in
            a.level < b.level &&  a.fileName < b.fileName
        })
    }
    
}

class FilePresentation: NSObject, NSCoding {
    
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
        aCoder.encode(self.fileName, forKey: "fileName")
        aCoder.encode(self.level, forKey: "level")
        aCoder.encode(self.isDir, forKey: "isDir")
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        
        guard let fileName = aDecoder.decodeObject(forKey: "fileName") as? String else {
            return nil
        }
        
        let level = aDecoder.decodeInteger(forKey: "level")
        let isDir = aDecoder.decodeBool(forKey: "isDir")
        
        self.init(fileName: fileName, level: level, isDir: isDir)
        
    }
    
}

extension UserDefaults {
    
    func set(_ array: [FilePresentation], forKey key: String) {
        let newArray = NSArray(array: array)
        let data = NSKeyedArchiver.archivedData(withRootObject: newArray)
        self.setValue(data, forKey: key)
        self.synchronize()
    }
    
    func torrentArray(forKey key: String) -> [FilePresentation]? {
        
        guard let data = self.object(forKey: key) as? Data,
            let array = NSKeyedUnarchiver.unarchiveObject(with: data) as? [FilePresentation] else {
            return nil
        }
        
        return array
        
    }
    
}

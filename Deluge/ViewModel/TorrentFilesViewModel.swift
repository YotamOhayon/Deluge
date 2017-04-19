//
//  TorrentFilesViewModel.swift
//  Deluge
//
//  Created by Yotam Ohayon on 16/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import RxCocoa
import Delugion

protocol TorrentFilesViewModeling {
    var torrentFiles: Driver<[FilePresentation]?> { get }
}

class TorrentFilesViewModel: TorrentFilesViewModeling {
    
    let torrentFiles: Driver<[FilePresentation]?>
    
    init(torrentHash: String, delugionService: DelugionServicing) {
        
        self.torrentFiles = delugionService.torrentFiles(hash: torrentHash)
            .map {
                switch $0 {
                case .error(_):
                    return nil
                case .valid(let contents):
                    return contents.orderFiles()
                }
            }.asDriver(onErrorJustReturn: nil)
        
    }
    
}

extension TorrentContent {
    
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
                                                               array: array,
                                                               level: level + 1))
            }
            else {
                array.append(FilePresentation(fileName: value.path,
                                              level: level + 1,
                                              isDir: value.type == "dir"))
            }
        }
        return array.sorted(by: { (a, b) -> Bool in
            a.fileName < b.fileName
        })
    }
    
}

struct FilePresentation {
    
    let fileName: String
    let level: Int
    let isDir: Bool
    
}

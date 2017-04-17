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
    var torrentFiles: Driver<[String]?> { get }
}

class TorrentFilesViewModel: TorrentFilesViewModeling {
    
    let torrentFiles: Driver<[String]?>
    
    init(torrentHash: String, delugionService: DelugionServicing) {
        
        self.torrentFiles = delugionService.torrentFiles(hash: torrentHash)
            .map {
                switch $0 {
                case .error(_):
                    return nil
                case .valid(let contents):
                    return contents.printFiles()
                }
            }.asDriver(onErrorJustReturn: nil)
        
    }
    
}

extension TorrentContent {
    
    func printFiles() -> [String] {
        
        var result = [String]()
        
        self.contents.forEach { (key, value) in
            if value.type == "file" {
                result.append(key)
            }
            else {
                result.append(contentsOf: printFiles(inDir: value))
            }
        }
        
        return result
        
    }
    
    func printFiles(inDir dir: TorrentFile) -> [String] {
        
        var result = [String]()
        
        dir.contents?.forEach { (key, value) in
            if value.type == "file" {
                result.append(key)
            }
            else {
                result.append(contentsOf: printFiles(inDir: value))
            }
        }
        
        return result
    }
    
}

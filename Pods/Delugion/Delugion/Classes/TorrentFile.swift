//
//  TorrentFile.swift
//  Pods
//
//  Created by Yotam Ohayon on 16/04/2017.
//
//

import Foundation
import Himotoki

public struct TorrentFile {
    
    public let priority: Int
    public let index: Int?
    public let offset: Int?
    public let path: String
    public let progress: Double
    public let size: Int
    public let type: String
    public let progresses: [Double]?
    public let contents: [String: TorrentFile]?
    
    public init(priority: Int,
                index: Int?,
                offset: Int?,
                path: String,
                progress: Double,
                size: Int,
                type: String,
                progresses: [Double]?,
                contents: [String: TorrentFile]?) {
        
        self.priority = priority
        self.index = index
        self.offset = offset
        self.path = path
        self.progress = progress
        self.size = size
        self.type = type
        self.progresses = progresses
        self.contents = contents
        
    }
    
}

extension TorrentFile: Himotoki.Decodable {
    
    /// - Throws: DecodeError or an arbitrary ErrorType
    public static func decode(_ e: Extractor) throws -> TorrentFile {
        return try TorrentFile(priority: e <| "priority",
                               index: e <|? "index",
                               offset: e <|? "offset",
                               path: e <| "path",
                               progress: e <| "progress",
                               size: e <| "size",
                               type: e <| "type",
                               progresses: e <||? "progresses",
                               contents: e <|-|? "contents")
    }
    
}

//
//  TorrentContents.swift
//  Pods
//
//  Created by Yotam Ohayon on 16/04/2017.
//
//

import Foundation
import Himotoki

public struct TorrentContent {
    
    public let contents: [String: TorrentFile]
    
    public init(contents: [String: TorrentFile]) {
        self.contents = contents
    }
    
}

extension TorrentContent: Himotoki.Decodable {
    
    /// - Throws: DecodeError or an arbitrary ErrorType
    public static func decode(_ e: Extractor) throws -> TorrentContent {
        return try TorrentContent(contents: e <|-| "contents")
    }
    
}

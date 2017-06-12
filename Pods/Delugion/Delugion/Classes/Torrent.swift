//
//  Torrent.swift
//  Pods
//
//  Created by Yotam Ohayon on 23/11/2016.
//
//

import UIKit

public protocol TorrentProtocol {
    
    var torrentHash: String { get }
    var downloadPayloadrate: Double { get }
    var uploadPayloadrate: Double { get }
    var eta : Double { get }
    var name: String { get }
    var progress: Double { get }
    var ratio: Double { get }
    var state: TorrentState { get }
    var totalDone: Double { get }
    var totalSize: Double { get }
    var totalUploaded: Double { get }
    var queue: Double { get }
    
}

public class Torrent: TorrentProtocol {
    
    public let torrentHash: String
    public let downloadPayloadrate: Double
    public let uploadPayloadrate: Double
    public let eta : Double
    public let name: String
    public let progress: Double
    public let ratio: Double
    public let state: TorrentState
    public let totalDone: Double
    public let totalSize: Double
    public let totalUploaded: Double
    public let queue: Double
    
    init?(hash: String, dict: [String: Any]) {
        
        guard let downloadPayloadrate = dict["download_payload_rate"] as? Double,
            let uploadPayloadrate = dict["upload_payload_rate"] as? Double,
            let eta = dict["eta"] as? Double,
            let name = dict["name"] as? String,
            let progress = dict["progress"] as? Double,
            let ratio = dict["ratio"] as? Double,
            let stateString = dict["state"] as? String,
            let state = TorrentState(rawValue: stateString),
            let totalDone = dict["total_done"] as? Double,
            let totalSize = dict["total_size"] as? Double,
            let totalUploaded = dict["total_uploaded"] as? Double,
            let queue = dict["queue"] as? Double else {
            return nil
        }
        
        self.torrentHash = hash
        self.downloadPayloadrate = downloadPayloadrate
        self.uploadPayloadrate = uploadPayloadrate
        self.eta = eta
        self.name = name
        self.progress = progress
        self.ratio = ratio
        self.state = state
        self.totalDone = totalDone
        self.totalSize = totalSize
        self.totalUploaded = totalUploaded
        self.queue = queue
        
    }

}

extension Torrent: CustomStringConvertible {
    
    public var description: String {
        return self.name
    }

}

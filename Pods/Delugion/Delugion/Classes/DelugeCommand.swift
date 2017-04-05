//
//  Command.swift
//  Pods
//
//  Created by Yotam Ohayon on 25/12/2016.
//
//

import Foundation

enum Method: String {
    // auth
    case checkSession = "auth.check_session"
    case login = "auth.login"
    // web
    case connected = "web.connected"
    case getHosts = "web.get_hosts"
    case getHostStatus = "web.get_host_status"
    case connect = "web.connect"
    case updateUI = "web.update_ui"
    case torrentStatus = "web.get_torrent_status"
    case torrentFiles = "web.get_torrent_files"
    case getMagnetInfo = "web.get_magnet_info"
    case addTorrents = "web.add_torrents"
    // core
    case remove = "core.remove_torrent"
    case resume = "core.resume_torrent"
    case pause = "core.pause_torrent"
}

protocol DelugeCommand {
    
    var params: [Any] { get }
    var method: Method { get }
    var id: Int { get }
    var asDictionary: [String: Any] { get }
    
}

extension DelugeCommand {
    
    var asDictionary: [String: Any] {
        
        return ["params": self.params, "method": self.method.rawValue, "id": String(self.id)]
        
    }
    
}

struct Command: DelugeCommand {
    
    internal var id: Int
    internal var method: Method
    internal var params: [Any]
    
 }

//
//  Host.swift
//  Delugion
//
//  Created by Yotam Ohayon on 16/10/2017.
//

import Foundation
import Himotoki

public struct Host {
    
    public let hash: String
    public let hostname: String
    public let port: Int
    public let status: String
    public let version: String?
    
    init?(params: [Any]) {
        
        guard let hash = params[0] as? String,
            let hostname = params[1] as? String,
            let port = params[2] as? Int,
            let status = params[3] as? String else {
            return nil
        }
        
        self.hash = hash
        self.hostname = hostname
        self.port = port
        self.status = status
        
        if params.count == 5, let version = params[4] as? String {
            self.version = version
        } else {
            self.version = nil
        }
        
    }
    
}

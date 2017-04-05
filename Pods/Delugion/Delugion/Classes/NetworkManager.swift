//
//  NetworkManager.swift
//  Pods
//
//  Created by Yotam Ohayon on 16/12/2016.
//
//

import Foundation
import Alamofire

protocol SendsRequests {
    
    var timeoutIntervalForRequest: TimeInterval { get set }
    func sendRequest(command: DelugeCommand,
                     completion: @escaping ([String: Any]?) -> Swift.Void)
    
}

class NetworkManager: SendsRequests {
    
    private let serverUrl: URL
    private let manager = Alamofire.SessionManager.default
    
    var timeoutIntervalForRequest: TimeInterval {
        get { return manager.session.configuration.timeoutIntervalForRequest }
        set { manager.session.configuration.timeoutIntervalForRequest = newValue }
    }
    
    init(url: URL) {
        self.serverUrl = url
    }
    
    func sendRequest(command: DelugeCommand,
                     completion: @escaping ([String: Any]?) -> Swift.Void) {
        
        self.manager.request(serverUrl,
                             method: .post,
                             parameters: command.asDictionary,
                             encoding: JSONEncoding(options: []),
                             headers: nil).responseJSON
            {
                response in
                let JSON = response.result.value as? [String: Any]
                completion(JSON)    
            }
        
    }
    
}

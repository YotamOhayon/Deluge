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
    
    func sendRequest(command: DelugeCommand,
                     completion: @escaping ([String: Any]?) -> Swift.Void)
    
}

class NetworkManager: SendsRequests {
    
    private let serverUrl: URL
    
    init(url: URL) {
        self.serverUrl = url
    }
    
    func sendRequest(command: DelugeCommand,
                     completion: @escaping ([String: Any]?) -> Swift.Void) {
        
        Alamofire.request(serverUrl,
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

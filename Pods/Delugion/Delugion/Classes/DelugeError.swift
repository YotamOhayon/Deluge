//
//  DelugeError.swift
//  Pods
//
//  Created by Yotam Ohayon on 08/04/2017.
//
//

import Foundation

public enum DelugeError: Error {
    
    case invalidHostOrPort
    case invalidJson
    case general([String: Any])
    
}

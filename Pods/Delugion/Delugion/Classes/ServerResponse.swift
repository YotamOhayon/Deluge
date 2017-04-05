//
//  ServerResponse.swift
//  Pods
//
//  Created by Yotam Ohayon on 08/04/2017.
//
//

import Foundation

public enum ServerResponse<T> {
    
    case error(DelugeError)
    case valid(T)
    
    public var associatedValue: Any {
        switch self {
        case .valid(let t):
            return t
        case .error(let error):
            return error
        }
    }
    
}

extension ServerResponse: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .valid(let t):
            return "valid: \(t)"
        case .error(let error):
            return "error: \(error)"
        }
    }

}

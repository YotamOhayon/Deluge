//
//  Optional+Exntension.swift
//  Deluge
//
//  Created by Yotam Ohayon on 14/05/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    
    var hasCharacters: Bool {
        switch self {
        case .none:
            return false
        case .some(let wrapped):
            return wrapped.count > 0
        }
    }
    
    var isEmpty: Bool {
        switch self {
        case .none:
            return true
        case .some(let wrapped):
            return wrapped.isEmpty
        }
    }
    
    var isNotEmpty: Bool {
        switch self {
        case .none:
            return false
        case .some(let wrapped):
            return wrapped.isNotEmpty
        }
    }
    
}

infix operator ?=
extension Optional where Wrapped: Comparable {
    
    static func ?= (left: inout Optional, right: Optional) {
        if left != right {
            left = right
        }
    }
}

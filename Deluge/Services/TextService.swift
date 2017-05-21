//
//  TextService.swift
//  Deluge
//
//  Created by Yotam Ohayon on 20/05/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation

protocol TextManaging {
    var noCredentials: String { get }
    var notConnectedToServer: String { get }
    var filterByTitle: String { get }
    var all: String { get }
    var sortByTitle: String { get }
    var showAll: String { get }
    var cancel: String { get }
    var error: String { get }
    var paused: String { get }
    var completed: String { get }
}

class TextManager: TextManaging {
    
    var noCredentials: String {
        return NSLocalizedString("noCredentials", comment: "")
    }
    
    var notConnectedToServer: String {
        return NSLocalizedString("notConnectedToServer", comment: "")
    }
    
    var filterByTitle: String {
        return NSLocalizedString("filterBy", comment: "")
    }
    
    var all: String {
        return NSLocalizedString("all", comment: "")
    }
    
    var sortByTitle: String {
        return NSLocalizedString("sortBy", comment: "")
    }
    
    var showAll: String {
        return NSLocalizedString("showAll", comment: "")
    }
    
    var cancel: String {
        return NSLocalizedString("cancel", comment: "")
    }
    
    var error: String {
        return NSLocalizedString("error", comment: "")
    }
    
    var paused: String {
        return NSLocalizedString("paused", comment: "")
    }
    
    var completed: String {
        return NSLocalizedString("completed", comment: "")
    }
    
}

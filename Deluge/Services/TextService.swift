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
}

class TextManager: TextManaging {
    
    var noCredentials: String {
        return "You have not set up credentials"
    }
    
    var notConnectedToServer: String {
        return "Not Connected To Server"
    }
    
    var filterByTitle: String {
        return "Filter By"
    }
    
    var all: String {
        return "All"
    }
    
    var sortByTitle: String {
        return "Sort By"
    }
    
    var showAll: String {
        return "Show all"
    }
    
    var cancel: String {
        return "Cancel"
    }
    
}

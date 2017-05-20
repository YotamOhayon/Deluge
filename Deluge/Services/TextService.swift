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
}

class TextManager: TextManaging {
    
    let noCredentials: String
    let notConnectedToServer: String
    let filterByTitle: String
    let all: String
    let sortByTitle: String
    
    init() {
        self.noCredentials = "You have not set up credentials"
        self.notConnectedToServer = "Not Connected To Server"
        self.filterByTitle = "Filter By"
        self.all = "All"
        self.sortByTitle = "Sort By"
    }
    
}

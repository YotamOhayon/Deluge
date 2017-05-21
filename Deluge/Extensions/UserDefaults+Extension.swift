//
//  UserDefaults+Extension.swift
//  Deluge
//
//  Created by Yotam Ohayon on 21/05/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func set(_ array: [FilePresentation], forKey key: String) {
        let newArray = NSArray(array: array)
        let data = NSKeyedArchiver.archivedData(withRootObject: newArray)
        self.setValue(data, forKey: key)
        self.synchronize()
    }
    
    func torrentArray(forKey key: String) -> [FilePresentation]? {
        
        guard let data = self.object(forKey: key) as? Data,
            let array = NSKeyedUnarchiver.unarchiveObject(with: data) as? [FilePresentation] else {
                return nil
        }
        
        return array
        
    }
    
}

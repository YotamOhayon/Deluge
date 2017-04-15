//
//  TorrentFilesTableViewController.swift
//  Deluge
//
//  Created by Yotam Ohayon on 15/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit

class TorrentFilesTableViewController: UIViewController {
    
    let dataSource = ["yotam", "ohayon", "gil", "ram"]

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self

    }

}

extension TorrentFilesTableViewController: UITableViewDataSource {
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier",
                                                 for: indexPath)
        
        cell.textLabel?.text = self.dataSource[indexPath.row]
        
        return cell
    }
    
}

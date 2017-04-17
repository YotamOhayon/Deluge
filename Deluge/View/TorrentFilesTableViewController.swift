//
//  TorrentFilesTableViewController.swift
//  Deluge
//
//  Created by Yotam Ohayon on 15/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TorrentFilesTableViewController: UIViewController {
    
    var viewModel: TorrentFilesViewModeling!
    var dataSource = [String]()
    let disposeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        viewModel.torrentFiles.drive(onNext: {
            self.dataSource = $0 ?? [String]()
            self.tableView.reloadData()
        }).disposed(by: disposeBag)

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

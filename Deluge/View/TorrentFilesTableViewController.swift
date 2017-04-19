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
    var torrentFilesDisposable: Disposable!
    var dataSource: [FilePresentation]? = [FilePresentation]()
    let disposeBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.torrentFilesDisposable = viewModel.torrentFiles.drive(onNext: {
            self.dataSource = $0
            self.tableView.reloadData()
        })
        self.torrentFilesDisposable.disposed(by: disposeBag)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.torrentFilesDisposable.dispose()
    }

}

extension TorrentFilesTableViewController: UITableViewDataSource {
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileNameCell",
                                                 for: indexPath) as! FileNameTableViewCell
        
        let filePresentation = self.dataSource![indexPath.row]
        cell.titleLabel.text = filePresentation.fileName
        
        let constant = CGFloat(integerLiteral: 10 * filePresentation.level)
        cell.titleLabel.leadingAnchor.constraint(equalTo: cell.iconImageView.trailingAnchor,
                                                 constant: constant).isActive = true
        
        cell.iconImageView.image = filePresentation.isDir ? #imageLiteral(resourceName: "folder") : nil
        
        return cell
    }
    
}

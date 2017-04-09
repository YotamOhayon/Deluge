//
//  MainViewController.swift
//  Deluge
//
//  Created by Yotam Ohayon on 06/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Delugion

class MainViewController: UIViewController {
    
    var viewModel: MainViewModeling!
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    fileprivate var dataSource = [Torrent]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.viewModel.torrents.subscribe(onNext: { [unowned self] in
            self.dataSource = $0
        }).disposed(by: self.disposeBag)
        
    }
    
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let torrent = self.dataSource[indexPath.row]
        switch torrent.state {
        case .downloading:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadingCell") as! DownloadingTableViewCell
            cell.viewModel = DownloadingCellViewModel(torrent: torrent)
            return cell
        case .paused:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PausedCell") as! PausedTableViewCell
            cell.viewModel = PausedCellViewModel(torrent: torrent)
            return cell
        case .error:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ErrorCell") as! ErrorTableViewCell
            cell.viewModel = ErrorCellViewModel(torrent: torrent)
            return cell
        case .seeding:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedCell") as! CompletedTableViewCell
            cell.viewModel = CompletedCellViewModel(torrent: torrent)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = self.dataSource[indexPath.row].name
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 89.0
    }
    
}

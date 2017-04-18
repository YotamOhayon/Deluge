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
    var torrentsDisposable: Disposable!
    
    let disposeBag = DisposeBag()
    fileprivate var dataSource = [TorrentProtocol]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        self.torrentsDisposable = self.viewModel.torrents.drive(onNext: { [unowned self] in
            // TODO: bring back after having one cell for all
//            if self.shouldReloadData(current: self.dataSource, new: $0) {
                self.dataSource = $0
//            }
        })
        self.torrentsDisposable.disposed(by: self.disposeBag)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.torrentsDisposable.dispose()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowTorrentSegue" {
            let torrent = sender as! Torrent
            let vc = segue.destination as! TorrentViewController
            vc.viewModel = self.viewModel.viewModel(forTorrent: torrent)
        }
        
    }
    
//    func shouldReloadData(current: [TorrentProtocol],
//                          new: [TorrentProtocol]) -> Bool {
//        
//        let currentHashes = current.map { return $0.torrentHash }
//        let newHashes = new.map { return $0.torrentHash }
//        
//        let notInNew = currentHashes.filter { !newHashes.contains($0) }
//        let notInCurrent = newHashes.filter { !currentHashes.contains($0) }
//        
//        return notInNew.isNotEmpty || notInCurrent.isNotEmpty
//        
//    }
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowTorrentSegue",
                          sender: self.dataSource[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 89.0
    }
    
}

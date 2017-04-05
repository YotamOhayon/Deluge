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
import RxDataSources
import Delugion
import SwipeCellKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var themeManager: ThemeServicing!
    var textManager: TextManaging!
    var viewModel: MainViewModeling!

    private var dataSource: RxTableViewSectionedReloadDataSource<SectionOfTorrents>!
    
    private lazy var noServerView: NoServerView = { [unowned self] in
        let noServer = NoServerView(frame: CGRect.zero)
        noServer.translatesAutoresizingMaskIntoConstraints = false
        noServer.buttonBlock = { [weak self] in
            self?.tabBarController?.selectedIndex = 1
        }
        noServer.isHidden = true
        self.view.addSubview(noServer)
        noServer.strech(toView: self.view)
        return noServer
    }()
    
    private lazy var connectionFailedView: ConnectionFailedView = { [unowned self] in
        let connectionFailedView = ConnectionFailedView(frame: CGRect.zero)
        connectionFailedView.translatesAutoresizingMaskIntoConstraints = false
        connectionFailedView.buttonBlock = { /*[weak self] in */
            //                        self?.tabBarController?.selectedIndex = 2
        }
        connectionFailedView.isHidden = true
        self.view.addSubview(connectionFailedView)
        connectionFailedView.strech(toView: self.view)
        return connectionFailedView
    }()
    
    private lazy var noTorrentsView: NoTorrentsView = { [unowned self] in
        let noTorrentsView = NoTorrentsView(frame: CGRect.zero)
        noTorrentsView.translatesAutoresizingMaskIntoConstraints = false
        noTorrentsView.isHidden = true
        self.view.addSubview(noTorrentsView)
        noTorrentsView.strech(toView: self.view)
        return noTorrentsView
    }()
    
    private lazy var spinnerView: UIActivityIndicatorView = { [unowned self] in
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        spinner.activityIndicatorViewStyle = .gray
        return spinner
    }()
    
    private lazy var connecionManagerView: ConnectionManagerView = {
        let cmView = ConnectionManagerView()
        cmView.translatesAutoresizingMaskIntoConstraints = false
        cmView.isHidden = true
        self.view.addSubview(cmView)
        cmView
            .centerXAnchor
            .constraint(equalTo: self.view.centerXAnchor)
            .isActive = true
        cmView
            .centerYAnchor
            .constraint(equalTo: self.view.centerYAnchor)
            .isActive = true
        cmView.buttonTapped
            .bind(to: self.viewModel.selectedHost)
            .disposed(by: self.disposeBag)
        return cmView
    }()
    
    private lazy var noInternetView: NotReachableView = { [unowned self] in
        let view = NotReachableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        self.view.addSubview(view)
        if #available(iOS 11.0, *) {
            view.topAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
                .isActive = true
            view.leadingAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
                .isActive = true
            view.trailingAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
                .isActive = true
        } else {
            view.leadingAnchor
                .constraint(equalTo: self.view.leadingAnchor)
                .isActive = true
            view.trailingAnchor
                .constraint(equalTo: self.view.trailingAnchor)
                .isActive = true
            view.topAnchor
                .constraint(equalTo: self.topLayoutGuide.topAnchor)
                .isActive = true
        }
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return view
    }()
    
    private func alert(forTorrent torrent: TorrentProtocol) -> UIAlertController {
        
       let alert = UIAlertController(title: "Delete", message: "Are you sure", preferredStyle: .actionSheet)
        
        let withData = UIAlertAction(title: "with data",
                                   style: .destructive)
        { [weak self] _ in
            self?.viewModel.removeTorrent.onNext((torrent.torrentHash, true))
        }
        alert.addAction(withData)
        
        let withoutData = UIAlertAction(title: "without data",
                                        style: .default)
        { [weak self] _ in
            self?.viewModel.removeTorrent.onNext((torrent.torrentHash, false))
        }
        alert.addAction(withoutData)
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        return alert
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        
        self.dataSource = RxTableViewSectionedReloadDataSource<SectionOfTorrents>(configureCell: { [unowned self] (dataSource, tableView, indexPath, torrent) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "TorrentCell", for: indexPath) as! TorrentTableViewCell
            cell.textManager = self.textManager
            cell.viewModel = TorrentCellViewModel(torrent: torrent,
                                                  theme: self.themeManager.torrentCell)
            cell.delegate = self
            return cell
        })
        
        dataSource.titleForHeaderInSection = { ds, index in
            return nil
        }
        
        viewModel
            .isReachable
            .asDriver(onErrorJustReturn: false)
            .drive(self.noInternetView.rx.isHidden)
            .disposed(by: disposeBag)
        
        self.viewModel
            .isMissingCredentials
            .map { !$0 }
            .drive(self.noServerView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel
            .hosts
            .drive(self.connecionManagerView.rx.model)
            .disposed(by: self.disposeBag)
        
        viewModel
            .shouldShowConnectionManager
            .map { !$0 }
            .drive(self.connecionManagerView.rx.isHidden)
            .disposed(by: disposeBag)
        
        self.viewModel
            .isConnected
            .drive(self.connectionFailedView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel
            .torrents
            .drive(self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        self.viewModel
            .noTorrents
            .map { !$0 }
            .drive(self.noTorrentsView.rx.isHidden)
            .disposed(by: disposeBag)
        
        self.viewModel
            .showActivitySpinnder
            .drive(self.spinnerView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        self.viewModel
            .titleView
            .drive(self.navigationItem.rx.titleView)
            .disposed(by: disposeBag)
        
        self.tableView
            .rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let section = self?.dataSource[indexPath.section] else {
                    return
                }
                let torrent = section.items[indexPath.row]
                
                self?.performSegue(withIdentifier: "ShowTorrentSegue",
                                   sender: torrent)
            })
            .disposed(by: disposeBag)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowTorrentSegue" {
            let torrent = sender as! Torrent
            let vc = segue.destination as! TorrentViewController
            vc.viewModel = self.viewModel.viewModel(forTorrent: torrent)
        }
        
    }
    
    fileprivate func torrent(at indexPath:IndexPath) -> TorrentProtocol {
        let torrents = self.dataSource[indexPath.section]
        return torrents.items[indexPath.row]
    }
    
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
}

extension MainViewController: SwipeTableViewCellDelegate {
    
    private var deleteAction: SwipeAction {
        let deleteAction = SwipeAction(style: .destructive, title: "Delete")
        { [weak self] action, indexPath in
            guard let strongSelf = self else { return }
            let torrent = strongSelf.torrent(at: indexPath)
            let alert = strongSelf.alert(forTorrent: torrent)
            strongSelf.present(alert, animated: true    , completion: nil)
        }
        
        deleteAction.image = #imageLiteral(resourceName: "Trash")
        deleteAction.backgroundColor = UIColor(red: 255.0,
                                               green: 59.0,
                                               blue: 48.0)
        return deleteAction
    }
    
    private var resumeAction: SwipeAction {
        let resumeAction = SwipeAction(style: .destructive, title: "Resume")
        { [weak self] action, indexPath in
            guard let strongSelf = self else { return }
            let torrent = strongSelf.torrent(at: indexPath)
            strongSelf.viewModel.resumeTorrent.onNext(torrent.torrentHash)
        }
        
        resumeAction.image = #imageLiteral(resourceName: "Resume")
        resumeAction.backgroundColor = UIColor(red: 255.0,
                                               green: 149.0,
                                               blue: 0.0)
        return resumeAction
    }
    
    private var pauseAction: SwipeAction {
        let pauseAction = SwipeAction(style: .destructive, title: "Pause")
        { [weak self] action, indexPath in
            guard let strongSelf = self else { return }
            let torrent = strongSelf.torrent(at: indexPath)
            strongSelf.viewModel.pauseTorrent.onNext(torrent.torrentHash)
        }
        
        pauseAction.image = #imageLiteral(resourceName: "Pause")
        pauseAction.backgroundColor = UIColor(red: 255.0,
                                              green: 149.0,
                                              blue: 0.0)
        return pauseAction
    }
    
    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath,
                   for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        let desired: SwipeActionsOrientation = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight ? .right : .left
        
        guard orientation == desired else { return nil }
        
        let torrent = self.torrent(at: indexPath)
        
        if torrent.state == .downloading {
            return [deleteAction, pauseAction]
        }
        else if torrent.state == .paused {
            return [deleteAction, resumeAction]
        }
        else {
            return [deleteAction]
        }
        
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) {
        viewModel.shouldUpdateTable.onNext(false)
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?, for orientation: SwipeActionsOrientation) {
        viewModel.shouldUpdateTable.onNext(true)
    }
    
}

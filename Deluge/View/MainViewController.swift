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
//    @IBOutlet weak var filterButton: UIBarButtonItem!
//    @IBOutlet weak var sortButton: UIBarButtonItem!
//    @IBOutlet weak var filterStatusLabel: UILabel!
    
    var themeManager: ThemeManaging!
    var textManager: TextManaging!
    var viewModel: MainViewModeling!
    private var errorMessage: UILabel!
    private var noInternetView: NotReachableView!
    private let disposeBag = DisposeBag()
    
    fileprivate let dataSource = RxTableViewSectionedReloadDataSource<SectionOfTorrents>()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        
        dataSource.configureCell = { [unowned self] (dataSource, tableView, indexPath, torrent) in

            let cell = tableView.dequeueReusableCell(withIdentifier: "TorrentCell", for: indexPath) as! TorrentTableViewCell
            cell.textManager = self.textManager
            cell.viewModel = TorrentCellViewModel(torrent: torrent, themeManager: self.themeManager)
            cell.delegate = self
            return cell
        }
        
        dataSource.titleForHeaderInSection = { ds, index in
            return nil
        }
        
        viewModel.torrents
            .asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
//        self.filterButton
//            .rx
//            .tap
//            .bind(to: viewModel.filterButtonTapped)
//            .disposed(by: self.disposeBag)
//        
//        self.sortButton
//            .rx
//            .tap
//            .bind(to: viewModel.sortButtonTapped)
//            .disposed(by: disposeBag)
//        
//        self.viewModel
//            .filterStatus
//            .asObservable()
//            .bind(to: self.filterStatusLabel.rx.text)
//            .disposed(by: disposeBag)
        
//        self.viewModel
//            .showFilterAlertController
//            .asObservable()
//            .subscribe(onNext: {
//                
//                guard let message = $0,
//                    let actions = $1,
//                    let block = $2,
//                    let allBlock = $3,
//                    let allTitle = $4,
//                    let cancelTitle = $5 else {
//                        return
//                }
//                
//                let alert = UIAlertController(title: nil,
//                                              message: message,
//                                              preferredStyle: .actionSheet)
//                
//                actions.forEach { action in
//                    let filterAction = UIAlertAction(title: action.rawValue,
//                                                     style: .default) { _ in
//                                                        block(action)
//                    }
//                    alert.addAction(filterAction)
//                }
//                
//                let allAction = UIAlertAction(title: allTitle,
//                                              style: .default)
//                { _ in
//                    allBlock()
//                }
//                alert.addAction(allAction)
//                
//                let cancelAction = UIAlertAction(title: cancelTitle,
//                                                 style: .cancel,
//                                                 handler: nil)
//                alert.addAction(cancelAction)
//                
//                self.present(alert, animated: true, completion: nil)
//                
//            }).disposed(by: disposeBag)
//        
//        viewModel.showSortAlertController.asObservable().subscribe(onNext: {
//            
//            guard let message = $0,
//                let actions = $1,
//                let block = $2 else {
//                    return
//            }
//            
//            let alert = UIAlertController(title: nil,
//                                          message: message,
//                                          preferredStyle: .actionSheet)
//            
//            actions.forEach { action in
//                let filterAction = UIAlertAction(title: action.description,
//                                                 style: .default)
//                { _ in
//                    block(action)
//                }
//                alert.addAction(filterAction)
//            }
//            
//            let cancelAction = UIAlertAction(title: "Cancel",
//                                             style: .cancel,
//                                             handler: nil)
//            alert.addAction(cancelAction)
//            
//            self.present(alert, animated: true, completion: nil)
//            
//        }).disposed(by: disposeBag)
        
        self.noInternetView = { [unowned self] in
            
            let view = NotReachableView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.isHidden = true
            self.view.addSubview(view)
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            view.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
            view.heightAnchor.constraint(equalToConstant: 30).isActive = true
            return view
            
        }()
        
        self.errorMessage = { [unowned self] in
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.isHidden = true
            label.text = nil
            self.view.addSubview(label)
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            return label
            }()
        
        viewModel.isReachable.subscribe(onNext: { [weak self] in
            self?.noInternetView.isHidden = $0
        }).disposed(by: disposeBag)
        
        viewModel.showError.drive(onNext: { [weak self] in
            guard let `self` = self else { return }
            self.tableView.isHidden = $0 != nil
            self.errorMessage.text = $0
            self.errorMessage.isHidden = $0 == nil
        }).disposed(by: disposeBag)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowTorrentSegue" {
            let torrent = sender as! Torrent
            let vc = segue.destination as! TorrentViewController
            vc.viewModel = self.viewModel.viewModel(forTorrent: torrent)
        }
        
    }
    
    @IBAction func unwindToMainViewController(segue: UIStoryboardSegue) {
        
        guard let s = Segue(segue: segue) else {
            return
        }
        
        switch s {
        case .settingsCancel:
            print("cancel")
        case .settingsDone:
            print("done")
        }
        
    }
    
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = self.dataSource[indexPath.section]
        let torrent = section.items[indexPath.row]
        
        self.performSegue(withIdentifier: "ShowTorrentSegue",
                          sender: torrent)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
}

extension MainViewController: SwipeTableViewCellDelegate {
    
    private var deleteAction: SwipeAction {
        let deleteAction = SwipeAction(style: .destructive, title: "Delete")
        { /*[weak self]*/ action, indexPath in
//            guard let `self` = self else { return }
            print("delete")
            //            self.log.debug("delete button tapped")
            //            self.viewModel.removeItemTapped.onNext(indexPath.row)
        }
        
        deleteAction.image = #imageLiteral(resourceName: "Trash")
        deleteAction.backgroundColor = UIColor(red: 255.0,
                                               green: 59.0,
                                               blue: 48.0)
        return deleteAction
    }
    
    private var resumeAction: SwipeAction {
        let resumeAction = SwipeAction(style: .destructive, title: "Resume")
        { /*[weak self]*/ action, indexPath in
//            guard let `self` = self else { return }
            print("resume")
            //            self.log.debug("delete button tapped")
            //            self.viewModel.removeItemTapped.onNext(indexPath.row)
        }
        
        resumeAction.image = #imageLiteral(resourceName: "Resume")
        resumeAction.backgroundColor = UIColor(red: 255.0,
                                               green: 149.0,
                                               blue: 0.0)
        return resumeAction
    }
    
    private var pauseAction: SwipeAction {
        let pauseAction = SwipeAction(style: .destructive, title: "Pause")
        { /*[weak self]*/ action, indexPath in
//            guard let `self` = self else { return }
            print("pause")
            //            self.log.debug("delete button tapped")
            //            self.viewModel.removeItemTapped.onNext(indexPath.row)
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
        
//        if self.dataSource[indexPath.row].state == .downloading {
//            return [deleteAction, pauseAction]
//        }
//        else if self.dataSource[indexPath.row].state == .paused {
//            return [deleteAction, resumeAction]
//        }
//        else {
            return [deleteAction]
//        }
        
    }
    
}

//
//  TorrentViewModel.swift
//  Deluge
//
//  Created by Yotam Ohayon on 09/04/2017.
//  Copyright © 2017 Yotam Ohayon. All rights reserved.
//

import Foundation
import Delugion
import RxCocoa
import RxSwift
import RxOptional
import UIKit

protocol TorrentModeling {
    
    var title: String? { get }
    var subtitle: Driver<UIView> { get }
    var downloadSpeed: Driver<String?> { get }
    var torrentFilesViewModel: TorrentFilesViewModeling { get }
    var progressColor: Driver<UIColor> { get }
    var progressNumeric: Driver<Double?> { get }
    var progressAngle: Driver<Double?> { get }
    var didRemoveTorrent: Observable<Bool> { get }
    var showDeleteConfirmation: Observable<(String, String, String, String)> { get }
    var didRemoveTorrentTapped: PublishSubject<Void> { get }
    var didResumeTorrentTapped: PublishSubject<Void> { get }
    var didPauseTorrentTapped: PublishSubject<Void> { get }
    var didPauseTorrent: Observable<Void> { get }
    var didResumeTorrent: Observable<Void> { get }
    var barButtonItems: Driver<UIBarButtonSystemItem> { get }
    
    func removeTorrent(withData shouldRemoveData: Bool)
    
}

class TorrentModel: TorrentModeling {
    
    let title: String?
    let subtitle: Driver<UIView>
    let downloadSpeed: Driver<String?>
    let progressColor: Driver<UIColor>
    let progressNumeric: Driver<Double?>
    let progressAngle: Driver<Double?>
    let didRemoveTorrentSubject = PublishSubject<Bool>()
    var didRemoveTorrent: Observable<Bool> {
        return self.didRemoveTorrentSubject.asObservable()
    }
    
    let showDeleteConfirmation: Observable<(String, String, String, String)>
    let didRemoveTorrentTapped = PublishSubject<Void>()
    let didResumeTorrentTapped = PublishSubject<Void>()
    let didPauseTorrentTapped = PublishSubject<Void>()
    
    let didPauseTorrentSubject = PublishSubject<Void>()
    var didPauseTorrent: Observable<Void> {
        return self.didPauseTorrentSubject.asObservable()
    }
    let didResumeTorrentSubject = PublishSubject<Void>()
    var didResumeTorrent: Observable<Void> {
        return self.didResumeTorrentSubject.asObservable()
    }
    let barButtonItems: Driver<UIBarButtonSystemItem>
    
    fileprivate let torrent: TorrentProtocol
    fileprivate let delugion: DelugionServicing
    fileprivate let disposeBag = DisposeBag()
    
    init(torrent: TorrentProtocol, delugionService: DelugionServicing, themeManager: ThemeManaging) {
        
        self.torrent = torrent
        self.delugion = delugionService
        
        self.title = torrent.name
        
        let info = delugionService.torrentInfo(hash: torrent.torrentHash)
            .filter {
                switch $0 {
                case .valid(_):
                    return true
                default:
                    return false
                }
            }.map {
                return $0.associatedValue as! Torrent
        }
        
        self.subtitle = info.map { torrent in
            return torrent.subtitle
        }.asDriver(onErrorJustReturn: UIView()).startWith(torrent.subtitle)
        
        self.barButtonItems = info
            .map { $0.state }
            .distinctUntilChanged()
            .map { state -> UIBarButtonSystemItem in
                return TorrentFilesViewModel.button(forState: state)
        }.asDriver(onErrorJustReturn: UIBarButtonSystemItem.fixedSpace)
            .startWith(TorrentFilesViewModel.button(forState: torrent.state))
        
        self.downloadSpeed = info.map { String(describing: $0.downloadPayloadrate) }.asDriver(onErrorJustReturn: nil)
        
        self.progressColor = info.map { themeManager.color(forTorrentState: $0.state) }
            .asDriver(onErrorJustReturn: .gray)
            .startWith(themeManager.color(forTorrentState: torrent.state))
        
        self.progressNumeric = info.map { $0.progress }
            .asDriver(onErrorJustReturn: nil)
            .startWith(torrent.progress)
        
        self.progressAngle = info.map { $0.progress * 3.6 }
            .asDriver(onErrorJustReturn: nil)
            .startWith(torrent.progress * 3.6)
        
        self.showDeleteConfirmation = didRemoveTorrentTapped.map {
            return ("are you sure", "with data", "without data", "no")
        }
        
        self.didResumeTorrentTapped.withLatestFrom(info) {
            $1
            }.subscribe(onNext: { [unowned self] in
                
                guard $0.state == .paused else {
                    return
                }
                self.delugion.resumeTorrent(hash: $0.torrentHash) {
                    self.didResumeTorrentSubject.onNext()
                }
                
            }).disposed(by: disposeBag)
        
        self.didPauseTorrentTapped.withLatestFrom(info) {
            $1
            }.subscribe(onNext: { [unowned self] in
                
                guard $0.state == .downloading else {
                    return
                }
                self.delugion.pauseTorrent(hash: $0.torrentHash) {
                    self.didPauseTorrentSubject.onNext()
                }
                
            }).disposed(by: disposeBag)
        
    }
    
    var torrentFilesViewModel: TorrentFilesViewModeling {
        return TorrentFilesViewModel(torrentHash: self.torrent.torrentHash, delugionService: self.delugion)
    }
    
    func removeTorrent(withData shouldRemoveData: Bool) {
        self.delugion.removeTorrent(hash: self.torrent.torrentHash,
                                    withData: shouldRemoveData)
        {
            switch $0 {
            case .valid:
                self.didRemoveTorrentSubject.onNext(true)
            case .error:
                self.didRemoveTorrentSubject.onNext(false)
            }
        }
    }
    
}

fileprivate extension TorrentFilesViewModel {
    
    class func button(forState state: TorrentState) -> UIBarButtonSystemItem {
        switch state {
        case .downloading:
            return UIBarButtonSystemItem.pause
        case .paused:
            return UIBarButtonSystemItem.play
        default:
            return UIBarButtonSystemItem.fixedSpace
        }
    }
    
}

fileprivate extension TorrentProtocol {
    
    var subtitle: UIView {
        
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        switch self.state {
        case .downloading:
            let downloadLabel = UILabel()
            downloadLabel.translatesAutoresizingMaskIntoConstraints = false
            var (speed, unit) = self.downloadPayloadrate.inUnits(withPrecision: 1)
            downloadLabel.text = "\(speed) \(unit.stringifiedAsSpeed)"
            container.addSubview(downloadLabel)
            downloadLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
            downloadLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
            let circleSeparator = CircleSeparator()
            container.addSubview(circleSeparator)
            circleSeparator.leadingAnchor.constraint(equalTo: downloadLabel.trailingAnchor, constant: 8).isActive = true
            circleSeparator.centerYAnchor.constraint(equalTo: downloadLabel.centerYAnchor).isActive = true
            let uploadLabel = UILabel()
            uploadLabel.translatesAutoresizingMaskIntoConstraints = false
            (speed, unit) = self.uploadPayloadrate.inUnits(withPrecision: 1)
            uploadLabel.text = "\(speed) \(unit.stringifiedAsSpeed)"
            container.addSubview(uploadLabel)
            uploadLabel.leadingAnchor.constraint(equalTo: circleSeparator.trailingAnchor, constant: 8.0).isActive = true
            uploadLabel.lastBaselineAnchor.constraint(equalTo: downloadLabel.lastBaselineAnchor).isActive = true
            container.addSubview(circleSeparator)
        case .error:
            let label = UILabel()
            label.text = "Error"
            label.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(label)
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        case .paused:
            let label = UILabel()
            label.text = "Paused"
            label.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(label)
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        case .seeding:
            let label = UILabel()
            label.text = "Seeding"
            label.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(label)
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
            let circleSeparator = CircleSeparator()
            container.addSubview(circleSeparator)
            circleSeparator.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8).isActive = true
            circleSeparator.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
            let uploadLabel = UILabel()
            uploadLabel.translatesAutoresizingMaskIntoConstraints = false
            let (speed, unit) = self.uploadPayloadrate.inUnits(withPrecision: 1)
            uploadLabel.text = "\(speed) \(unit.stringifiedAsSpeed)"
            container.addSubview(uploadLabel)
            uploadLabel.leadingAnchor.constraint(equalTo: circleSeparator.trailingAnchor, constant: 8.0).isActive = true
            uploadLabel.lastBaselineAnchor.constraint(equalTo: label.lastBaselineAnchor).isActive = true
            container.addSubview(circleSeparator)
        default:
            let label = UILabel()
            label.text = "To do"
            label.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(label)
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        }
        
        return container
        
    }
    
}

class CircleSeparator: UIView {
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 5).isActive = true
        self.heightAnchor.constraint(equalToConstant: 5).isActive = true
        self.makeLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.makeLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.makeLayout()
    }
    
    func makeLayout() {
        self.backgroundColor = .lightGray
        self.layer.cornerRadius = 2.5
    }
    
}

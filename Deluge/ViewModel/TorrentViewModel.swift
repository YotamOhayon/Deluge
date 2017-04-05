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

protocol TorrentViewModeling {
    
    var title: String? { get }
    var subtitle: Driver<String?> { get }
    var subtitleColor: Driver<UIColor> { get }
    var torrent: Driver<TorrentProtocol> { get }
    var topButton: Driver<UIButton> { get }
    var removeTorrentButton: Driver<UIButton?> { get }
    var didRemoveTorrent: Driver<Bool> { get }
    
}

class TorrentViewModel: TorrentViewModeling {
    
    let title: String?
    let subtitle: Driver<String?>
    let subtitleColor: Driver<UIColor>
    let torrent: Driver<TorrentProtocol>
    let topButton: Driver<UIButton>
    let removeTorrentButton: Driver<UIButton?>
    let didRemoveTorrent: Driver<Bool>
    
    private let resumeSubject = PublishSubject<Void>()
    private let delugion: DelugionServicing
    private let disposeBag = DisposeBag()
    private let pauseSubject = PublishSubject<Void>()
    private let deleteSubject = PublishSubject<Void>()
    
    init(torrent: TorrentProtocol,
         delugionService: DelugionServicing,
         theme: TorrentDetailsTheme,
         textManager: TextManaging) {
        
        self.delugion = delugionService
        
        self.title = torrent.name
        
        let info = delugionService.torrentInfo(hash: torrent.torrentHash)
        
        self.torrent = info
            .startWith(torrent)
            .asDriver(onErrorDriveWith: Driver.never())
        
        let subtitle: Observable<String?> = info
            .map { subtitleText(forTorrent: $0) }
            .startWith(subtitleText(forTorrent: torrent))
        
        self.subtitle = subtitle
            .asDriver(onErrorJustReturn: nil)
        
        let subtitleColor: Observable<UIColor> = info
            .map {
                theme.subtitleColor(forTorrentState: $0.state)
            }
            .startWith(theme.subtitleColor(forTorrentState: torrent.state))
        
        self.subtitleColor = subtitleColor
            .asDriver(onErrorDriveWith: Driver.never())
        
        let pauseButton = button(forState: TorrentState.downloading, theme: theme)
        pauseButton
            .rx
            .tap
            .flatMap { delugionService.pauseTorrent(hash: torrent.torrentHash) }
            .bind(to: pauseSubject)
            .disposed(by: disposeBag)
        
        let resumeButton = button(forState: TorrentState.paused, theme: theme)
        resumeButton
            .rx
            .tap
            .flatMap { delugionService.resumeTorrent(hash: torrent.torrentHash) }
            .bind(to: resumeSubject)
            .disposed(by: disposeBag)
        
        let deleteButton = UIButton()
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(theme.redButton, for: .normal)
        deleteButton.backgroundColor = theme.buttonBackground
        deleteButton.rx
            .tap
            .bind(to: self.deleteSubject)
            .disposed(by: self.disposeBag)
        
        let didDeleteSubject = PublishSubject<Bool>()
        deleteSubject.flatMap {
            alertObservable()
            }
            .flatMap {
                delugionService.removeTorrent(hash: torrent.torrentHash, withData: $0)
            }
            .bind(to: didDeleteSubject)
            .disposed(by: self.disposeBag)
        self.didRemoveTorrent = didDeleteSubject.asDriver(onErrorJustReturn: false)
        
        let topButtonForState: (TorrentState) -> UIButton = { state in
            switch state {
            case .downloading:
                return pauseButton
            case .paused:
                return resumeButton
            default:
                return deleteButton
            }
        }
        
        let topButton: Observable<UIButton> = info
            .map { $0.state }
            .distinctUntilChanged()
            .map(topButtonForState)
            .startWith(topButtonForState(torrent.state))
        self.topButton = topButton.asDriver(onErrorDriveWith: Driver.never())
        
        let secondButtonForButton: (UIButton) -> UIButton? = { button in
            if button == pauseButton || button == resumeButton {
                return deleteButton
            } else {
                return nil
            }
        }
        
        let secondButton = topButton.map(secondButtonForButton)
        self.removeTorrentButton = secondButton.asDriver(onErrorJustReturn: nil)
        
    }
    
}

func subtitleText(forTorrent torrent: TorrentProtocol) -> String {
    
    switch torrent.state {
    case .downloading:
        let (speed, unit) = torrent.downloadPayloadrate.inUnits(withPrecision: 1)
        var subtitle = "\(speed) \(unit.stringifiedAsSpeed)"
        if let eta = (torrent.eta > 0) ? torrent.eta.asHMS : nil {
            subtitle += ", \(eta)"
        }
        return subtitle
    default: return torrent.state.rawValue
    }
    
}

private func button(forState state: TorrentState, theme: TorrentDetailsTheme) -> UIButton {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    let title = buttonTitle(forState: state)
    button.setTitle(title, for: .normal)
    let color = buttonTitleColor(forState: state, theme: theme)
    button.setTitleColor(color, for: .normal)
    button.backgroundColor = theme.buttonBackground
    return button
}

private func buttonTitle(forState state: TorrentState) -> String {
    switch state {
    case .downloading:
        return "Puase"
    case .paused:
        return "Resume"
    default:
        return "Delete"
    }
}

private func buttonTitleColor(forState state: TorrentState, theme: TorrentDetailsTheme) -> UIColor {
    switch state {
    case .downloading, .paused:
        return theme.blueButton
    default:
        return theme.redButton
    }
}

private func alertObservable() -> Observable<Bool> {
    
    guard let delegate = UIApplication.shared.delegate as? AppDelegate,
        let vc = delegate.window?.rootViewController else {
            return Observable.just(false)
    }
    
    return Observable<Bool>.create { observer in
        
        let alert = UIAlertController(title: "Delete", message: "Are you sure", preferredStyle: .actionSheet)
        
        let withData = UIAlertAction(title: "with data",
                                     style: .destructive)
        { _ in
            observer.onNext(true)
            observer.onCompleted()
        }
        alert.addAction(withData)
        
        let withoutData = UIAlertAction(title: "without data",
                                        style: .default)
        { _ in
            observer.onNext(false)
            observer.onCompleted()
        }
        alert.addAction(withoutData)
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        { _ in
            observer.onCompleted()
        }
        alert.addAction(cancel)
        
        vc.present(alert, animated: true, completion: nil)
        
        return Disposables.create()
        
    }
    
}

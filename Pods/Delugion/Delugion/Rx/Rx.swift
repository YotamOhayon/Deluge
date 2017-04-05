//
//  Rx.swift
//  Delugion
//
//  Created by Yotam Ohayon on 16/10/2017.
//

import Foundation
import RxSwift

extension Delugion: ReactiveCompatible {}
public extension Reactive where Base: Delugion {
    
    public var checkSession: Observable<Bool> {
        return Observable<Bool>.create { observer in
            self.base.checkSession { response in
                switch response {
                case .error(let e):
                    observer.onError(e)
                case .valid(let v):
                    observer.onNext(v)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    public func login(withPassword password: String) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            self.base.login(withPassword: password) { response in
                switch response {
                case .error(let e):
                    observer.onError(e)
                case .valid(let v):
                    observer.onNext(v)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    public var connected: Observable<Bool> {
        return Observable<Bool>.create { observer in
            self.base.connected { response in
                switch response {
                case .error(let e):
                    observer.onError(e)
                case .valid(let v):
                    observer.onNext(v)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    public func getHosts() -> Observable<[Host]> {
        return Observable<[Host]>.create { observer in
            self.base.getHosts { response in
                switch response {
                case .error(let e):
                    observer.onError(e)
                case .valid(let v):
                    observer.onNext(v)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    public func getHostStatus(hash: String) -> Observable<Host> {
        return Observable<Host>.create { observer in
            self.base.getHostStatus(hash: hash) { response in
                switch response {
                case .error(let e):
                    observer.onError(e)
                case .valid(let v):
                    observer.onNext(v)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }

    public func connect(hash: String) -> Observable<Void> {
        return Observable<Void>.create { observer in
            self.base.connect(hash: hash) { response in
                switch response {
                case .error(let e):
                    observer.onError(e)
                case .valid(let v):
                    observer.onNext(v)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }


    public func updateUI(filterByState state: TorrentState?) -> Observable<[TorrentProtocol]> {
        return Observable<[TorrentProtocol]>.create { observer in
            self.base.updateUI(filterByState: state) { response in
                switch response {
                case .error(let e):
                    observer.onError(e)
                case .valid(let v):
                    observer.onNext(v)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }

    public func getTorrentStatus(hash: String) -> Observable<TorrentProtocol> {
        return Observable<TorrentProtocol>.create { observer in
            self.base.getTorrentStatus(hash: hash) { response in
                switch response {
                case .error(let e):
                    observer.onError(e)
                case .valid(let v):
                    observer.onNext(v)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }

    public func getTorrentFiles(hash: String) -> Observable<TorrentContent> {
        return Observable<TorrentContent>.create { observer in
            self.base.getTorrentFiles(hash: hash) { response in
                switch response {
                case .error(let e):
                    observer.onError(e)
                case .valid(let v):
                    observer.onNext(v)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }

    public func getMagnetInfo(url: URL) -> Observable<MagnetInfo> {
        return Observable<MagnetInfo>.create { observer in
            self.base.getMagnetInfo(url: url) { response in
                switch response {
                case .error(let e):
                    observer.onError(e)
                case .valid(let v):
                    observer.onNext(v)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    public func addTorrents(url: URL) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            self.base.addTorrents(url: url) { response in
                switch response {
                case .error(let e):
                    observer.onError(e)
                case .valid(let v):
                    observer.onNext(v)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    public func remove(hash: String,
                       withData shouldRemoveData: Bool) -> Observable<Bool> {
        return Observable<Bool>.create { observer in
            self.base.remove(hash: hash, withData: shouldRemoveData) { response in
                switch response {
                case .error(let e):
                    observer.onError(e)
                case .valid(let v):
                    observer.onNext(v)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    public func resume(hash: String) -> Observable<Void> {
        return Observable<Void>.create { observer in
            self.base.resume(hash: hash) { response in
                switch response {
                case .error(let e):
                    observer.onError(e)
                case .valid(let v):
                    observer.onNext(v)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }

    public func pause(hash: String) -> Observable<Void> {
        return Observable<Void>.create { observer in
            self.base.pause(hash: hash) { response in
                switch response {
                case .error(let e):
                    observer.onError(e)
                case .valid(let v):
                    observer.onNext(v)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
}


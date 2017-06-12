//
//  Delugion.swift
//  Pods
//
//  Created by Yotam Ohayon on 25/12/2016.
//
//

public protocol DelugionService {
    
    func connect(withPassword password:String, completion: @escaping (ServerResponse<Void>) -> Void)
    
    func info(filterByState state: TorrentState?,
              completion: @escaping (ServerResponse<[TorrentProtocol]>) -> Void)
    
    func info(hash: String, completion: @escaping (ServerResponse<TorrentProtocol>) -> Void)
    
    func getTorrentFiles(hash: String, completion: @escaping (ServerResponse<TorrentContent>) -> Void)
    
    func pasue(hash: String, completion: @escaping () -> Void)
    
    func resume(hash: String, completion: @escaping () -> Void)
    
    func remove(hash: String, withData: Bool, completion: @escaping (ServerResponse<Void>) -> Void)
    
    func add(url: URL)
    
    func getMagnetInfo(url: URL, completion: @escaping (ServerResponse<MagnetInfo>) -> Void)
    
}

public class Delugion {
    
    fileprivate var id = 0
    fileprivate let networkManager: SendsRequests
    
    init(networkManager: SendsRequests) {
        
        self.networkManager = networkManager
        
    }
    
    public convenience init(hostname: String, port: Int) throws {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = hostname
        urlComponents.port = port
        urlComponents.path = "/json"
        
        guard let url = urlComponents.url else {
            throw DelugeError.invalidHostOrPort
        }
        
        let networkManager = NetworkManager(url: url)
        self.init(networkManager: networkManager)
        
    }
    
}

extension Delugion: DelugionService {
    
    public func connect(withPassword password:String,
                        completion: @escaping (ServerResponse<Void>) -> Void) {
        
        let command = Command(id: self.requestId(),
                              method: .login,
                              params: [password])
        
        self.networkManager.sendRequest(command: command)
        { JSON in
            
            guard let JSON = JSON,
                let result = JSON["result"] as? Bool else {
                completion(.error(.invalidJson))
                return
            }
            
            if let _ = JSON["error"] as? [String: Any] {
                completion(.error(.invalidJson))
                return
            }
            
            guard result else {
                completion(.error(.general))
                return
            }
            
            completion(.valid())
            
        }
        
    }
    
    public func info(filterByState state: TorrentState?,
                     completion: @escaping (ServerResponse<[TorrentProtocol]>) -> Void) {
        
        let fields: [String] = ["queue", "name", "total_size", "state", "progress", "num_seeds", "total_seeds", "num_peers", "total_peers", "download_payload_rate", "upload_payload_rate", "eta", "ratio", "distributed_copies", "is_auto_managed", "time_added", "tracker_host", "save_path", "total_done", "total_uploaded", "max_download_speed", "max_upload_speed", "seeds_peers_ratio"]
        
        let filter = { () -> [String : String] in
            if let state = state {
                return ["state": state.rawValue]
            }
            else {
                return [String: String]()
            }
        }()
        
        let params: [Any] = [fields, filter]
        
        let command = Command(id: self.requestId(),
                              method: .updateUI,
                              params: params)
        
        self.networkManager.sendRequest(command: command)
        { JSON in
            guard let JSON = JSON else {
                completion(.error(.invalidJson))
                return
            }
            
            if let error = JSON["error"] as? [String: Any] {
                if error["message"] as? String == "Not authenticated" {
                    completion(.error(.notAuthenticated))
                }
                else {
                    completion(.error(.general))
                }
                return
            }
            
            guard let result = JSON["result"] as? [String: Any] else {
                completion(.error(.invalidJson))
                return
            }

            guard let torrentsInfo = result["torrents"] as? [String: [String: Any]] else {
                return
            }
            
            var torrents = [Torrent]()
            
            torrentsInfo.forEach { (hash, value) in
                if let torrent = Torrent(hash: hash, dict: value) {
                    torrents.append(torrent)
                }
            }
            
            completion(.valid(torrents))
            return
            
        }
        
    }
    
    public func info(hash: String,
                     completion: @escaping (ServerResponse<TorrentProtocol>) -> Void) {
        
        let params: [Any] = [hash, ["total_done", "total_payload_download", "total_uploaded", "total_payload_upload", "next_announce", "tracker_status", "num_pieces", "piece_length", "is_auto_managed", "active_time", "seeding_time", "seed_rank", "queue", "name", "total_size", "state", "progress", "num_seeds", "total_seeds", "num_peers", "total_peers", "download_payload_rate", "upload_payload_rate", "eta", "ratio", "distributed_copies", "is_auto_managed", "time_added", "tracker_host", "save_path", "total_done", "total_uploaded", "max_download_speed", "max_upload_speed", "seeds_peers_ratio"]]
        
        let command = Command(id: self.requestId(),
                              method: .torrentStatus,
                              params: params)
        
        self.networkManager.sendRequest(command: command)
        { JSON in
            
            guard let JSON = JSON else {
                completion(.error(.invalidJson))
                return
            }
            
//            guard let response = Response<Torrent>(withDict: JSON) else {
//                completion(.error(.invalidJson))
//                return
//            }
            
            guard let result = JSON["result"] as? [String: Any] else {
                completion(.error(.invalidJson))
                return
            }
            
            guard let torrent = Torrent(hash: hash, dict: result) else {
                completion(.error(.invalidJson))
                return
            }
            
            completion(.valid(torrent))
            
        }
        
    }
    
    public func remove(hash: String, withData shouldRemoveData: Bool, completion: @escaping (ServerResponse<Void>) -> Void) {
        
        let command = Command(id: self.requestId(),
                              method: .remove,
                              params: [hash, shouldRemoveData])
        
        self.networkManager.sendRequest(command: command)
        { JSON in
            guard let JSON = JSON else {
                return
            }
            
            if let _ = JSON["error"] as? [String: Any] {
                completion(.error(.general))
                return
            }
            
            guard JSON["result"] as? Bool == true else {
                completion(.error(.general))
                return
            }
            
            completion(.valid())
            
        }
        
    }
    
    public func resume(hash: String, completion: @escaping () -> Void) {
        
        let command = Command(id: self.requestId(),
                              method: .resume,
                              params: [[hash]])
        
        self.networkManager.sendRequest(command: command)
        { JSON in
            guard let _ = JSON else {
                return
            }
            
            completion()
            
        }
        
    }
    
    public func pasue(hash: String, completion: @escaping () -> Void) {
        
        let command = Command(id: self.requestId(),
                              method: .pause,
                              params: [[hash]])
        
        self.networkManager.sendRequest(command: command)
        { JSON in
            guard let _ = JSON else {
                return
            }
            
            completion()
            
        }
        
    }
    
        public func getMagnetInfo(url: URL, completion: @escaping (ServerResponse<MagnetInfo>) -> Void) {
    
            let command = Command(id: self.requestId(),
                                  method: .getMagnetInfo,
                                  params: [url.absoluteString])
    
            self.networkManager.sendRequest(command: command)
            { JSON in
    
                guard let JSON = JSON,
                    let result = JSON["result"] as? [String: Any],
                    let name = result["name"] as? String,
                    let infoHash = result["info_hash"] as? String else {
                    completion(.error(.general))
                    return
                }
    
                let magnetInfo = MagnetInfo(name: name, infoHash: infoHash, magnetUrl: url)
                completion(.valid(magnetInfo))
    
            }
    
        }
    
    public func getTorrentFiles(hash: String,
                                completion: @escaping (ServerResponse<TorrentContent>) -> Void) {
        
        let command = Command(id: self.requestId(),
                              method: .torrentFiles,
                              params: [hash])
        
        self.networkManager.sendRequest(command: command)
        { JSON in
            
            guard let JSON = JSON else {
                completion(.error(.invalidJson))
                return
            }
            
            guard let result = JSON["result"] as? [String: Any] else {
                completion(.error(.invalidJson))
                return
            }
            
            guard let contents = try? TorrentContent.decodeValue(result) else {
                completion(.error(.invalidJson))
                return
            }
            
            completion(.valid(contents))
            
        }
        
    }
    
        public func add(url: URL) {
    
            let options: [String: Any] = [
                "file_priorities": [],
                "add_paused": false,
                "compact_allocation": false,
                /*"download_location": "/home/yotam/Downloads",*/
                "move_completed": false,
                /*"move_completed_path": "/home/yotam/Downloads",*/
                "max_connections": -1,
                "max_download_speed": -1,
                "max_upload_slots": -1,
                "max_upload_speed": -1,
                "prioritize_first_last_pieces": false
            ]
    
            let optionsAndPath: [String: Any] = [
                "path": url.absoluteString,
                "options": options
            ]
    
            let arr: [Any] = [[optionsAndPath]]
    
            let command = Command(id: self.requestId(),
                                  method: .addTorrent,
                                  params: arr)
    
            self.networkManager.sendRequest(command: command)
            { JSON in
                guard let _ = JSON else {
                    return
                }
    
    
            }
    
        }
    
}

fileprivate extension Delugion {
    
    func requestId() -> Int {
        let ret = id
        id += 1
        return ret
    }
    
    func createURL(fromHost host: String, port: Int) -> URL? {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = host
        urlComponents.port = Int(port)
        urlComponents.path = "/json"
        return urlComponents.url
        
    }
    
}

//struct Response<T> {
//    
//    let id: String
//    let result: T
//    let error: ResponseError?
//    
//    init?(withDict dict: [String: Any]?) {
//        
//        guard let dict = dict,
//            let id = dict["id"] as? String,
//            let result = dict["result"] as? [String: Any]/*,
//            let error = dict["error"] as? [String: Any] */else {
//            return nil
//        }
//        
//        guard let obj = { () -> T? in
//            
//            switch "\(T.self)" {
//            case "Torrent":
//                return Torrent(hash: "12", dict: result) as? T
//            default:
//                return nil
//            }
//            
//            }() else {
//                return nil
//        }
//        
//        self.id = id
//        self.result = obj
//        self.error = nil //ResponseError(withDict: error)
//        
//    }
//    
//    func genericName() -> String {
//        return "\(T.self)"
//    }
//    
//}
//
//struct ResponseError {
//    
//    let message: String
//    let code: Int
//    
//    init?(withDict dict: [String: Any]) {
//        
//        guard let message = dict["message"] as? String,
//            let code = dict["code"] as? Int else {
//                return nil
//        }
//        
//        self.message = message
//        self.code = code
//        
//    }
//    
//}

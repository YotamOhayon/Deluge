//
//  Delugion.swift
//  Pods
//
//  Created by Yotam Ohayon on 25/12/2016.
//
//

public protocol DelugionService {
    
    var hostname: String { get }
    var port: Int { get }
    
    // auth
    
    func checkSession(completion: @escaping (ServerResponse<Bool>) -> Void)
    
    func login(withPassword password:String,
               completion: @escaping (ServerResponse<Bool>) -> Void)
    
    // web
    
    func connected(completion: @escaping (ServerResponse<Bool>) -> Void)
    
    func getHosts(completion: @escaping (ServerResponse<[Host]>) -> Void)
    
    func getHostStatus(hash: String,
                       completion: @escaping (ServerResponse<Host>) -> Void)
    
    func connect(hash: String,
                 completion: @escaping (ServerResponse<Void>) -> Void)
    
    func updateUI(filterByState state: TorrentState?,
                  completion: @escaping (ServerResponse<[TorrentProtocol]>) -> Void)
    
    func getTorrentStatus(hash: String,
                          completion: @escaping (ServerResponse<TorrentProtocol>) -> Void)
    
    func getTorrentFiles(hash: String,
                         completion: @escaping (ServerResponse<TorrentContent>) -> Void)
    
    func getMagnetInfo(url: URL,
                       completion: @escaping (ServerResponse<MagnetInfo>) -> Void)
    
    func addTorrents(url: URL,
                     completion: @escaping (ServerResponse<Bool>) -> Void)
    
    // core
    
    func remove(hash: String,
                withData: Bool,
                completion: @escaping (ServerResponse<Bool>) -> Void)
    
    func resume(hash: String, completion: @escaping (ServerResponse<Void>) -> Void)
    
    func pause(hash: String, completion: @escaping (ServerResponse<Void>) -> Void)
    
}

public class Delugion {
    
    fileprivate var id = 0
    fileprivate var networkManager: SendsRequests
    
    public var hostname: String
    public var port: Int
    
    init(networkManager: SendsRequests, hostname: String, port: Int) {
        self.networkManager = networkManager
        self.hostname = hostname
        self.port = port
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
        self.init(networkManager: networkManager, hostname: hostname, port: port)
        
    }
    
}

extension Delugion: DelugionService {
    
    // auth
    
    public func checkSession(completion: @escaping (ServerResponse<Bool>) -> Void) {
        
        let command = Command(id: self.requestId(),
                              method: .checkSession,
                              params: [])
        
        self.networkManager.sendRequest(command: command)
        { JSON in
            foo(JSON: JSON, completion: completion)
        }
        
    }
    
    public func login(withPassword password:String,
                      completion: @escaping (ServerResponse<Bool>) -> Void) {
        
        let command = Command(id: self.requestId(),
                              method: .login,
                              params: [password])
        
        self.networkManager.sendRequest(command: command)
        { JSON in
            foo(JSON: JSON, completion: completion)
        }
        
    }
    
    // web
    
    public func connected(completion: @escaping (ServerResponse<Bool>) -> Void) {
        
        let params = [Any]()
        
        let command = Command(id: self.requestId(),
                              method: .connected,
                              params: params)
        
        self.networkManager.sendRequest(command: command)
        { JSON in
            foo(JSON: JSON, completion: completion)
        }
        
    }
    
    public func getHosts(completion: @escaping (ServerResponse<[Host]>) -> Void) {
        
        let params = [Any]()
        
        let command = Command(id: self.requestId(),
                              method: .getHosts,
                              params: params)
        
        self.networkManager.sendRequest(command: command)
        { JSON in
            
            guard let JSON = JSON,
                let rawResult = JSON["result"] as? [[Any]] else {
                    completion(.error(.invalidJson))
                    return
            }
            
            if let error = JSON["error"] as? [String: Any] {
                completion(.error(.general(error)))
                return
            }
            
            let result = rawResult.flatMap { Host(params: $0) }
            
            completion(ServerResponse.valid(result))
            
        }
        
    }
    
    public func getHostStatus(hash: String,
                              completion: @escaping (ServerResponse<Host>) -> Void) {
        
        let params = [Any]()
        
        let command = Command(id: self.requestId(),
                              method: .getHostStatus,
                              params: params)
        
        self.networkManager.sendRequest(command: command)
        { JSON in
            
            guard let JSON = JSON,
                let rawResult = JSON["result"] as? [Any],
                let result = Host(params: rawResult) else {
                    completion(.error(.invalidJson))
                    return
            }
            
            if let error = JSON["error"] as? [String: Any] {
                completion(.error(.general(error)))
                return
            }
            
            completion(ServerResponse.valid(result))
            
        }
        
    }
    
    public func connect(hash: String,
                        completion: @escaping (ServerResponse<Void>) -> Void) {
        
        let command = Command(id: self.requestId(),
                              method: .connect,
                              params: [hash])
        
        self.networkManager.sendRequest(command: command)
        { JSON in
            
            guard let JSON = JSON else {
                    completion(.error(.invalidJson))
                    return
            }
            
            if let error = JSON["error"] as? [String: Any] {
                completion(.error(.general(error)))
                return
            }
            
            completion(ServerResponse.valid(()))
            
        }
        
    }
    
    public func updateUI(filterByState state: TorrentState?,
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
                completion(.error(.general(error)))
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
    
    public func getTorrentStatus(hash: String,
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
                    completion(.error(.invalidJson))
                    return
            }
            
            let magnetInfo = MagnetInfo(name: name, infoHash: infoHash, magnetUrl: url)
            completion(.valid(magnetInfo))
            
        }
        
    }
    
    
    
    public func addTorrents(url: URL,
                            completion: @escaping (ServerResponse<Bool>) -> Void) {
        
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
                              method: .addTorrents,
                              params: arr)
        
        self.networkManager.sendRequest(command: command)
        { JSON in
            foo(JSON: JSON, completion: completion)
        }
        
    }
    
    // core
    
    public func remove(hash: String,
                       withData shouldRemoveData: Bool,
                       completion: @escaping (ServerResponse<Bool>) -> Void) {
        
        let command = Command(id: self.requestId(),
                              method: .remove,
                              params: [hash, shouldRemoveData])
        
        self.networkManager.sendRequest(command: command)
        { JSON in
            foo(JSON: JSON, completion: completion)
        }
        
    }
    
    public func resume(hash: String, completion: @escaping (ServerResponse<Void>) -> Void) {
        
        let command = Command(id: self.requestId(),
                              method: .resume,
                              params: [[hash]])
        
        self.networkManager.sendRequest(command: command)
        { JSON in
            foo(JSON: JSON, completion: completion)
        }
        
    }
    
    public func pause(hash: String, completion: @escaping (ServerResponse<Void>) -> Void) {
        
        let command = Command(id: self.requestId(),
                              method: .pause,
                              params: [[hash]])
        
        self.networkManager.sendRequest(command: command)
        { JSON in
            foo(JSON: JSON, completion: completion)
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

func foo<T>(JSON: [String: Any]?, completion: (ServerResponse<T>) -> Void) {
    
    guard let JSON = JSON,
        let result = JSON["result"] as? T else {
            completion(.error(.invalidJson))
            return
    }
    
    if let error = JSON["error"] as? [String: Any] {
        completion(.error(.general(error)))
        return
    }
    
    completion(ServerResponse.valid(result))
    
}

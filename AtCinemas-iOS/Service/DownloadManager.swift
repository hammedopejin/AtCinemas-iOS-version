//
//  DownloadManager.swift
//  AtCinemas-iOS
//
//  Created by Hammed opejin on 6/9/19.
//  Copyright © 2019 Hammed opejin. All rights reserved.
//

import Foundation

typealias DataHandler = (Data?) -> Void

let downloadManager = DownloadManager.shared

final class DownloadManager {
    
    static let shared = DownloadManager()
    private init() {}
    
    lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 20
        return URLSession(configuration: config)
    }()
    
    let cache = NSCache<NSString, NSData>()
    
    func download(_ url: String, completion: @escaping DataHandler) {
        
        if let data = cache.object(forKey: url as NSString){
        completion(data as Data)
        return
        }
        
        guard let finalURL = URL(string: url) else {
            completion(nil)
            return
        }
        
        session.dataTask(with: finalURL) { [unowned self] (dat, _, err) in
            
            if let error = err {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            
            if let data = dat {
                
                self.cache.setObject(data as NSData, forKey: url as NSString)
                
                DispatchQueue.main.async {
                    completion(data)
                }
            }
            
        }.resume()
    }
    
}

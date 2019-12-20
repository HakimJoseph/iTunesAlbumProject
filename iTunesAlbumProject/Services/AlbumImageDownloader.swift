//
//  AlbumImageDownloader.swift
//  iTunesAlbumProject
//
//  Created by AbdullahFamily on 12/13/19.
//  Copyright © 2019 HakimJoseph. All rights reserved.
//

import UIKit

class AlbumImageDownloader {
    static let shared = AlbumImageDownloader()
    let imageRequestQueue = OperationQueue()
    //Downloader is a Singleton
    private init() {
        self.imageRequestQueue.maxConcurrentOperationCount = 100
    }
    
    func addImageDownload(operation albumOperation: AlbumDownloadOperation) {
        guard !imageRequestQueue.operations.contains(albumOperation) || ( imageRequestQueue.operations.contains(albumOperation) && albumOperation.isFinished) else {
            return
        }
        imageRequestQueue.addOperation(albumOperation)
    }
}

class AlbumDownloadOperation: Operation {
    private var session = URLSession(configuration: .default)
    var success: ((Data)->Void)?
    override var isConcurrent: Bool {
        return true
    }
    let url: URL
    init(url: URL) {
        self.url = url
    }

    override func start() {
        let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        session.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            guard let responseData = data, let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                return
            }
            self?.success?(responseData)
        }.resume()
    }
}

//
//  AlbumViewModel.swift
//  iTunesAlbumProject
//
//  Created by AbdullahFamily on 12/19/19.
//  Copyright © 2019 HakimJoseph. All rights reserved.
//

import UIKit

class AlbumViewModel {
    var albumCover = UIImage(named: "album_cell_placeholderImg")
    let title: String
    let artist: String
    let imageOperation: AlbumDownloadOperation
    let genres: [Genre]
    let releaseDate: String
    let copyright: String
    let albumPage: URL
    
    init(album:Album) {
        title = album.name
        artist = album.artist
        imageOperation = AlbumDownloadOperation(url: album.imageLink)
        genres = album.genres
        releaseDate = album.releaseDate
        copyright = album.copyright
        albumPage = album.albumPageLink
    }
    func downloadImage(success: @escaping (UIImage?) -> Void) {
        guard let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: imageOperation.url)) else {
            AlbumImageDownloader.shared.addImageDownload(operation: imageOperation)
            imageOperation.success = ({ [weak self] data in
                self?.albumCover = UIImage(data: data)
                success(self?.albumCover)
            })
            return
        }
        
        albumCover = UIImage(data: cachedResponse.data)
        success(albumCover)
    }
}

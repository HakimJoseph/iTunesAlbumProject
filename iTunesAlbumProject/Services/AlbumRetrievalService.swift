//
//  AlbumRetrievalService.swift
//  iTunesAlbumProject
//
//  Created by AbdullahFamily on 12/13/19.
//  Copyright © 2019 HakimJoseph. All rights reserved.
//

import UIKit

class AlbumRetrievalService {
    static let shared = AlbumRetrievalService()
    var albumViewModels = [AlbumViewModel]()
    //Service is a Singleton
    private init(){}
    
    func downloadAlbums(success: @escaping () -> Void, failure: @escaping () -> Void) {
        guard let url = URL(string: "https://rss.itunes.apple.com/api/v1/us/itunes-music/top-albums/all/100/explicit.json") else {
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let responseData = data, let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                failure()
                return
            }
            
            guard let decodedResults = try? JSONDecoder().decode(Feed.self, from: responseData) else {
                failure()
                return
            }
            self?.albumViewModels.removeAll()
            decodedResults.albums.forEach({ self?.albumViewModels.append(AlbumViewModel(album: $0))})
            success()
        }.resume()
    }
}

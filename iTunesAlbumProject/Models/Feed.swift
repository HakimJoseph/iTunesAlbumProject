//
//  Feed.swift
//  iTunesAlbumProject
//
//  Created by AbdullahFamily on 12/13/19.
//  Copyright © 2019 HakimJoseph. All rights reserved.
//
import Foundation

struct Feed: Decodable {
    let albums: [Album]
    private enum CodingKeys: String, CodingKey {
        case feed
    }
    private enum nestedCodingKeys: String, CodingKey {
        case albums = "results"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: nestedCodingKeys.self, forKey: .feed)
        albums = try nestedContainer.decode([Album].self, forKey: .albums)
    }
}

struct Album: Decodable {
    let name: String
    let imageLink: URL
    let albumPageLink: URL
    let artist: String
    let genres: [Genre]
    let releaseDate: String
    let copyright: String
    private enum CodingKeys: String, CodingKey {
        case artist = "artistName"
        case imageLink = "artworkUrl100"
        case albumPageLink = "url"
        case name, genres, releaseDate, copyright
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        artist = try container.decode(String.self, forKey: .artist)
        imageLink = try container.decode(URL.self, forKey: .imageLink)
        name = try container.decode(String.self, forKey: .name)
        genres = try container.decode([Genre].self, forKey: .genres)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
        copyright = try container.decode(String.self, forKey: .copyright)
        albumPageLink = try container.decode(URL.self, forKey: .albumPageLink)
    }
}

struct Genre: Decodable {
    let name: String
}

//
//  AlbumTableViewCell.swift
//  iTunesAlbumProject
//
//  Created by AbdullahFamily on 12/18/19.
//  Copyright © 2019 HakimJoseph. All rights reserved.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {
    static var resuseIdentifier: String {
        return String(describing: self)
    }
    public var albumImageView: UIImageView = UIImageView(frame: .zero)
    private var albumTitle: UILabel = UILabel(frame: .zero)
    private var albumArtist: UILabel = UILabel(frame: .zero)

    func configure(with viewModel: AlbumViewModel) {
        setupImageView(with: viewModel.albumCover)
        
        setup(label: albumTitle,
                   text: viewModel.title,
                   below: albumImageView)
        albumTitle.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        albumTitle.numberOfLines = 2
        
        setup(label: albumArtist,
                   text: viewModel.artist,
                   below: albumTitle)
        albumArtist.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
    }
    
    private func setupImageView(with image: UIImage?) {
        guard let albumImage = image else {
            return
        }
        addSubview(albumImageView)
        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        albumImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        albumImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        albumImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        albumImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        albumImageView.contentMode = .scaleAspectFit
        albumImageView.image = albumImage
    }
    
    private func setup(label: UILabel, text:String, below topView: UIView) {
        addSubview(label)
        label.text = text
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 8.0).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 8.0).isActive = true
        label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8.0).isActive = true
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
    }
}

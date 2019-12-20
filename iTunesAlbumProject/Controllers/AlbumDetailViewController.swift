//
//  AlbumDetailViewController.swift
//  iTunesAlbumProject
//
//  Created by AbdullahFamily on 12/18/19.
//  Copyright © 2019 HakimJoseph. All rights reserved.
//

import UIKit

class AlbumDetailViewController: UIViewController {
    private var albumViewModel: AlbumViewModel?
    private var imageView = UIImageView()
    private var stackView = UIStackView()
    private var scrollView = UIScrollView()
    private var albumPageButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAlbumPageButton()
        setupScrollView()
        setupViews(viewModel: albumViewModel)
    }

    
    private func setupAlbumPageButton () {
        albumPageButton.backgroundColor = .black
        albumPageButton.setTitle("iTunes Album Page", for: .normal)
        albumPageButton.setTitleColor(.white, for: .normal)
        albumPageButton.addTarget(self,
                                  action: #selector(didTapButton),
                                  for: .touchUpInside)
        
        self.view.addSubview(albumPageButton)
        albumPageButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.rightAnchor.constraint(equalTo: albumPageButton.rightAnchor, constant: 20).isActive = true
        albumPageButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: albumPageButton.bottomAnchor, constant: 20).isActive = true
        albumPageButton.layer.cornerRadius = 15.0
    }
    
    private func setupScrollView() {
        self.view.addSubview(self.scrollView)
        self.scrollView.contentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height*2.5)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.albumPageButton.topAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: 16.0).isActive = true
    }
    
    private func setupViews(viewModel: AlbumViewModel?) {
        guard let viewModel = viewModel else {
            self.displayErrorAlert()
            return
        }
        setupImageView(viewModel: viewModel)
        setupStackView()
        setupAlbumInfoLabels(viewModel: viewModel)
    }
    
    private func displayErrorAlert () {
        let alert = UIAlertController(title: "Album Loading Error",
                                      message: "We encounterd an error loading the details of this album. Please Try Again!",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    private func setupImageView(viewModel: AlbumViewModel) {
        viewModel.downloadImage {image in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
        imageView.contentMode = .scaleAspectFit
        self.scrollView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 8.0).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
    }
    
    private func setupStackView() {
        self.scrollView.addSubview(self.stackView)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.axis = .vertical
        self.stackView.distribution = .fill
        self.stackView.alignment = .center
        self.stackView.spacing = 8.0
        self.stackView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 8.0).isActive = true
        self.stackView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        self.scrollView.rightAnchor.constraint(equalTo: self.stackView.rightAnchor).isActive = true
        self.stackView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
    }
    
    private func setupAlbumInfoLabels(viewModel: AlbumViewModel) {
        self.stackView.addArrangedSubview(self.albumInfoLabel(title: viewModel.title, fontSize: 16.0, weight: .bold))
        
        self.stackView.addArrangedSubview(self.albumInfoHeaderLabel(title: "Artist"))
        self.stackView.addArrangedSubview(self.albumInfoLabel(title: viewModel.artist, fontSize: 12.0, weight: .medium))
        
        self.stackView.addArrangedSubview(self.albumInfoHeaderLabel(title: "Genre(s)"))
        self.stackView.addArrangedSubview(self.albumInfoLabel(title: viewModel.genres[1].name, fontSize: 12.0, weight: .medium))
        
        self.stackView.addArrangedSubview(self.albumInfoHeaderLabel(title: "Release Date"))
        self.stackView.addArrangedSubview(self.albumInfoLabel(title: viewModel.releaseDate, fontSize: 12.0, weight: .medium))
        
        self.stackView.addArrangedSubview(self.albumInfoHeaderLabel(title: "Copyright"))
        self.stackView.addArrangedSubview(self.albumInfoLabel(title: viewModel.copyright, fontSize: 12.0, weight: .medium))
    }
    
    private func albumInfoLabel(title: String, fontSize: CGFloat, weight: UIFont.Weight) -> UILabel {
        let subtitleLabel = UILabel(frame: .zero)
        subtitleLabel.text = title
        subtitleLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        subtitleLabel.numberOfLines = 0
        return subtitleLabel
    }
    
    private func albumInfoHeaderLabel(title: String) -> UILabel {
        let headerLabel = UILabel(frame: .zero)
        headerLabel.text = title
        headerLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .bold)
        return headerLabel
    }
    
    @objc func didTapButton() {
        guard let albumViewModel = albumViewModel else {
            return
        }
        UIApplication.shared.open(albumViewModel.albumPage)
    }

    static func detailViewController(viewModel: AlbumViewModel) -> AlbumDetailViewController {
        let detailController = AlbumDetailViewController()
        detailController.albumViewModel = viewModel
        return detailController
    }
}

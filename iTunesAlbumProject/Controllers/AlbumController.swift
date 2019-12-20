//
//  ViewController.swift
//  iTunesAlbumProject
//
//  Created by AbdullahFamily on 12/13/19.
//  Copyright © 2019 HakimJoseph. All rights reserved.
//

import UIKit

class AlbumController: UIViewController {
    private let albumTableView = UITableView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Apple Music Albums"
        self.view.backgroundColor = .white
        setupAlbumTable()
    }
    
    private func setupAlbumTable() {
        self.view.addSubview(albumTableView)
        albumTableView.register(AlbumTableViewCell.self, forCellReuseIdentifier: AlbumTableViewCell.resuseIdentifier)
        albumTableView.translatesAutoresizingMaskIntoConstraints = false
        albumTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        albumTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        albumTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        albumTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        albumTableView.delegate = self
        albumTableView.dataSource = self
        setupRefreshControl()
        retrieveAlbums()
    }
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl(frame: CGRect(x: 0, y: 0, width: 40.0, height: 40.0))
        refreshControl.addTarget(self, action: #selector(retrieveAlbums), for: .valueChanged)
        albumTableView.refreshControl = refreshControl
    }
    
    @objc func retrieveAlbums() {
        AlbumRetrievalService.shared.downloadAlbums(success: { [weak self] in
            DispatchQueue.main.async {
                self?.albumTableView.reloadData()
                self?.albumTableView.refreshControl?.endRefreshing()
            }
        }, failure: { [weak self] in
                self?.albumTableView.refreshControl?.endRefreshing()
        })
    }
}

extension AlbumController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlbumTableViewCell.resuseIdentifier, for: indexPath) as? AlbumTableViewCell ?? AlbumTableViewCell(style: .default, reuseIdentifier: AlbumTableViewCell.resuseIdentifier)
        cell.selectionStyle = .none
        let viewModel = AlbumRetrievalService.shared.albumViewModels[indexPath.row]
        cell.configure(with: viewModel)
        viewModel.downloadImage { image in
            DispatchQueue.main.async {
                cell.imageView?.image = image
            }
        }
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(AlbumDetailViewController.detailViewController(viewModel: AlbumRetrievalService.shared.albumViewModels[indexPath.row]), animated: false)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240.0
    }
}
extension AlbumController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlbumRetrievalService.shared.albumViewModels.count
    }
}

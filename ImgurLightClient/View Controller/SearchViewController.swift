//
//  SearchViewController.swift
//  ImgurLightClient
//
//  Created by Sasha Kozlov on 2/16/19.
//  Copyright © 2019 Sasha Kozlov. All rights reserved.
//

import SDWebImage
import UIKit

class SearchViewController: UICollectionViewController {
    private let showDetailSegue = "showDetail"
    private let networkService = NetworkService()
    private var imageInfosArray = [ImageInfo]()
    private var selectedImageInfo: ImageInfo?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showDetailSegue, let controller = segue.destination as? DetailsTableViewController {
            controller.imageInfo = selectedImageInfo
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchBar()
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageInfosArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ImageCell.self), for: indexPath) as! ImageCell

        let imageInfo = imageInfosArray[indexPath.row]
        configureCell(cell, info: imageInfo)

        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImageInfo = imageInfosArray[indexPath.row]
        performSegue(withIdentifier: showDetailSegue, sender: nil)
    }

    // MARK: Utils
    private func getSearchResults(_ query: String) {
        networkService.getSearchResults(for: query) { [weak self] imageInfos, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let imageInfos = imageInfos {
                self?.imageInfosArray = imageInfos
                DispatchQueue.main.async {
                    self?.collectionView?.reloadData()
                }
            }
        }
    }

    private func setupSearchBar() {
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
    }

    private func configureCell(_ cell: ImageCell, info: ImageInfo) {
        cell.imageView.sd_setImage(with: info.url, completed: nil)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            imageInfosArray = []
            collectionView.reloadData()
        } else {
            getSearchResults(searchText)
        }
    }
}

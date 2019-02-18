//
//  DetailsTableViewController.swift
//  ImgurLightClient
//
//  Created by Sasha Kozlov on 2/17/19.
//  Copyright © 2019 Sasha Kozlov. All rights reserved.
//

import SDWebImage
import UIKit

class DetailsTableViewController: UITableViewController {
    var comments = [Comment]()
    let networkService = NetworkService()
    var imageInfo: ImageInfo?

    override func viewDidLoad() {
        super.viewDidLoad()

        //to prevent showing empty cell at the bottom of the screen
        tableView.tableFooterView = UIView()

        setupImageHeader()
        getComments()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CommentCell.self), for: indexPath) as! CommentCell

        let comment = comments[indexPath.row]
        configureCell(cell, comment: comment)

        return cell
    }

    // MARK: - Utils
    private func configureCell(_ cell: CommentCell, comment: Comment) {
        cell.textLabel?.text = comment.author
        cell.detailTextLabel?.text = comment.text
    }

    private func setupImageHeader() {
        let headerHeight = view.bounds.height / 2
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: headerHeight))
        imageView.contentMode = .scaleAspectFit
        if let url = imageInfo?.url {
            imageView.sd_setImage(with: url, completed: nil)
        }
        tableView.tableHeaderView = imageView
    }

    private func getComments() {
        guard let imageId = imageInfo?.id else {
            assertionFailure("We must have image id to download comments")
            return
        }
        networkService.getComments(for: imageId) { [weak self] comments, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let comments = comments {
                self?.comments = comments
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }

}

//
//  ImageCell.swift
//  ImgurLightClient
//
//  Created by Sasha Kozlov on 2/14/19.
//  Copyright © 2019 Sasha Kozlov. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        imageView.layer.cornerRadius = 3.0
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
    }
}

//
//  CommentCell.swift
//  ImgurLightClient
//
//  Created by Sasha Kozlov on 2/17/19.
//  Copyright © 2019 Sasha Kozlov. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        textLabel?.textColor = UIColor(white: 0.1, alpha: 1.0)
        textLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        detailTextLabel?.textColor = UIColor(white: 0.3, alpha: 1.0)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        detailTextLabel?.numberOfLines = 0
        detailTextLabel?.sizeToFit()
    }

}

//
//  Comment.swift
//  ImgurLightClient
//
//  Created by Sasha Kozlov on 2/14/19.
//  Copyright © 2019 Sasha Kozlov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Comment {
    let author: String
    let text: String

    init(json: JSON) {
        author = json["author"].stringValue
        text = json["comment"].stringValue
    }
}

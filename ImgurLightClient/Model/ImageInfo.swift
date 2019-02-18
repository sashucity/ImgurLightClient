//
//  ImageInfo.swift
//  ImgurLightClient
//
//  Created by Sasha Kozlov on 2/14/19.
//  Copyright © 2019 Sasha Kozlov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ImageInfo {
    let id: String
    let urlString: String
    let type: String

    init(json: JSON) {
        id = json["id"].stringValue
        urlString = json["link"].stringValue
        type = json["type"].stringValue
    }

    var url: URL? {
        return URL(string: urlString)
    }
}

//
//  NetworkService.swift
//  ImgurLightClient
//
//  Created by Sasha Kozlov on 2/14/19.
//  Copyright © 2019 Sasha Kozlov. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias SearchResult = ([ImageInfo]?, Error?) -> ()
typealias GetCommentsResult = ([Comment]?, Error?) -> ()

private let baseUrl = "https://api.imgur.com/3"
private let clientId = "85b59b6dc586813"
private let clientSecret = "09cc5a729df26226f5e71d3845884e5f1a8bcdde"

enum Endpoint {
    case search(query: String, type: String)
    case comments(imageId: String)

    var path: String {
        switch self {
        case .search(let query, let type):
            let updatedQuery = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            return "/gallery/search/top/all?q=" + updatedQuery + "&q_type=\(type)"
        case .comments(let imageId):
            return "/gallery/" + imageId + "/comments"
        }
    }
}

enum JSONError: String, Error {
    case noData = "ERROR: no data"
    case conversionFailed = "ERROR: conversion from JSON failed"
}

class NetworkService {
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Authorization": "Client-ID \(clientId)"]
        return URLSession(configuration: configuration)
    }()
    var dataTask: URLSessionDataTask?

    func getSearchResults(for query: String, type: String = "jpg", completion: @escaping SearchResult) {
        let urlString = baseUrl + Endpoint.search(query: query, type: type).path
        sendNetworkRequestWith(urlString) { data, error in
            if let error = error {
                completion(nil, error)
            } else if let data = data {
                guard let responseJSON = try? JSON(data: data) else {
                    completion(nil, JSONError.noData)
                    return
                }
                guard let dataJSON = responseJSON["data"].array else {
                    completion(nil, JSONError.conversionFailed)
                    return
                }

                let imageInfos = dataJSON.map({ ImageInfo(json: $0) }).filter({ $0.type == "image/jpeg" || $0.type == "image/png"})
                completion(imageInfos, nil)
            }
        }
    }

    func getComments(for imageId: String, completion: @escaping GetCommentsResult) {
        let urlString = baseUrl + Endpoint.comments(imageId: imageId).path
        sendNetworkRequestWith(urlString) { data, error in
            if let error = error {
                completion(nil, error)
            } else if let data = data {
                guard let responseJSON = try? JSON(data: data) else {
                    completion(nil, JSONError.noData)
                    return
                }
                guard let dataJSON = responseJSON["data"].array else {
                    completion(nil, JSONError.conversionFailed)
                    return
                }

                let comments = dataJSON.map({ Comment(json: $0) })
                completion(comments, nil)
            }
        }
    }

    private func sendNetworkRequestWith(_ urlString: String, completion: @escaping (Data?, Error?)-> ()) {
        dataTask?.cancel()

        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        guard let url = URL(string: urlString) else {
            assertionFailure("Can't get URL from string")
            return
        }
        dataTask = session.dataTask(with: url) { data, response, error in
            defer { self.dataTask = nil }
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            completion(data, error)
        }
        dataTask?.resume()
    }
}

//
//  DataModel.swift
//  GalleryDemoApp
//
//  Created by Aniket Patil on 24/01/23.
//

import Foundation

// MARK: - DataModel
struct DataModel: Codable {
    var id: String?
    var width, height: Int?
    var color, blurHash: String?
    var description, altDescription: String?
    var urls: Urls?
    var links: Links?
    var user: User?

    enum CodingKeys: String, CodingKey {
        case id
        case width, height, color
        case blurHash = "blur_hash"
        case description
        case altDescription = "alt_description"
        case urls, links
        case user
    }
}

// MARK: - Links
struct Links: Codable {
    var linksSelf, html, download, downloadLocation: String?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, download
        case downloadLocation = "download_location"
    }
}

// MARK: - User
struct User: Codable {
    var id: String?
    var username, name: String?
    var portfolioURL: String?
    var bio: String?
    var links: Links?

    enum CodingKeys: String, CodingKey {
        case id
        case username, name
        case portfolioURL = "portfolio_url"
        case bio, links
    }
}

// MARK: - Urls
struct Urls: Codable {
    var raw, full, regular, small: String?
    var thumb, smallS3: String?

    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}

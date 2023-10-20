//
//  File.swift
//
//
//  Created by Ambroise Decouttere on 09/10/2023.
//

import Foundation

struct ResponseVersion: Codable {
    var result: String
    var data: Version
}

struct Version: Codable {
    var id: Int
    var name: String
    var platform: Platform
    var store: Store
    var apiId: String
    var minVersion: String
    var publishedVersions: [PublishedVersion]
}

struct PublishedVersion: Codable {
    var tag: String
    var tagUpdatedAt: String
    var versionChangelog: String
    var type: VersionType
    var buildVersion: String
    var buildMinOsVersion: String

    enum CodingKeys: String, CodingKey {
        case tag
        case tagUpdatedAt
        case versionChangelog
        case type
        case buildVersion
        case buildMinOsVersion
    }
}

enum Store: String, Codable {
    case appleStore = "apple-store"
}

enum Platform: String, Codable {
    case ios
}

enum VersionType: String, Codable {
    case production
    case beta
}

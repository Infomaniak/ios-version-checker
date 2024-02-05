/*
 Infomaniak Version Checker - iOS
 Copyright (C) 2024 Infomaniak Network SA

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

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

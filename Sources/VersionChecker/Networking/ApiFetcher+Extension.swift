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

import Alamofire
import Foundation
import InfomaniakCore

extension Endpoint {
    static func version(store: Store, platform: Platform, appName: String) -> Endpoint {
        return Endpoint(path: "/1/app-information/versions/\(store.rawValue)/\(platform.rawValue)/\(appName)", queryItems: [
            URLQueryItem(
                name: "only",
                value: "min_version,published_versions.tag,published_versions.tag_updated_at,published_versions.type,published_versions.build_version,published_versions.build_min_os_version"
            )
        ])
    }
}

extension ApiFetcher {
    private var versionDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(Constants.dateFormatter)
        return decoder
    }

    func version(appName: String, platform: Platform) async throws -> Version {
        let endpoint = Endpoint.version(store: .appleStore, platform: platform, appName: appName)
        return try await perform(request: AF.request(endpoint.url), overrideDecoder: versionDecoder)
    }
}

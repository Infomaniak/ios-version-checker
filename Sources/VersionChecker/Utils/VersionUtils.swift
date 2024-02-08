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

enum VersionUtils {
    static func getCurrentlyInstalledVersion() -> (tag: String, build: String)? {
        guard let tag = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
              let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            return nil
        }

        return (tag, build)
    }

    static func versionFrom(tag: String, build: String) -> String {
        return "\(tag) - \(build)"
    }

    static func versionFrom(publishedVersion: PublishedVersion) -> String {
        return versionFrom(tag: publishedVersion.tag, build: publishedVersion.buildVersion)
    }
}

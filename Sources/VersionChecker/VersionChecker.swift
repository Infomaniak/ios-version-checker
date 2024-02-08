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

public enum VersionStatus {
    case updateIsRequired, canBeUpdated, isUpToDate
}

public struct VersionChecker {
    public static let standard = VersionChecker()

    private let appLaunchCounter = AppLaunchCounter()
    
    /// Checks if the app is up to date, can be updated or if it is outdated and must be updated
    /// - Returns: The status of the current version of the app
    public func checkAppVersionStatus() async throws -> VersionStatus {
        let apiFetcher = ApiFetcher()
        let version = try await apiFetcher.version()

        if isAppOutdated(minimumVersion: version.minVersion) {
            return .updateIsRequired
        }

        if let publishedVersion = version.latestPublishedVersion,
           appCanBeUpdated(publishedVersion: publishedVersion) && shouldAskUserToUpdate(publishedVersion: publishedVersion) {
            VersionChecker.lastRequestVersion = VersionUtils.versionFrom(publishedVersion: publishedVersion)
            return .canBeUpdated
        }

        return .isUpToDate
    }

    private func isAppOutdated(minimumVersion: String) -> Bool {
        guard let installedVersionTag = VersionUtils.getCurrentlyInstalledVersion()?.tag else { return false }
        return installedVersionTag.compare(minimumVersion, options: .numeric) == .orderedAscending
    }

    private func appCanBeUpdated(publishedVersion: PublishedVersion) -> Bool {
        guard let (tag, build) = VersionUtils.getCurrentlyInstalledVersion() else { return false }
        let currentVersion = VersionUtils.versionFrom(tag: tag, build: build)
        let latestVersion = VersionUtils.versionFrom(publishedVersion: publishedVersion)

        return currentVersion.compare(latestVersion, options: .numeric) == .orderedAscending
    }

    private func shouldAskUserToUpdate(publishedVersion: PublishedVersion) -> Bool {
        return requestCounterIsValid || newVersionIsDifferent(publishedVersion: publishedVersion)
    }
}

// MARK: - Properties

extension VersionChecker {
    private static var lastRequestVersion: String? {
        get {
            return UserDefaults.standard.lastRequestVersion
        }
        set {
            UserDefaults.standard.lastRequestVersion = newValue
        }
    }
}

// MARK: - Comparator

extension VersionChecker {
    private var requestCounterIsValid: Bool {
        return appLaunchCounter.value % 10 == 0
    }

    private func newVersionIsDifferent(publishedVersion: PublishedVersion) -> Bool {
        return VersionUtils.versionFrom(publishedVersion: publishedVersion) != VersionChecker.lastRequestVersion
            && publishedVersion.hasBeenPublishedLongEnough
    }
}

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

    public func checkAppVersionStatus() async throws -> VersionStatus {
        let apiFetcher = ApiFetcher()
        let version = try await apiFetcher.version()

        guard let currentInstalledVersion = getCurrentInstalledVersion() else {
            return .isUpToDate
        }

        //VersionChecker.lastRequestVersion = versionFrom(publishedVersion: publishedVersion)

        guard !appMustBeUpdated(installedVersion: currentInstalledVersion.tag, minimumVersion: version.minVersion) else {
            return .updateIsRequired
        }

        let publishedVersion = version.publishedVersions.first { $0.type == (Bundle.main.isRunningInTestFlight ? .beta : .production) }
        guard let publishedVersion, appCanBeUpdated(publishedVersion: publishedVersion), shouldAskForUpdate(publishedVersion: publishedVersion) else {
            return .isUpToDate
        }

        return .canBeUpdated
    }

    private func appMustBeUpdated(installedVersion: String, minimumVersion: String) -> Bool {
        return installedVersion.compare(minimumVersion, options: .numeric) == .orderedAscending
    }

    private func appCanBeUpdated(publishedVersion: PublishedVersion) -> Bool {
        guard let (tag, build) = getCurrentInstalledVersion() else { return false }
        let currentVersion = versionFrom(tag: tag, build: build)
        let latestVersion = versionFrom(publishedVersion: publishedVersion)

        return currentVersion.compare(latestVersion, options: .numeric) == .orderedAscending
    }

    private func shouldAskForUpdate(publishedVersion: PublishedVersion) -> Bool {
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
        return versionFrom(publishedVersion: publishedVersion) != VersionChecker.lastRequestVersion && isTooOld(version: publishedVersion)
    }

    private func isTooOld(version: PublishedVersion) -> Bool {
        return Calendar.current.numberOfDaysBetween(Date(), and: version.tagUpdatedAt) <= -7
    }
}

// MARK: - Utils

extension VersionChecker {
    private func getCurrentInstalledVersion() -> (tag: String, build: String)? {
        guard let currentTag = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
              let currentBuild = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            return nil
        }

        return (currentTag, currentBuild)
    }

    private func versionFrom(tag: String, build: String) -> String {
        return "\(tag) - \(build)"
    }

    private func versionFrom(publishedVersion: PublishedVersion) -> String {
        return versionFrom(tag: publishedVersion.tag, build: publishedVersion.buildVersion)
    }
}

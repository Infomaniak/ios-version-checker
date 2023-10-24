//
//  SnackBar.swift
//  CommonUI
//
//  Created by Ambroise Decouttere on 2/10/23.
//

import Alamofire
import Foundation
import InfomaniakCore

public struct VersionChecker {
    public static let standard = VersionChecker()
    private let appLaunchCounter = AppLaunchCounter()

    public func showUpdateVersion() async throws -> Bool {
        let apiFetcher = ApiFetcher()
        let version = try await apiFetcher.version()

        let publishedVersion = version.publishedVersions
            .first(where: { $0.type == (Bundle.main.isRunningInTestFlight ? .beta : .production) })

        guard let publishedVersion,
              try await appNeedUpdate(publishedVersion: publishedVersion),
              shouldAskForUpdate(publishedVersion: publishedVersion) else {
            return false
        }

        VersionChecker.lastRequestVersion = versionFrom(publishedVersion: publishedVersion)
        return true
    }

    private func appNeedUpdate(publishedVersion: PublishedVersion) async throws -> Bool {
        guard let currentTag = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
              let currentBuild = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            // We don't have any version to compare
            return false
        }

        let currentVersion = versionFrom(tag: currentTag, build: currentBuild)
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
        let publishedDate = version.tagUpdatedAt.toDate() ?? Date()
        return Calendar.current.numberOfDaysBetween(Date(), and: publishedDate) <= -7
    }
}

// MARK: - Utils

extension VersionChecker {
    private func versionFrom(tag: String, build: String) -> String {
        return "\(tag) - \(build)"
    }

    private func versionFrom(publishedVersion: PublishedVersion) -> String {
        return versionFrom(tag: publishedVersion.tag, build: publishedVersion.buildVersion)
    }
}

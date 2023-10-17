//
//  SnackBar.swift
//  CommonUI
//
//  Created by Ambroise Decouttere on 2/10/23.
//

import Alamofire
import Foundation
import InfomaniakCore

extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>

        return numberOfDays.day!
    }
}

public struct VersionChecker {
    public static let standard = VersionChecker()

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

    private func versionFrom(tag: String, build: String) -> String {
        return "\(tag) - \(build)"
    }

    private func versionFrom(publishedVersion: PublishedVersion) -> String {
        return versionFrom(tag: publishedVersion.tag, build: publishedVersion.buildVersion)
    }

    public func showUpdateVersion() async throws -> Bool {
        let apiFetcher = ApiFetcher()
        let version = try await apiFetcher.version()

        guard let publishedVersion = version.publishedVersions
            .first(where: { $0.type == (Bundle.main.isRunningInTestFlight ? .beta : .production) }),
            try await appNeedUpdate(publishedVersion: publishedVersion) else {
            return false
        }

        let timer = UserDefaults.standard.timer
        let publishedDate = publishedDate(from: publishedVersion.tagUpdatedAt) ?? Date()
        if timer == 0 || (Calendar.current.numberOfDaysBetween(Date(), and: publishedDate) <= -2 &&
            UserDefaults.standard.lastUpdateAsked != versionFrom(publishedVersion: publishedVersion)) {
            UserDefaults.standard.lastUpdateAsked = versionFrom(publishedVersion: publishedVersion)
            return true
        }

        UserDefaults.standard.timer -= 1
        return false
    }

    private func publishedDate(from value: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: value)
    }

    public func updateLater() {
        UserDefaults.standard.timer = 10
    }
}

extension Endpoint {
    static func version(store: Store, platform: Platform, appName: String) -> Endpoint {
        return Endpoint(path: "/1/app-information/versions/\(store.rawValue)/\(platform.rawValue)/\(appName)")
    }
}

extension ApiFetcher {
    var versionDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    func version() async throws -> Version {
        let endpoint = Endpoint.version(store: .appleStore, platform: .ios, appName: "com.infomaniak.mail")

        let response = await AF.request(endpoint.url).serializingDecodable(ResponseVersion.self,
                                                                           automaticallyCancelling: true,
                                                                           decoder: versionDecoder).response
        return try response.result.get().data
    }
}

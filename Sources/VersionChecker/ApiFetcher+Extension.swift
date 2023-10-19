//
//  File.swift
//
//
//  Created by Ambroise Decouttere on 19/10/2023.
//

import Alamofire
import Foundation
import InfomaniakCore

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

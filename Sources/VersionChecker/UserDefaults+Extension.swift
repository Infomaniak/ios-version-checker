//
//  File.swift
//
//
//  Created by Ambroise Decouttere on 17/10/2023.
//

import Foundation
import InfomaniakCore

extension UserDefaults.Keys {
    static let lastRequestVersion = UserDefaults.Keys(rawValue: "lastRequestVersion")
}

extension UserDefaults {
    var lastRequestVersion: String? {
        get {
            return string(forKey: key(.lastRequestVersion))
        }
        set {
            set(newValue, forKey: key(.lastRequestVersion))
        }
    }
}

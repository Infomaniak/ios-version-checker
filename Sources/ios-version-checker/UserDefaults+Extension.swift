//
//  File.swift
//
//
//  Created by Ambroise Decouttere on 17/10/2023.
//

import Foundation
import InfomaniakCore

extension UserDefaults.Keys {
    static let timerKey = UserDefaults.Keys(rawValue: "showUpdateTimer")
    static let lastForcedUpdateKey = UserDefaults.Keys(rawValue: "lastForcedUpdateTag")
}

extension UserDefaults {
    var timer: Int {
        get {
            return integer(forKey: key(.timerKey))
        }
        set {
            set(newValue, forKey: key(.timerKey))
        }
    }

    var lastForcedUpdate: String? {
        get {
            return string(forKey: key(.lastForcedUpdateKey))
        }
        set {
            set(newValue, forKey: key(.lastForcedUpdateKey))
        }
    }
}

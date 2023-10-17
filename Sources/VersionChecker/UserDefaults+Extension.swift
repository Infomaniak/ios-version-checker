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
    static let lastUpdateAskedKey = UserDefaults.Keys(rawValue: "lastUpdateAskedTag")
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

    var lastUpdateAsked: String? {
        get {
            return string(forKey: key(.lastUpdateAskedKey))
        }
        set {
            set(newValue, forKey: key(.lastUpdateAskedKey))
        }
    }
}

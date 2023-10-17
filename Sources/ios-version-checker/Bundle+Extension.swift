//
//  File.swift
//
//
//  Created by Ambroise Decouttere on 17/10/2023.
//

import Foundation

public extension Bundle {
    /// Indicates whether the app is currently running in a TestFlight environment.
    var isRunningInTestFlight: Bool {
        guard let path = appStoreReceiptURL?.path else {
            return false
        }

        return path.contains("sandboxReceipt")
    }
}

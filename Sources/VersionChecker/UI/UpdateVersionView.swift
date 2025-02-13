/*
 Infomaniak Version Checker - iOS
 Copyright (C) 2025 Infomaniak Network SA

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

import InfomaniakCoreSwiftUI
import SwiftUI

@available(iOS 15.0, *)
public struct UpdateVersionView: View {
    @Environment(\.openURL) private var openURL
    @Environment(\.dismiss) private var dismiss

    private var image: Image
    private var onComplete: (Bool) -> Void

    public init(image: Image, onComplete: @escaping (Bool) -> Void) {
        self.image = image
        self.onComplete = onComplete
    }

    public var body: some View {
        let item = DiscoveryItem(
            image: image,
            title: String(localized: "updateAvailableTitle", bundle: .module),
            description: String(localized: "updateAvailableDescription", bundle: .module),
            primaryButtonLabel: String(localized: "updateRequiredButton", bundle: .module),
            shouldDisplayLaterButton: true
        )

        DiscoveryView(item: item) { willUpdate in
            onComplete(willUpdate)
            dismiss()
        }
    }
}

@available(iOS 15.0, *)
#Preview {
    UpdateVersionView(image: Image("xmark")) { onComplete in
    }
}

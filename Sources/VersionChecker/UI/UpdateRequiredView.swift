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

import SwiftUI

public struct UpdateRequiredView: View {
    public let image: Image
    public let sharedStyle: TemplateSharedStyle
    public let updateHandler: () -> Void
    public let dismissHandler: (() -> Void)?

    public init(
        image: Image,
        sharedStyle: TemplateSharedStyle,
        updateHandler: @escaping () -> Void,
        dismissHandler: (() -> Void)? = nil
    ) {
        self.image = image
        self.sharedStyle = sharedStyle
        self.updateHandler = updateHandler
        self.dismissHandler = dismissHandler
    }

    public var body: some View {
        ZStack {
            VStack(spacing: 32) {
                VStack(spacing: 32) {
                    image
                        .resizable()
                        .scaledToFit()

                    Text("updateRequiredTitle", bundle: .module)
                        .font(sharedStyle.titleTextStyle.font)
                        .foregroundColor(sharedStyle.titleTextStyle.color)

                    Text("updateRequiredDescription", bundle: .module)
                        .font(sharedStyle.descriptionTextStyle.font)
                        .foregroundColor(sharedStyle.descriptionTextStyle.color)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: 496, maxHeight: .infinity)

                Button(action: updateHandler) {
                    Text("updateRequiredButton", bundle: .module)
                        .font(sharedStyle.buttonStyle.textStyle.font)
                        .foregroundColor(sharedStyle.buttonStyle.textStyle.color)
                        .frame(maxWidth: 496)
                        .frame(height: sharedStyle.buttonStyle.height)
                        .background(
                            RoundedRectangle(cornerRadius: sharedStyle.buttonStyle.radius)
                                .fill(sharedStyle.buttonStyle.background)
                        )
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)

            if let dismissHandler {
                Button(action: dismissHandler) {
                    Image(systemName: "xmark")
                        .font(.system(size: 22, weight: .light))
                        .foregroundColor(sharedStyle.buttonStyle.background)
                }
                .padding([.top, .leading], 16)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
        .frame(maxWidth: .infinity)
        .background(sharedStyle.background.edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    let header = TemplateSharedStyle.TextStyle(font: .title, color: .black)
    let body = TemplateSharedStyle.TextStyle(font: .body, color: .gray)
    let bodyButton = TemplateSharedStyle.TextStyle(font: .body, color: DevelopmentAssets.secondaryButtonColor)

    let customStyle = TemplateSharedStyle(
        background: DevelopmentAssets.background,
        titleTextStyle: header,
        descriptionTextStyle: body,
        buttonStyle: .init(background: DevelopmentAssets.primaryButtonColor, textStyle: bodyButton, height: 56, radius: 16)
    )

    return UpdateRequiredView(image: DevelopmentAssets.image, sharedStyle: customStyle) {
        /* Update Handler */
    } dismissHandler: {
        /* Dismiss Handler */
    }
}

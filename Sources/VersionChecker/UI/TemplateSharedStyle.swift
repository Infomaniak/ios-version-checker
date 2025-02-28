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

import SwiftUI

public struct TemplateSharedStyle: Sendable {
    public struct TextStyle: Sendable {
        public let font: Font
        public let color: Color

        public init(font: Font, color: Color) {
            self.font = font
            self.color = color
        }
    }

    public struct ButtonStyle: Sendable {
        public let background: Color
        public let textStyle: TextStyle
        public let height: CGFloat
        public let radius: CGFloat

        public init(background: Color, textStyle: TextStyle, height: CGFloat, radius: CGFloat) {
            self.background = background
            self.textStyle = textStyle
            self.height = height
            self.radius = radius
        }
    }

    public let background: Color
    public let titleTextStyle: TextStyle
    public let descriptionTextStyle: TextStyle
    public let buttonStyle: ButtonStyle

    public init(background: Color, titleTextStyle: TextStyle, descriptionTextStyle: TextStyle, buttonStyle: ButtonStyle) {
        self.background = background
        self.titleTextStyle = titleTextStyle
        self.descriptionTextStyle = descriptionTextStyle
        self.buttonStyle = buttonStyle
    }
}

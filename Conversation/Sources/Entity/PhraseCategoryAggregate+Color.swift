import SwiftUI
import UIKit

public extension PhraseCategoryAggregate.Icon.Color {
    func toColor() -> Color {
        Color(red: red, green: green, blue: blue, opacity: alpha)
    }

    init(color: Color) {
        var redComponent: CGFloat = 0
        var greenComponent: CGFloat = 0
        var blueComponent: CGFloat = 0
        var alphaComponent: CGFloat = 0
        UIColor(color).getRed(&redComponent, green: &greenComponent, blue: &blueComponent, alpha: &alphaComponent)
        self.init(red: Double(redComponent), green: Double(greenComponent), blue: Double(blueComponent), alpha: Double(alphaComponent))
    }
}

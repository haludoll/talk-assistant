//
//  PhraseCategory.swift
//  ConversationPersistenceModel
//
//  Created by ChatGPT on 2025/09/16.
//

import Foundation
import SwiftData
import SwiftUI

@Model
public final class PhraseCategory: Identifiable {
    @Attribute(.unique) public var id: UUID
    package var createdAt: Date
    package var metadata: Metadata
    @Relationship(deleteRule: .cascade, inverse: \Phrase.category) package var phrases: [Phrase] = []

    package init(id: UUID, createdAt: Date, metadata: Metadata, phrases: [Phrase]) {
        self.id = id
        self.createdAt = createdAt
        self.metadata = metadata
        self.phrases = phrases
    }

    package struct Metadata: Codable {
        package var name: String
        package var icon: Icon

        package init(name: String, icon: Icon) {
            self.name = name
            self.icon = icon
        }

        package struct Icon: Codable {
            package var name: String
            package var colorData: Data
            package var color: Color {
                get {
                    try! JSONDecoder().decode(Color.self, from: colorData)
                }
                set {
                    colorData = try! JSONEncoder().encode(newValue)
                }
            }

            package init(name: String, color: Color) {
                self.name = name
                self.colorData = try! JSONEncoder().encode(color)
            }
        }
    }
}

extension Color: Codable {
    enum CodingKeys: String, CodingKey {
        case red
        case green
        case blue
        case opacity
    }

    public func encode(to encoder: Encoder) throws {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var opacity: CGFloat = 0

        var container = encoder.container(keyedBy: CodingKeys.self)
        UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &opacity)
        try container.encode(red, forKey: .red)
        try container.encode(green, forKey: .green)
        try container.encode(blue, forKey: .blue)
        try container.encode(opacity, forKey: .opacity)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let red = try container.decode(Double.self, forKey: .red)
        let green = try container.decode(Double.self, forKey: .green)
        let blue = try container.decode(Double.self, forKey: .blue)
        let opacity = try container.decode(Double.self, forKey: .opacity)
        self.init(red: red, green: green, blue: blue, opacity: opacity)
    }
}

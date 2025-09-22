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
    public var createdAt: Date
    public var metadata: Metadata
    @Relationship(deleteRule: .cascade, inverse: \Phrase.category) public var phrases: [Phrase] = []

    public init(id: UUID, createdAt: Date, metadata: Metadata, phrases: [Phrase]) {
        self.id = id
        self.createdAt = createdAt
        self.metadata = metadata
        self.phrases = phrases
    }

    public struct Metadata: Codable {
        public var name: String
        public var icon: Icon

        public init(name: String, icon: Icon) {
            self.name = name
            self.icon = icon
        }

        public struct Icon: Codable {
            public var name: String
            public var colorData: Data
            public var color: Color {
                get {
                    try! JSONDecoder().decode(Color.self, from: colorData)
                }
                set {
                    colorData = try! JSONEncoder().encode(newValue)
                }
            }

            public init(name: String, color: Color) {
                self.name = name
                self.colorData = try! JSONEncoder().encode(color)
            }
        }
    }
}

extension Color: @retroactive Decodable {}
extension Color: @retroactive Encodable {}
extension Color {
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

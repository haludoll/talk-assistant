import Foundation

/// 会話領域のカテゴリ集約。カテゴリ本体と配下のフレーズを一体で扱う。
public struct PhraseCategory: Identifiable, Hashable, Sendable {
    /// カテゴリが持つアイコン情報。
    public struct Icon: Hashable, Sendable {
        /// UI層に依存しない RGBA 色表現。
        public struct Color: Hashable, Sendable {
            public var red: Double
            public var green: Double
            public var blue: Double
            public var alpha: Double

            public init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
                self.red = red
                self.green = green
                self.blue = blue
                self.alpha = alpha
            }
        }

        public var systemName: String
        public var color: Color

        public init(systemName: String, color: Color) {
            self.systemName = systemName
            self.color = color
        }
    }

    /// 集約内で管理されるフレーズ。
    public struct Phrase: Identifiable, Hashable, Sendable {
        public var id: UUID
        public var createdAt: Date
        public var value: String
        public var categoryID: PhraseCategory.ID?

        public init(id: UUID = UUID(),
                    createdAt: Date = Date(),
                    value: String,
                    categoryID: PhraseCategory.ID?) {
            self.id = id
            self.createdAt = createdAt
            self.value = value
            self.categoryID = categoryID
        }
    }

    public var id: UUID
    public var createdAt: Date
    public var name: String
    public var icon: Icon
    public var sortOrder: Int
    public var phrases: [Phrase]

    public init(id: UUID = UUID(),
                createdAt: Date = Date(),
                name: String,
                icon: Icon,
                sortOrder: Int = 0,
                phrases: [Phrase] = []) {
        self.id = id
        self.createdAt = createdAt
        self.name = name
        self.icon = icon
        self.sortOrder = sortOrder
        self.phrases = phrases
    }
}

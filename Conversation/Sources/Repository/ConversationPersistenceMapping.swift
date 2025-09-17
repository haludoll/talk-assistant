import ConversationEntity
import ConversationPersistenceModel
import SwiftData
import SwiftUI
import UIKit

extension ConversationEntity.PhraseCategory {
    func makePersistenceCategory(in context: ModelContext) -> ConversationPersistenceModel.PhraseCategory {
        let swiftUIColor = Color(
            red: icon.color.red,
            green: icon.color.green,
            blue: icon.color.blue,
            opacity: icon.color.alpha
        )
        let metadata = ConversationPersistenceModel.PhraseCategory.Metadata(
            name: name,
            icon: .init(name: icon.systemName, color: swiftUIColor)
        )
        let persistencePhrases = phrases.map { phrase in
            ConversationPersistenceModel.Phrase(
                id: phrase.id,
                createdAt: phrase.createdAt,
                value: phrase.value,
                category: nil
            )
        }
        let category = ConversationPersistenceModel.PhraseCategory(
            id: id,
            createdAt: createdAt,
            metadata: metadata,
            phrases: persistencePhrases
        )
        for phrase in category.phrases {
            phrase.category = category
        }
        context.insert(category)
        return category
    }
}

extension ConversationPersistenceModel.PhraseCategory {
    func toAggregate() -> ConversationEntity.PhraseCategory {
        let rgba = metadata.icon.color.rgbaComponents
        let iconColor = ConversationEntity.PhraseCategory.Icon.Color(
            red: rgba.red,
            green: rgba.green,
            blue: rgba.blue,
            alpha: rgba.alpha
        )
        let icon = ConversationEntity.PhraseCategory.Icon(systemName: metadata.icon.name, color: iconColor)
        let mappedPhrases = phrases
            .sorted(by: { $0.createdAt > $1.createdAt })
            .map { phrase in
            ConversationEntity.PhraseCategory.Phrase(
                id: phrase.id,
                createdAt: phrase.createdAt,
                value: phrase.value,
                categoryID: phrase.category?.id
            )
        }
        return ConversationEntity.PhraseCategory(
            id: id,
            createdAt: createdAt,
            name: metadata.name,
            icon: icon,
            phrases: mappedPhrases
        )
    }
}

extension ConversationPersistenceModel.PhraseCategory {
    func apply(_ aggregate: ConversationEntity.PhraseCategory, in context: ModelContext) {
        createdAt = aggregate.createdAt
        metadata = .init(
            name: aggregate.name,
            icon: .init(
                name: aggregate.icon.systemName,
                color: Color(
                    red: aggregate.icon.color.red,
                    green: aggregate.icon.color.green,
                    blue: aggregate.icon.color.blue,
                    opacity: aggregate.icon.color.alpha
                )
            )
        )

        var existing = Dictionary(uniqueKeysWithValues: phrases.map { ($0.id, $0) })
        var next: [ConversationPersistenceModel.Phrase] = []

        for phrase in aggregate.phrases {
            if let current = existing.removeValue(forKey: phrase.id) {
                current.createdAt = phrase.createdAt
                current.value = phrase.value
                current.category = self
                next.append(current)
            } else {
                let created = ConversationPersistenceModel.Phrase(
                    id: phrase.id,
                    createdAt: phrase.createdAt,
                    value: phrase.value,
                    category: self
                )
                next.append(created)
            }
        }

        for orphan in existing.values {
            context.delete(orphan)
        }

        phrases = next.sorted(by: { $0.createdAt > $1.createdAt })
    }
}

private extension Color {
    var rgbaComponents: (red: Double, green: Double, blue: Double, alpha: Double) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (Double(red), Double(green), Double(blue), Double(alpha))
    }
}

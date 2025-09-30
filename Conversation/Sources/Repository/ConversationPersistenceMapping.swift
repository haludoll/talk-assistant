import ConversationEntity
import ConversationPersistenceModel
import SwiftData
import SwiftUI
import UIKit

extension ConversationEntity.PhraseCategory {
    var toPersistenceModel: ConversationPersistenceModel.PhraseCategory {
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
            metadata: toMetadata,
            sortOrder: sortOrder,
            phrases: persistencePhrases
        )
        for phrase in category.phrases {
            phrase.category = category
        }
        return category
    }
}

extension ConversationEntity.PhraseCategory {
    var toMetadata: ConversationPersistenceModel.PhraseCategory.Metadata {
        .init(name: name, icon: icon.toPersistenceModel)
    }
}

extension ConversationEntity.PhraseCategory.Icon {
    var toPersistenceModel: ConversationPersistenceModel.PhraseCategory.Metadata.Icon {
        .init(name: systemName, color: .init(red: color.red, green: color.green, blue: color.blue, opacity: color.alpha))
    }
}

extension ConversationPersistenceModel.PhraseCategory {
    var toAggregate: ConversationEntity.PhraseCategory {
        let rgba = metadata.icon.color.rgbaComponents
        let iconColor = ConversationEntity.PhraseCategory.Icon.Color(
            red: rgba.red,
            green: rgba.green,
            blue: rgba.blue,
            alpha: rgba.alpha
        )

        let mappedPhrases = phrases
            .sorted(by: { $0.createdAt > $1.createdAt })
            .map { phrase -> ConversationEntity.PhraseCategory.Phrase in
                .init(
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
            icon: .init(systemName: metadata.icon.name, color: iconColor),
            sortOrder: sortOrder,
            phrases: mappedPhrases
        )
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

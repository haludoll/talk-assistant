import ConversationEntity
import ConversationPersistenceModel
import SwiftUI
import UIKit

extension ConversationEntity.PhraseCategoryAggregate {
    func makePersistenceCategory() -> ConversationPersistenceModel.PhraseCategory {
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
        return category
    }
}

extension ConversationPersistenceModel.PhraseCategory {
    func toAggregate() -> ConversationEntity.PhraseCategoryAggregate {
        let rgba = metadata.icon.color.rgbaComponents
        let iconColor = ConversationEntity.PhraseCategoryAggregate.Icon.Color(
            red: rgba.red,
            green: rgba.green,
            blue: rgba.blue,
            alpha: rgba.alpha
        )
        let icon = ConversationEntity.PhraseCategoryAggregate.Icon(systemName: metadata.icon.name, color: iconColor)
        let mappedPhrases = phrases.map { phrase in
            ConversationEntity.PhraseCategoryAggregate.Phrase(
                id: phrase.id,
                createdAt: phrase.createdAt,
                value: phrase.value,
                categoryID: phrase.category?.id
            )
        }
        return ConversationEntity.PhraseCategoryAggregate(
            id: id,
            createdAt: createdAt,
            name: metadata.name,
            icon: icon,
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

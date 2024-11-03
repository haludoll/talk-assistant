//
//  PhraseCategoryRepository.swift
//  Conversation
//
//  Created by haludoll on 2024/11/04.
//

package struct PhraseCategoryRepository {
    package let fetchAll: () -> [PhraseCategory]
    package let create: (PhraseCategory) -> Void
}

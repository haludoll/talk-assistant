//
//  ConversationViewModel.swift
//  Conversation
//
//  Created by haludoll on 2024/10/24.
//

import Foundation
import SpeechSynthesizerEntity
import SpeechSynthesizerDependency
import Dependencies

@Observable
@MainActor
package final class ConversationViewModel {
    public var text = ""
    public private(set) var lastText = ""
    public var isSpeaking = false

    @ObservationIgnored
    @Dependency(\.speechSynthesizer) var speechSynthesizer
    @ObservationIgnored private var task: Task<Void, Never>?

    package init() {
        task = Task {
            await observeSpeechDelegate()
        }
    }

    deinit {
        task?.cancel()
    }

    package func speak() {
        guard !isSpeaking else { return }
        speechSynthesizer.speak(text: text)
    }

    package func stop() {
        guard isSpeaking else { return }
        speechSynthesizer.stop()
    }

    func observeSpeechDelegate() async {
        for await action in speechSynthesizer.delegateAsyncChannel {
            switch action {
            case .didStart:
                isSpeaking = true
            case .didFinish:
                isSpeaking = false
                lastText = text
                text = ""
            case .didCancel:
                isSpeaking = false
            }
        }
    }
}

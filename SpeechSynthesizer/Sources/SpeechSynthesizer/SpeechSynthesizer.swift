//
//  SpeechSynthesizer.swift
//  Conversation
//
//  Created by haludoll on 2024/10/12.
//

import AVFoundation
import AsyncAlgorithms

@Observable
@MainActor
public final class SpeechSynthesizer: NSObject {
    public var text = ""
    public private(set) var isSpeaking = false

    private let avSpeechSynthesizer = {
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.mixToTelephonyUplink = true
        return synthesizer
    }()

    private let speechDelegateAsyncChannel = AsyncChannel<AVSpeechSynthesizer.DelegateAction>()
    @ObservationIgnored private var task: Task<Void, Never>?

    public override init() {
        super.init()
        avSpeechSynthesizer.delegate = self

        task = Task {
            await observeSpeechDelegate()
        }
    }

    deinit {
        task?.cancel()
    }

    public func speak(_ text: String) {
        let utterance =  AVSpeechUtterance(string: text)
        // TODO: - Allow users to toggle whether or not they want to inherit the values of the Assistive Technology Settings.
        utterance.prefersAssistiveTechnologySettings = true
        avSpeechSynthesizer.speak(utterance)
    }

    private func observeSpeechDelegate() async {
        for await action in speechDelegateAsyncChannel {
            switch action {
            case .didStart:
                isSpeaking = true
            case .didFinish:
                isSpeaking = false
                text = ""
            }
        }
    }
}

extension SpeechSynthesizer: @preconcurrency AVSpeechSynthesizerDelegate {
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        Task {
            await speechDelegateAsyncChannel.send(.didStart)
        }
    }

    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task {
            await speechDelegateAsyncChannel.send(.didFinish)
        }
    }
}

private extension AVSpeechSynthesizer {
    enum DelegateAction {
        case didStart
        case didFinish
    }
}

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

    let speechDelegateAsyncChannel = AsyncChannel<AVSpeechSynthesizer.DelegateAction>()

    private let avSpeechSynthesizer = {
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.mixToTelephonyUplink = true
        return synthesizer
    }()
    @ObservationIgnored private var task: Task<Void, Never>?
    @ObservationIgnored private var willStopSpeaking = false  // WORKAROUND of `didCancel` delegate bug

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
        guard !isSpeaking else { return }
        let utterance =  AVSpeechUtterance(string: text)
        // TODO: - Allow users to toggle whether or not they want to inherit the values of the Assistive Technology Settings.
        utterance.prefersAssistiveTechnologySettings = true
        avSpeechSynthesizer.speak(utterance)
    }

    public func stop() {
        guard isSpeaking else { return }
        willStopSpeaking = true
        avSpeechSynthesizer.stopSpeaking(at: .immediate)
    }

    private func observeSpeechDelegate() async {
        for await action in speechDelegateAsyncChannel {
            switch action {
            case .didStart:
                isSpeaking = true
            case .didFinish:
                isSpeaking = false
                text = ""
            case .didCancel:
                isSpeaking = false
                willStopSpeaking = false
            }
        }
    }
}

extension SpeechSynthesizer: AVSpeechSynthesizerDelegate {
    nonisolated public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        Task { @MainActor in
            await speechDelegateAsyncChannel.send(.didStart)
        }
    }

    nonisolated public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in
            // WORKAROUND: Due to `didCancel` delegate bug
            if willStopSpeaking {
                await speechDelegateAsyncChannel.send(.didCancel)
            } else {
                await speechDelegateAsyncChannel.send(.didFinish)
            }
        }
    }

    // FIXME: This delegate method is not called even when `stopSpeaking` is called, due to the AVFoundation bug.
    // https://developer.apple.com/forums/thread/691347
    nonisolated public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {}
}

extension AVSpeechSynthesizer {
    enum DelegateAction {
        case didStart
        case didFinish
        case didCancel
    }
}

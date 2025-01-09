//
//  PhraseSpeakViewModelTests.swift
//  Conversation
//
//  Created by haludoll on 2024/10/24.
//

import XCTest
import AsyncAlgorithms
import Dependencies
import SpeechSynthesizerEntity
import AVFoundation
@testable import ConversationViewModel

@Observable
@MainActor
final class PhraseSpeakViewModelTests: XCTestCase {
    func test_speak_voiceSetting_nil_notExecuted() async {
        let expectation = XCTestExpectation(description: #function)
        expectation.isInverted = true
        let sut = withDependencies {
            $0.speechSynthesizer = SpeechSynthesizerMock(speakExpectation: expectation)
            $0.voiceSettingsRepository = .testValue
        } operation: {
            PhraseSpeakViewModel()
        }
        sut.isSpeaking = false
        sut.speak()
        await fulfillment(of: [expectation], timeout: 0.1)
    }

    func test_speak_voiceSetting_not_nil_executed() async {
        let expectation = XCTestExpectation(description: #function)
        let sut = withDependencies {
            $0.speechSynthesizer = SpeechSynthesizerMock(speakExpectation: expectation)
            $0.voiceSettingsRepository = .testValue
        } operation: {
            PhraseSpeakViewModel()
        }
        sut.isSpeaking = false
        sut.setupVoice()
        sut.speak()
        await fulfillment(of: [expectation], timeout: 0.1)
    }

    func test_didStart_isSpeaking_true() async {
        let sut = withDependencies {
            $0.speechSynthesizer = SpeechSynthesizerMock()
        } operation: {
            PhraseSpeakViewModel()
        }
        Task.detached {
            await sut.observeSpeechDelegate()
        }
        await Task.yield()

        let expectation = XCTestExpectation(description: #function)
        withObservationTracking {
            _ = sut.isSpeaking
        } onChange: {
            expectation.fulfill()
        }

        await sut.speechSynthesizer.delegateAsyncChannel.send(.didStart)
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertTrue(sut.isSpeaking)
    }

    func test_didFinish_isSpeaking_false() async {
        let sut = withDependencies {
            $0.speechSynthesizer = SpeechSynthesizerMock()
        } operation: {
            PhraseSpeakViewModel()
        }
        Task.detached {
            await sut.observeSpeechDelegate()
        }
        await Task.yield()

        sut.isSpeaking = true
        let expectation = XCTestExpectation(description: #function)
        withObservationTracking {
            _ = sut.isSpeaking
        } onChange: {
            expectation.fulfill()
        }

        await sut.speechSynthesizer.delegateAsyncChannel.send(.didFinish)
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertFalse(sut.isSpeaking)
    }

    func test_didFinish_lastText_equal_to_spokenText() async {
        let sut = withDependencies {
            $0.speechSynthesizer = SpeechSynthesizerMock()
        } operation: {
            PhraseSpeakViewModel()
        }
        Task.detached {
            await sut.observeSpeechDelegate()
        }
        await Task.yield()

        sut.text = "test"
        let expectation = XCTestExpectation(description: #function)
        withObservationTracking {
            _ = sut.lastText
        } onChange: {
            expectation.fulfill()
        }

        await sut.speechSynthesizer.delegateAsyncChannel.send(.didFinish)
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertEqual(sut.lastText, "test")
    }

    func test_didFinish_text_empty() async {
        let sut = withDependencies {
            $0.speechSynthesizer = SpeechSynthesizerMock()
        } operation: {
            PhraseSpeakViewModel()
        }
        Task.detached {
            await sut.observeSpeechDelegate()
        }
        await Task.yield()

        sut.text = "test"
        let expectation = XCTestExpectation(description: #function)
        withObservationTracking {
            _ = sut.text
        } onChange: {
            expectation.fulfill()
        }

        await sut.speechSynthesizer.delegateAsyncChannel.send(.didFinish)
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertTrue(sut.text.isEmpty)
    }

    func test_didCancel_isSpeaking_false() async {
        let sut = withDependencies {
            $0.speechSynthesizer = SpeechSynthesizerMock()
        } operation: {
            PhraseSpeakViewModel()
        }
        Task.detached {
            await sut.observeSpeechDelegate()
        }
        await Task.yield()

        let expectation = XCTestExpectation(description: #function)
        withObservationTracking {
            _ = sut.isSpeaking
        } onChange: {
            expectation.fulfill()
        }

        await sut.speechSynthesizer.delegateAsyncChannel.send(.didCancel)
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertFalse(sut.isSpeaking)
    }
}

private struct SpeechSynthesizerMock: SpeechSynthesizerProtocol {
    let delegateAsyncChannel = AsyncChannel<SpeechSynthesizerDelegateAction>()
    var speakExpectation: XCTestExpectation?
    var stopExpectation: XCTestExpectation?

    func speak(text: String, in voice: AVSpeechSynthesisVoice, using voiceParameter: VoiceParameter) {
        speakExpectation?.fulfill()
    }
    func stop() {
        stopExpectation?.fulfill()
    }
}

//
//  SpeechSampleViewModelTests.swift
//  Settings
//
//  Created by haludoll on 2024/11/02.
//

import XCTest
import Dependencies
import SpeechSynthesizerEntity
import AVFoundation
import AsyncAlgorithms
@testable import SettingsViewModel

@Observable
@MainActor
final class SpeechSampleViewModelTests: XCTestCase {
    func test_didStart_speakingVoice_not_nil() async {
        let sut = withDependencies {
            $0.speechSynthesizer = SpeechSynthesizerMock()
        } operation: {
            SpeechSampleViewModel()
        }
        Task.detached {
            await sut.observeSpeechDelegate()
        }
        await Task.yield()
        sut.speakingVoice = nil

        let expectation = XCTestExpectation(description: #function)
        withObservationTracking {
            _ = sut.speakingVoice
        } onChange: {
            expectation.fulfill()
        }
        let sampleVoice = AVSpeechSynthesisVoice(language: "en-US")!
        sut.speakSample(text: "This is sample.", with: sampleVoice)
        await sut.speechSynthesizer.delegateAsyncChannel.send(.didStart)
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertEqual(sut.speakingVoice, sampleVoice)
    }

    func test_didFinish_speakingVoice_nil() async {
        let sut = withDependencies {
            $0.speechSynthesizer = SpeechSynthesizerMock()
        } operation: {
            SpeechSampleViewModel()
        }
        Task.detached {
            await sut.observeSpeechDelegate()
        }
        await Task.yield()
        sut.speakingVoice = .init()

        let expectation = XCTestExpectation(description: #function)
        withObservationTracking {
            _ = sut.speakingVoice
        } onChange: {
            expectation.fulfill()
        }

        await sut.speechSynthesizer.delegateAsyncChannel.send(.didFinish)
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertNil(sut.speakingVoice)
    }

    func test_didCancel_speakingVoice_nil() async {
        let sut = withDependencies {
            $0.speechSynthesizer = SpeechSynthesizerMock()
        } operation: {
            SpeechSampleViewModel()
        }
        Task.detached {
            await sut.observeSpeechDelegate()
        }
        await Task.yield()
        sut.speakingVoice = .init()

        let expectation = XCTestExpectation(description: #function)
        withObservationTracking {
            _ = sut.speakingVoice
        } onChange: {
            expectation.fulfill()
        }

        await sut.speechSynthesizer.delegateAsyncChannel.send(.didCancel)
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertNil(sut.speakingVoice)
    }

    func test_speakingStatus_speakingVoice_nil_return_none() {
        let sut = withDependencies {
            $0.speechSynthesizer = SpeechSynthesizerMock()
        } operation: {
            SpeechSampleViewModel()
        }
        sut.speakingVoice = nil
        XCTAssertEqual(sut.speakingStatus(for: .init()), .none)
    }

    func test_speakingStatus_speakingVoice_not_nil_parameter_voice_equals_to_speaking_voice_return_speaking() {
        let sut = withDependencies {
            $0.speechSynthesizer = SpeechSynthesizerMock()
        } operation: {
            SpeechSampleViewModel()
        }
        let voice = AVSpeechSynthesisVoice(language: "en-US")!
        sut.speakingVoice = voice
        XCTAssertEqual(sut.speakingStatus(for: voice), .speaking)
    }

    func test_speakingStatus_speakingVoice_not_nil_parameter_voice_not_equals_to_speaking_voice_return_speakingSomeoneElse() {
        let sut = withDependencies {
            $0.speechSynthesizer = SpeechSynthesizerMock()
        } operation: {
            SpeechSampleViewModel()
        }
        let voice = AVSpeechSynthesisVoice(language: "en-US")!
        sut.speakingVoice = voice
        XCTAssertEqual(sut.speakingStatus(for: .init(identifier: "com.apple.speech.synthesis.voice.Albert")!), .speakingSomeoneElse)
    }
}

private struct SpeechSynthesizerMock: SpeechSynthesizerProtocol {
    let delegateAsyncChannel = AsyncChannel<SpeechSynthesizerDelegateAction>()

    func speak(text: String, in voice: AVSpeechSynthesisVoice, using voiceParameter: VoiceParameter) {}
    func stop() {}
}

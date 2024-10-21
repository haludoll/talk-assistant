//
//  SpeechSynthesizerTests.swift
//  SpeechSynthesizer
//
//  Created by haludoll on 2024/10/13.
//

import XCTest
import AVFoundation
import Dependencies
@testable import SpeechSynthesizer

@Observable
@MainActor
final class SpeechSynthesizerTests: XCTestCase {
    func test_didStart_isSpeaking_true() async {
        let sut = withDependencies {
            $0.avSpeechSynthesizer = AVSpeechSynthesizerMock()
        } operation: {
            SpeechSynthesizer()
        }
        XCTAssertFalse(sut.isSpeaking)

        let expectation = XCTestExpectation(description: #function)
        withObservationTracking {
            _ = sut.isSpeaking
        } onChange: {
            expectation.fulfill()
        }
        await sut.speechDelegateAsyncChannel.send(.didStart)
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertTrue(sut.isSpeaking)
    }

    func test_didFinish_isSpeaking_true() async {
        let sut = withDependencies {
            $0.avSpeechSynthesizer = AVSpeechSynthesizerMock()
        } operation: {
            SpeechSynthesizer()
        }
        await sut.speechDelegateAsyncChannel.send(.didStart)

        let expectation = XCTestExpectation(description: #function)
        withObservationTracking {
            _ = sut.isSpeaking
        } onChange: {
            expectation.fulfill()
        }
        await sut.speechDelegateAsyncChannel.send(.didFinish)
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertFalse(sut.isSpeaking)
    }

    func test_didFinish_text_empty() async {
        let sut = withDependencies {
            $0.avSpeechSynthesizer = AVSpeechSynthesizerMock()
        } operation: {
            SpeechSynthesizer()
        }
        sut.text = "test"

        let expectation = XCTestExpectation(description: #function)
        withObservationTracking {
            _ = sut.text
        } onChange: {
            expectation.fulfill()
        }
        await sut.speechDelegateAsyncChannel.send(.didFinish)
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertTrue(sut.text.isEmpty)
    }
    
    func test_didCancel_willStopSpeaking_false() async {
        let sut = withDependencies {
            $0.avSpeechSynthesizer = AVSpeechSynthesizerMock()
        } operation: {
            SpeechSynthesizer()
        }
        sut.isSpeaking = true
        sut.stop()
        await sut.speechDelegateAsyncChannel.send(.didCancel)
        XCTAssertFalse(sut.willStopSpeaking)
    }

    func test_speak_isSpeaking_false_executed() async {
        let expectation = XCTestExpectation(description: #function)
        let avSpeechSynthesizerMock = AVSpeechSynthesizerMock(speakExpectation: expectation)
        let sut = withDependencies {
            $0.avSpeechSynthesizer = avSpeechSynthesizerMock
        } operation: {
            SpeechSynthesizer()
        }
        sut.isSpeaking = false
        sut.speak("test")
        await fulfillment(of: [expectation], timeout: 0.1)
    }

    func test_speak_isSpeaking_true_not_executed() async {
        let expectation = XCTestExpectation(description: #function)
        expectation.isInverted = true
        let avSpeechSynthesizerMock = AVSpeechSynthesizerMock(speakExpectation: expectation)
        let sut = withDependencies {
            $0.avSpeechSynthesizer = avSpeechSynthesizerMock
        } operation: {
            SpeechSynthesizer()
        }
        sut.isSpeaking = true
        sut.speak("test")
        await fulfillment(of: [expectation], timeout: 0.1)
    }
    
    func test_stop_isSpeaking_false_not_executed() async {
        let expectation = XCTestExpectation(description: #function)
        expectation.isInverted = true
        let avSpeechSynthesizerMock = AVSpeechSynthesizerMock(stopExpectation: expectation)
        let sut = withDependencies {
            $0.avSpeechSynthesizer = avSpeechSynthesizerMock
        } operation: {
            SpeechSynthesizer()
        }
        sut.isSpeaking = false
        sut.stop()
        await fulfillment(of: [expectation], timeout: 0.1)
    }
    
    func test_stop_isSpeaking_true_executed() async {
        let expectation = XCTestExpectation(description: #function)
        let avSpeechSynthesizerMock = AVSpeechSynthesizerMock(stopExpectation: expectation)
        let sut = withDependencies {
            $0.avSpeechSynthesizer = avSpeechSynthesizerMock
        } operation: {
            SpeechSynthesizer()
        }
        sut.isSpeaking = true
        sut.stop()
        await fulfillment(of: [expectation], timeout: 0.1)
    }
    
    func test_stop_willStopSpeaking_true() {
        let sut = withDependencies {
            $0.avSpeechSynthesizer = AVSpeechSynthesizerMock()
        } operation: {
            SpeechSynthesizer()
        }
        sut.isSpeaking = true
        sut.stop()
        XCTAssertTrue(sut.willStopSpeaking)
    }
    
    func test_stop_isSpeaking_false() async {
        let expectation = XCTestExpectation(description: #function)
        let avSpeechSynthesizerMock = AVSpeechSynthesizerMock(stopExpectation: expectation)
        let sut = withDependencies {
            $0.avSpeechSynthesizer = avSpeechSynthesizerMock
        } operation: {
            SpeechSynthesizer()
        }
        sut.isSpeaking = true
        sut.stop()
        await fulfillment(of: [expectation], timeout: 0.1)
        XCTAssertFalse(sut.isSpeaking)
    }
}

private struct AVSpeechSynthesizerMock: AVSpeechSynthesizerProtocol {
    var delegate: (any AVSpeechSynthesizerDelegate)?
    var mixToTelephonyUplink = false
    
    var speakExpectation: XCTestExpectation?
    var stopExpectation: XCTestExpectation?

    func setup(delegate: any AVSpeechSynthesizerDelegate, mixToTelephonyUplink: Bool) {}
    func speak(_ utterance: AVSpeechUtterance) {
        speakExpectation?.fulfill()
    }
    func stopSpeaking(at boundary: AVSpeechBoundary) -> Bool {
        stopExpectation?.fulfill()
        return true
    }
}

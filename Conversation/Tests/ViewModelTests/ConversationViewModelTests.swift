//
//  ConversationViewModelTests.swift
//  Conversation
//
//  Created by haludoll on 2024/10/24.
//

import Testing
@testable import ConversationViewModel

struct ConversationViewModelTests {

    @Test func speak_isSpeaking_not_called() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    //    func test_didStart_isSpeaking_true() async {
    //        let sut = withDependencies {
    //            $0.avSpeechSynthesizer = AVSpeechSynthesizerMock()
    //        } operation: {
    //            SpeechSynthesizer()
    //        }
    //        XCTAssertFalse(sut.isSpeaking)
    //
    //        let expectation = XCTestExpectation(description: #function)
    //        withObservationTracking {
    //            _ = sut.isSpeaking
    //        } onChange: {
    //            expectation.fulfill()
    //        }
    //        await sut.speechDelegateAsyncChannel.send(.didStart)
    //        await fulfillment(of: [expectation], timeout: 0.1)
    //        XCTAssertTrue(sut.isSpeaking)
    //    }
    //
    //    func test_didFinish_isSpeaking_true() async {
    //        let sut = withDependencies {
    //            $0.avSpeechSynthesizer = AVSpeechSynthesizerMock()
    //        } operation: {
    //            SpeechSynthesizer()
    //        }
    //        await sut.speechDelegateAsyncChannel.send(.didStart)
    //
    //        let expectation = XCTestExpectation(description: #function)
    //        withObservationTracking {
    //            _ = sut.isSpeaking
    //        } onChange: {
    //            expectation.fulfill()
    //        }
    //        await sut.speechDelegateAsyncChannel.send(.didFinish)
    //        await fulfillment(of: [expectation], timeout: 0.1)
    //        XCTAssertFalse(sut.isSpeaking)
    //    }
    //
    //    func test_didFinish_text_empty() async {
    //        let sut = withDependencies {
    //            $0.avSpeechSynthesizer = AVSpeechSynthesizerMock()
    //        } operation: {
    //            SpeechSynthesizer()
    //        }
    //        sut.text = "test"
    //
    //        let expectation = XCTestExpectation(description: #function)
    //        withObservationTracking {
    //            _ = sut.text
    //        } onChange: {
    //            expectation.fulfill()
    //        }
    //        await sut.speechDelegateAsyncChannel.send(.didFinish)
    //        await fulfillment(of: [expectation], timeout: 0.1)
    //        XCTAssertTrue(sut.text.isEmpty)
    //    }
    //
    //    func test_didCancel_willStopSpeaking_false() async {
    //        let sut = withDependencies {
    //            $0.avSpeechSynthesizer = AVSpeechSynthesizerMock()
    //        } operation: {
    //            SpeechSynthesizer()
    //        }
    //        sut.willStopSpeaking = true
    //
    //        let expectation = XCTestExpectation(description: #function)
    //        withObservationTracking {
    //            _ = sut.willStopSpeaking
    //        } onChange: {
    //            expectation.fulfill()
    //        }
    //
    //        await sut.speechDelegateAsyncChannel.send(.didCancel)
    //        await fulfillment(of: [expectation], timeout: 0.1)
    //        XCTAssertFalse(sut.willStopSpeaking)
    //    }
    //
    //    func test_speak_isSpeaking_false_executed() async {
    //        let expectation = XCTestExpectation(description: #function)
    //        let avSpeechSynthesizerMock = AVSpeechSynthesizerMock(speakExpectation: expectation)
    //        let sut = withDependencies {
    //            $0.avSpeechSynthesizer = avSpeechSynthesizerMock
    //        } operation: {
    //            SpeechSynthesizer()
    //        }
    //        sut.text = "test"
    //        sut.isSpeaking = false
    //        sut.speak()
    //        await fulfillment(of: [expectation], timeout: 0.1)
    //    }
    //
    //    func test_speak_isSpeaking_true_not_executed() async {
    //        let expectation = XCTestExpectation(description: #function)
    //        expectation.isInverted = true
    //        let avSpeechSynthesizerMock = AVSpeechSynthesizerMock(speakExpectation: expectation)
    //        let sut = withDependencies {
    //            $0.avSpeechSynthesizer = avSpeechSynthesizerMock
    //        } operation: {
    //            SpeechSynthesizer()
    //        }
    //        sut.text = "test"
    //        sut.isSpeaking = true
    //        sut.speak()
    //        await fulfillment(of: [expectation], timeout: 0.1)
    //    }
    //
    //    func test_stop_isSpeaking_false_not_executed() async {
    //        let expectation = XCTestExpectation(description: #function)
    //        expectation.isInverted = true
    //        let avSpeechSynthesizerMock = AVSpeechSynthesizerMock(stopExpectation: expectation)
    //        let sut = withDependencies {
    //            $0.avSpeechSynthesizer = avSpeechSynthesizerMock
    //        } operation: {
    //            SpeechSynthesizer()
    //        }
    //        sut.isSpeaking = false
    //        sut.stop()
    //        await fulfillment(of: [expectation], timeout: 0.1)
    //    }
    //
    //    func test_stop_isSpeaking_true_executed() async {
    //        let expectation = XCTestExpectation(description: #function)
    //        let avSpeechSynthesizerMock = AVSpeechSynthesizerMock(stopExpectation: expectation)
    //        let sut = withDependencies {
    //            $0.avSpeechSynthesizer = avSpeechSynthesizerMock
    //        } operation: {
    //            SpeechSynthesizer()
    //        }
    //        sut.isSpeaking = true
    //        sut.stop()
    //        await fulfillment(of: [expectation], timeout: 0.1)
    //    }
    //
    //    func test_stop_isSpeaking_false() async {
    //        let expectation = XCTestExpectation(description: #function)
    //        let avSpeechSynthesizerMock = AVSpeechSynthesizerMock(stopExpectation: expectation)
    //        let sut = withDependencies {
    //            $0.avSpeechSynthesizer = avSpeechSynthesizerMock
    //        } operation: {
    //            SpeechSynthesizer()
    //        }
    //        sut.isSpeaking = true
    //        sut.stop()
    //        await fulfillment(of: [expectation], timeout: 0.1)
    //        XCTAssertFalse(sut.isSpeaking)
    //    }
    
}

//private struct AVSpeechSynthesizerMock: AVSpeechSynthesizerProtocol {
//    var delegate: (any AVSpeechSynthesizerDelegate)?
//    var mixToTelephonyUplink = false
//
//    var speakExpectation: XCTestExpectation?
//    var stopExpectation: XCTestExpectation?
//
//    func setup(delegate: any AVSpeechSynthesizerDelegate, mixToTelephonyUplink: Bool) {}
//    func speak(_ utterance: AVSpeechUtterance) {
//        speakExpectation?.fulfill()
//    }
//    func stopSpeaking(at boundary: AVSpeechBoundary) -> Bool {
//        stopExpectation?.fulfill()
//        return true
//    }
//}

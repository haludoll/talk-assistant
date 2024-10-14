//
//  SpeechSynthesizerTests.swift
//  SpeechSynthesizer
//
//  Created by haludoll on 2024/10/13.
//

import XCTest
import AVFoundation
@testable import SpeechSynthesizer

@Observable
@MainActor
final class SpeechSynthesizerTests: XCTestCase {
    func testDidStart_isSpeaking_true() async {
        let sut = SpeechSynthesizer()
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

    func testDidFinish_isSpeaking_true() async {
        let sut = SpeechSynthesizer()
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

    func testDidFinish_text_empty() async {
        let sut = SpeechSynthesizer()
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
}

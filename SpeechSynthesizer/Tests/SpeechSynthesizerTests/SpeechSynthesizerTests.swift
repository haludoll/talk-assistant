//
//  SpeechSynthesizerTests.swift
//  SpeechSynthesizer
//
//  Created by haludoll on 2024/10/13.
//

import Testing
import SpeechSynthesizer

struct SpeechSynthesizerTests {
    @Test func didStart() async throws {
        let speechSynthesizer = SpeechSynthesizer()
        speechSynthesizer.speechSynthesizer(<#T##AVSpeechSynthesizer#>, didStart: <#T##AVSpeechUtterance#>)
    }

}

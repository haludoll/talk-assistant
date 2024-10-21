//
//  PhraseTextField.swift
//  Conversation
//
//  Created by haludoll on 2024/10/10.
//

import SwiftUI

struct PhraseTextField: View {
    @Binding var text: String
    let isSpeaking: Bool
    let playButtonTapped: () -> Void
    let stopButtonTapped: () -> Void
    private var _onSubmit: (String) -> Void = { _ in }

    init(text: Binding<String>, isSpeaking: Bool, playButtonTapped: @escaping () -> Void, stopButtonTapped: @escaping () -> Void) {
        self._text = text
        self.isSpeaking = isSpeaking
        self.playButtonTapped = playButtonTapped
        self.stopButtonTapped = stopButtonTapped
    }

    var body: some View {
        HStack(spacing: 4) {
            Button {
                isSpeaking ? stopButtonTapped() : playButtonTapped()
            } label: {
                Image(systemName: isSpeaking ? "stop.circle.fill" : "play.circle.fill")
                    .font(.title)
                    .foregroundStyle(.white, isSpeaking ? .pink :  Color.accentColor)
            }

            TextField("",
                      text: $text,
                      prompt: Text("Type to Speak…", bundle: .module).foregroundStyle(.white.opacity(0.4)),
                      axis: .vertical)
                .bold()
                .foregroundStyle(.white)
                .font(.title3)
                .submitLabel(.done)
                .onNewlineBroken(of: text) { _, _ in
                    text.removeLast()
                    _onSubmit(text)
                }
        }
        .padding()
        .background(MaterialView(.systemThinMaterialDark))
        .cornerRadius(16)
    }

    func onSubmit(_ action: @escaping (String) -> Void) -> some View {
        var `self` = self
        `self`._onSubmit = action
        return `self`
    }
}

private extension View {
    func onNewlineBroken(of value: String, initial: Bool = false, _ action: @escaping (_ oldValue: String, _ newValue: String) -> Void) -> some View {
        onChange(of: value, initial: initial) { old, new in
            if new.last?.isNewline == .some(true) {
                action(old, new)
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    @Previewable @State var text1 = ""
    @Previewable @State var text2 = "If you enter a long sentence, the text field will break lines like this."

    PhraseTextField(text: $text1, isSpeaking: false, playButtonTapped: {}, stopButtonTapped: {})
    PhraseTextField(text: $text2, isSpeaking: true, playButtonTapped: {}, stopButtonTapped: {})
}

private struct MaterialView: UIViewRepresentable {
    let material: UIBlurEffect.Style

    init(_ material: UIBlurEffect.Style) {
        self.material = material
    }

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: material))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: material)
    }
}

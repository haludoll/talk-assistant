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
    private var _onSubmit: (String) -> Void = { _ in }

    init(text: Binding<String>, isSpeaking: Bool) {
        self._text = text
        self.isSpeaking = isSpeaking
    }

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: isSpeaking ? "pause.circle.fill" : "waveform.circle.fill")
                .font(.largeTitle)
                .foregroundStyle(.white, isSpeaking ? .pink :  Color.accentColor)

            ZStack(alignment: .leading) {
                TextField("", text: $text, prompt: Text("Type to Speak…", bundle: .module).foregroundStyle(.white.opacity(0.4)), axis: .vertical)
                    .bold()
                    .foregroundStyle(.white)
                    .font(.title3)
                    .disabled(isSpeaking)
                    .submitLabel(.done)
                    .onChange(of: text) { _ in
                        if text.last?.isNewline == .some(true) {
                            text.removeLast()
                            _onSubmit(text)
                        }
                    }
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

#Preview(traits: .sizeThatFitsLayout) {
    @Previewable @State var text1 = ""
    @Previewable @State var text2 = "If you enter a long sentence, the text field will break lines like this."

    PhraseTextField(text: $text1, isSpeaking: false)
    PhraseTextField(text: $text2, isSpeaking: true)
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

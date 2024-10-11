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
                    .onSubmit {
                        // TODO: Call back to speech
                        print("speech: ", text)
                        text = ""
                    }
            }
        }
        .padding()
        .background(MaterialView(.systemThinMaterialDark))
        .cornerRadius(16)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    @Previewable @State var text1 = ""
    @Previewable @State var text2 = "長い文章を入力するとこのように改行されるテキストフィールドになります"

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

//
//  PhraseTextField.swift
//  Conversation
//
//  Created by haludoll on 2024/10/10.
//

import SwiftUI
import ConversationViewModel

struct PhraseTextField: View {
    var conversationViewModel: ConversationViewModel
    let focused: FocusState<Bool>.Binding

    init(conversationViewModel: ConversationViewModel, focused: FocusState<Bool>.Binding) {
        self.conversationViewModel = conversationViewModel
        self.focused = focused
    }

    var body: some View {
        HStack(spacing: 0) {
            Button {
                conversationViewModel.isSpeaking ? conversationViewModel.stop() : conversationViewModel.speak()
            } label: {
                Image(systemName: conversationViewModel.isSpeaking ? "stop.circle.fill" : "play.circle.fill")
                    .font(.title)
                    .foregroundStyle(.white, conversationViewModel.isSpeaking ? .pink : .blue)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 8)
                    .contentShape(.rect)
            }
            .disabled(conversationViewModel.text.isEmpty)
            .buttonStyle(.plain)

            TextField("",
                      text: .init(get: { conversationViewModel.text },
                                  set: { conversationViewModel.text = $0 }),
                      prompt: Text("Type to Speak…", bundle: .module).foregroundStyle(.white.opacity(0.4)),
                      axis: .vertical)
            .bold()
            .foregroundStyle(.white)
            .font(.title3)
            .submitLabel(.done)
            .focused(focused)
            .onNewlineBroken(of: conversationViewModel.text) { _, _ in
                conversationViewModel.text.removeAll(where: \.isNewline)
                conversationViewModel.speak()
            }

            if !conversationViewModel.text.isEmpty {
                Button {
                    conversationViewModel.text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.white)
                        .opacity(0.8)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                }
            }
        }
        .padding(8)
        .background(MaterialView(.systemThinMaterialDark))
        .cornerRadius(16)
    }
}

private extension View {
    func onNewlineBroken(of value: String, initial: Bool = false, _ action: @escaping (_ oldValue: String, _ newValue: String) -> Void) -> some View {
        onChange(of: value, initial: initial) { old, new in
            if new.contains(where: \.isNewline) {
                action(old, new)
            }
        }
    }
}

#Preview {
    @Previewable @State var conversationViewModel1 = ConversationViewModel()

    PhraseTextField(conversationViewModel: conversationViewModel1, focused: FocusState<Bool>.init().projectedValue)
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

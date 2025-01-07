//
//  PhraseTextField.swift
//  Conversation
//
//  Created by haludoll on 2024/10/10.
//

import SwiftUI
import ConversationViewModel

struct PhraseTextField: View {
    var phraseSpeakViewModel: PhraseSpeakViewModel
    let focused: FocusState<Bool>.Binding

    init(phraseSpeakViewModel: PhraseSpeakViewModel, focused: FocusState<Bool>.Binding) {
        self.phraseSpeakViewModel = phraseSpeakViewModel
        self.focused = focused
    }

    var body: some View {
        HStack(spacing: 0) {
            Button {
                phraseSpeakViewModel.isSpeaking ? phraseSpeakViewModel.stop() : phraseSpeakViewModel.speak()
            } label: {
                Image(systemName: phraseSpeakViewModel.isSpeaking ? "stop.circle.fill" : "play.circle.fill")
                    .font(.title)
                    .foregroundStyle(.white, phraseSpeakViewModel.isSpeaking ? .pink : .blue)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 8)
                    .contentShape(.rect)
            }
            .disabled(phraseSpeakViewModel.text.isEmpty)
            .buttonStyle(.plain)

            TextField("",
                      text: .init(get: { phraseSpeakViewModel.text },
                                  set: { phraseSpeakViewModel.text = $0 }),
                      prompt: Text("Type to Speak…", bundle: .module).foregroundStyle(.white.opacity(0.4)),
                      axis: .vertical)
            .bold()
            .foregroundStyle(.white)
            .font(.title3)
            .submitLabel(.done)
            .focused(focused)
            .onNewlineBroken(of: phraseSpeakViewModel.text) { _, _ in
                phraseSpeakViewModel.text.removeAll(where: \.isNewline)
                phraseSpeakViewModel.speak()
            }
            .padding(.vertical, 8)

            if !phraseSpeakViewModel.text.isEmpty {
                Button {
                    phraseSpeakViewModel.text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.white)
                        .opacity(0.8)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 4)
                }
                .disabled(phraseSpeakViewModel.isSpeaking)
                .opacity(phraseSpeakViewModel.isSpeaking ? 0.5 : 1.0)
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
    @Previewable @State var phraseSpeakViewModel = PhraseSpeakViewModel()

    PhraseTextField(phraseSpeakViewModel: phraseSpeakViewModel, focused: FocusState<Bool>.init().projectedValue)
        .padding()
        .blurNavigationBar()
}

extension View {
    @ViewBuilder
    func blurNavigationBar() -> some View {
        ZStack(alignment: .bottom) {
            BlurBackgroundView()
            self
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct BlurBackgroundView: View {
    let maxHeight: CGFloat = 100

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color(.systemGroupedBackground)
                    .frame(maxWidth: .infinity, maxHeight: maxHeight)

                LinearGradient(
                    gradient: Gradient(colors: [.black.opacity(0), .black]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .blendMode(.destinationOut)
                .frame(maxWidth: .infinity, maxHeight: maxHeight)
            }
            .compositingGroup()
            .frame(maxHeight: maxHeight)
            .allowsHitTesting(false)

            Color(.systemGroupedBackground)
                .frame(height: 80)
        }
    }
}

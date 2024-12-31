//
//  PhraseTextField.swift
//  Conversation
//
//  Created by haludoll on 2024/10/10.
//

import SwiftUI
import ConversationViewModel

struct PhraseTextField: View {
    var TypeToSpeakViewModel: TypeToSpeakViewModel
    let focused: FocusState<Bool>.Binding

    init(typeToSpeakViewModel: TypeToSpeakViewModel, focused: FocusState<Bool>.Binding) {
        self.TypeToSpeakViewModel = typeToSpeakViewModel
        self.focused = focused
    }

    var body: some View {
        HStack(spacing: 0) {
            Button {
                TypeToSpeakViewModel.isSpeaking ? TypeToSpeakViewModel.stop() : TypeToSpeakViewModel.speak()
            } label: {
                Image(systemName: TypeToSpeakViewModel.isSpeaking ? "stop.circle.fill" : "play.circle.fill")
                    .font(.title)
                    .foregroundStyle(.white, TypeToSpeakViewModel.isSpeaking ? .pink : .blue)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 8)
                    .contentShape(.rect)
            }
            .disabled(TypeToSpeakViewModel.text.isEmpty)
            .buttonStyle(.plain)

            TextField("",
                      text: .init(get: { TypeToSpeakViewModel.text },
                                  set: { TypeToSpeakViewModel.text = $0 }),
                      prompt: Text("Type to Speak…", bundle: .module).foregroundStyle(.white.opacity(0.4)),
                      axis: .vertical)
            .bold()
            .foregroundStyle(.white)
            .font(.title3)
            .submitLabel(.done)
            .focused(focused)
            .onNewlineBroken(of: TypeToSpeakViewModel.text) { _, _ in
                TypeToSpeakViewModel.text.removeAll(where: \.isNewline)
                TypeToSpeakViewModel.speak()
            }
            .padding(.vertical, 8)

            if !TypeToSpeakViewModel.text.isEmpty {
                Button {
                    TypeToSpeakViewModel.text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.white)
                        .opacity(0.8)
                        .padding(.horizontal, 4)
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
    @Previewable @State var conversationViewModel = TypeToSpeakViewModel()

    ZStack(alignment: .bottom) {
        Color(.systemBackground)
            .blurNavigationBar()

        PhraseTextField(typeToSpeakViewModel: conversationViewModel, focused: FocusState<Bool>.init().projectedValue)
            .padding()
    }
}

extension View {
    @ViewBuilder
    public func blurNavigationBar() -> some View {
        ZStack(alignment: .bottom) {
            self
            BlurBackgroundView()
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

public struct BlurBackgroundView: View {
    public init() {}

    let maxHeight: CGFloat = 140

    public var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Color(.systemBackground)
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

            Color(.systemBackground)
                .frame(height: 100)
        }
    }
}

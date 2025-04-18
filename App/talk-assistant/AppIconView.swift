//
//  AppIconView.swift
//  talk-assistant
//
//  Created by haludoll on 2025/01/27.
//

import SwiftUI
import Photos

struct AppIconView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.white)

            HStack(spacing: 80) {
                Circle()
                    .foregroundStyle(Color.accentColor)
                    .opacity(0.6)
                RoundedRectangle(cornerSize: .init(width: 500, height: 500))
                    .padding(.vertical, 180)
                    .foregroundStyle(Color.accentColor)
                    .opacity(0.7)
                RoundedRectangle(cornerSize: .init(width: 500, height: 500))
                    .foregroundStyle(Color.accentColor)
                    .opacity(0.8)
                RoundedRectangle(cornerSize: .init(width: 500, height: 500))
                    .foregroundStyle(Color.accentColor)
                    .padding(.vertical, 180)
                    .opacity(0.7)
                Circle()
                    .foregroundStyle(Color.accentColor)
                    .opacity(0.6)
            }
            .shadow(color: .accentColor, radius: 20)
            .padding(130)
        }
    }
}

#Preview {
    VStack {
        AppIconView()
            .frame(width: 1024, height: 1024)
            .scaleEffect(0.2)
    }
    .background(Color.black)
}

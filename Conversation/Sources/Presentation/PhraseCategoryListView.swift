//
//  PhraseCategoryListView.swift
//  Conversation
//
//  Created by haludoll on 2024/12/06.
//

import SwiftUI

struct PhraseCategoryListView: View {
    @State private var showingPhraseCategoryCreateView = false

    var body: some View {
        List {
            ForEach(0..<10) { i in
                Label("Name", systemImage: "house")
            }
        }
        .navigationTitle(Text("Category List", bundle: .module))
        .toolbar {
            ToolbarItem {
                Button("", systemImage: "folder.badge.plus") {
                    showingPhraseCategoryCreateView.toggle()
                }
            }
        }
        .sheet(isPresented: $showingPhraseCategoryCreateView) {
            PhraseCategoryCreateView()
        }
    }
}

#Preview {
    NavigationStack {
        PhraseCategoryListView()
    }
}

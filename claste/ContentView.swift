//
//  ContentView.swift
//  claste
//
//  Created by Scott Opell on 4/13/24.
//

import SwiftUI

import AppKit

struct ContentView: View {
    @ObservedObject var clipboardManager = ClipboardManager()
    
    var body: some View {
        let clipboardItems = clipboardManager.clipboardContent.sorted { $0.key < $1.key }
        let previewableItems = clipboardItems.filter { $0.value.isPreviewable }
        let unPreviewableItems = clipboardItems.filter { !$0.value.isPreviewable }


        VStack {
                        List {
                            Section(header: Text("Previewable Items")) {
                                ForEach(previewableItems, id: \.key) { (_, item) in
                                    VStack(alignment: .leading) {
                                        Text(item.type.rawValue).font(.headline)
                                        
                                        switch item.preview {
                                        case .unsupported:
                                            Text("uhh, it said it was previewable, but it actually wasn't. Probably non-utf8 string").font(.caption)
                                        case .text(let text):
                                            ExpandableTextView(text: text)
                                        case .image(let image):
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 200)
                                        case .textAndImage(let text, let image):
                                            VStack {
                                                ExpandableTextView(text: text)
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: 200)
                                            }
                                        }
                                    }
                                }
                            }
                            Section(header: Text("Non-Previewable Items")) {
                                ForEach(unPreviewableItems, id: \.key) { (_, item) in
                                    VStack(alignment: .leading) {
                                        Text(item.type.rawValue).font(.headline)
                                    }
                                }
                            }
                        }
                        .listStyle(SidebarListStyle())
            Button("Refresh Clipboard") {
                clipboardManager.updateClipboardContent()
            }
            .padding()
        }
        .frame(minWidth: 400, minHeight: 300)
    }
}

#Preview {
    ContentView()
}

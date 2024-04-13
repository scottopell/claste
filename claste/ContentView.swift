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
        VStack {
            List {
                ForEach(Array(clipboardManager.clipboardContent.keys.sorted()), id: \.self) { key in
                    VStack(alignment: .leading) {
                        Text(key).font(.headline)
                        switch clipboardManager.clipboardContent[key] {
                        case let image as Image:
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                        case let string as String:
                            ExpandableTextView(text: string)
                            /*
                            Text(string)
                                .font(.subheadline)
                                .foregroundColor(.gray)*/
                        default:
                            Text("Unsupported data type")
                                .foregroundColor(.red)
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

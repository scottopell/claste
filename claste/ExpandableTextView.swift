//
//  ExpandableTextView.swift
//  claste
//
//  Created by Scott Opell on 4/13/24.
//

import Foundation

import SwiftUI

struct ExpandableTextView: View {
    let text: String
    @State private var isExpanded = false
    
    init(text: String, isExpanded: Bool? = nil) {
        self.text = text
        if let isExpanded = isExpanded {
            _isExpanded = State(initialValue: isExpanded)
        }
    }
    
    var body: some View {
        Grid(alignment: .leading) {
            GridRow {
                Text(text)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button(isExpanded ? "Collapse" : "Expand") {
                    isExpanded.toggle()
                }
                .buttonStyle(.bordered)
                .padding(.top, 5)
            }
            if isExpanded {
                GridRow {
                    TextEditor(text: .constant(text))
                        .frame(minHeight: 100, maxHeight: 300)
                        .border(Color.gray, width: 1)
                        .padding(6)
                }
            }
        }
    }
}

#Preview {
    VStack {
        ExpandableTextView(text: "<xml :? blah blah></xml>", isExpanded: false)
        ExpandableTextView(text: "hello world", isExpanded: true)
    }
}

//
//  ClipboardManager.swift
//  claste
//
//  Created by Scott Opell on 4/13/24.
//

import SwiftUI
import AppKit
import PDFKit

enum PreviewContent {
    case unsupported
    case text(String)
    case image(Image)
    case textAndImage(String, Image)
}

struct ClipboardItem {
    var type: NSPasteboard.PasteboardType
    var data: Data

    var isPreviewable: Bool {
        switch type {
        case .string, .pdf, .tiff:

            // todo check if data is utf8-encoded
            /*
            if let string = String(data: data, encoding: .utf8) {
                return .text(string)
            }
            */
            return true
        default:
            return false
        }
    }
    
    var preview: PreviewContent {
        switch type {
        case .tiff:
            if let image = NSImage(data: data) {
                return .image(Image(nsImage: image))
            }
        case .pdf:
            if let pdfDocument = PDFDocument(data: data) {
                let pageCount = pdfDocument.pageCount
                let firstPage = pdfDocument.page(at: 0)?.thumbnail(of: NSSize(width: 240, height: 300), for: .mediaBox)
                let result = "PDF with \(pageCount) pages"
                if let image = firstPage {
                    return .textAndImage(result, Image(nsImage: image))
                }
                return .text(result)
            } else {
                return .text("Failed to load PDF")
            }
        default:
            if let string = String(data: data, encoding: .utf8) {
                return .text(string)
            }
            return .unsupported
        }
        return .text("Impossible condition! Panic!!")}
    
    init(type: NSPasteboard.PasteboardType, data: Data) {
        self.type = type
        self.data = data
    }
}

class ClipboardManager: ObservableObject {
    @Published var clipboardContent: [String: ClipboardItem] = [:]
    
    init() {
        updateClipboardContent()
    }
    
    func updateClipboardContent() {
        let pasteboard = NSPasteboard.general
        clipboardContent.removeAll()
        
        pasteboard.types?.forEach { type in
            if let data = pasteboard.data(forType: type) {
                let item = ClipboardItem(type: type, data: data)
                clipboardContent[type.rawValue] = item;
            } else {
                // todo better "couldn't get data" type
                clipboardContent[type.rawValue] = ClipboardItem(type: type, data: Data(count: 2))
            }
        }
    }
}

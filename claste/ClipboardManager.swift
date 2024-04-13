//
//  ClipboardManager.swift
//  claste
//
//  Created by Scott Opell on 4/13/24.
//

import SwiftUI
import AppKit
import PDFKit


class ClipboardManager: ObservableObject {
    @Published var clipboardContent: [String: Any] = [:]
    
    init() {
        updateClipboardContent()
    }
    
    func updateClipboardContent() {
        let pasteboard = NSPasteboard.general
        clipboardContent.removeAll()
        
        pasteboard.types?.forEach { type in
            if let data = pasteboard.data(forType: type) {
                if type == .tiff, let image = NSImage(data: data) {
                    clipboardContent[type.rawValue] = Image(nsImage: image)
                } else if type == .pdf {
                    if let pdfDocument = PDFDocument(data: data) {
                        let pageCount = pdfDocument.pageCount
                        let firstPage = pdfDocument.page(at: 0)?.thumbnail(of: NSSize(width: 240, height: 300), for: .mediaBox)
                        clipboardContent[type.rawValue] = "PDF with \(pageCount) pages"
                        if let image = firstPage {
                            clipboardContent["PDF Preview"] = Image(nsImage: image)
                        }
                    } else {
                        clipboardContent[type.rawValue] = "Failed to load PDF"
                    }
                } else if let string = String(data: data, encoding: .utf8) {
                    clipboardContent[type.rawValue] = string
                } else {
                    clipboardContent[type.rawValue] = "Data of type \(type.rawValue) cannot be displayed as text"
                }
            } else {
                clipboardContent[type.rawValue] = "No readable data available for type \(type.rawValue)"
            }
        }
    }
}

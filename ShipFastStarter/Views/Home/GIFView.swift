//
//  GIFView.swift
//  ShipFastStarter
//
//  Created for displaying GIF animations
//

import SwiftUI
import WebKit

// A SwiftUI wrapper for a WKWebView that can display GIFs
struct GIFView: UIViewRepresentable {
    let gifName: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        // Configure webView for proper display
        webView.backgroundColor = .clear
        webView.isOpaque = false
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        
        // Disable white flashing when loading
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        webView.scrollView.backgroundColor = UIColor.clear
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let gifURL = Bundle.main.url(forResource: gifName, withExtension: "gif") {
            // Create HTML to display the GIF properly, ensuring it fits to screen width without zoom
            let html = """
            <!DOCTYPE html>
            <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
                <style>
                    body, html { margin: 0; padding: 0; overflow: hidden; background: transparent; }
                    body { background-color: transparent; }
                    img { width: 100%; height: 100%; object-fit: cover; display: block; }
                </style>
            </head>
            <body>
                <img src="\(gifURL.absoluteString)" />
            </body>
            </html>
            """
            
            // Load HTML with transparent background settings
            webView.loadHTMLString(html, baseURL: gifURL.deletingLastPathComponent())
        }
    }
}

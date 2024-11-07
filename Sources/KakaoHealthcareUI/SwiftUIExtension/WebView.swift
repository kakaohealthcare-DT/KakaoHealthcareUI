//
//  WebView.swift
//  UIExtension
//
//  Created by bryn on 2/27/24.
//  Copyright © 2024 Kakao Healthcare Corp. All rights reserved.
//

import SwiftUI
import WebKit
import SnapKit

public struct WebView: UIViewRepresentable {
	let urlstring: String
	let activityIndicator = UIActivityIndicatorView(style: .large)
	let errorLabel = UILabel()
	let webview = WKWebView()
	@State private var errorText: String = ""
	
	public init(urlstring: String) {
		self.urlstring = urlstring
	}
	
	public func makeUIView(context: Context) -> WKWebView {
		webview.addSubview(activityIndicator)
		webview.addSubview(errorLabel)
		
		activityIndicator.startAnimating()
		activityIndicator.snp.makeConstraints { make in
			make.center.equalToSuperview()
		}
		
		errorLabel.snp.makeConstraints { make in
			make.center.equalToSuperview()
		}
		
		errorLabel.text = errorText
		errorLabel.textColor = .gray
		
		guard let url = URL(string: self.urlstring) else {
			return webview
		}
		
		webview.load(URLRequest(url: url))
		return webview
	}
	
	public func updateUIView(_ uiView: WKWebView, context: Context) {
		uiView.navigationDelegate = context.coordinator
		
		errorLabel.text = errorText
	}
	
	public func makeCoordinator() -> Coordinator {
		Coordinator(parent: self)
	}
	
	public class Coordinator: NSObject, WKNavigationDelegate {
		var parent: WebView
		
		init(parent: WebView) {
			self.parent = parent
		}
		
		// swiftlint:disable:next implicitly_unwrapped_optional
		public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
			parent.activityIndicator.stopAnimating()
		}
		
		// swiftlint:disable:next implicitly_unwrapped_optional
		public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
			parent.errorText = "Please try again later"
			parent.activityIndicator.stopAnimating()
		}
		
		// swiftlint:disable:next implicitly_unwrapped_optional
		public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
			parent.errorText = "Please try again later"
			parent.activityIndicator.stopAnimating()
		}
	}
}

#Preview {
	WebView(urlstring: "https://kakaohealthcare.com/")
}

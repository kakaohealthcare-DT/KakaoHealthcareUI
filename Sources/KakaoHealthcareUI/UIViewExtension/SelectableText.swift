import SwiftUI
import UIKit

public struct SelectableText: UIViewRepresentable {
	private var text: String
	private var font: UIFont
	private var isScrollEnabled: Bool
	
	public init(
		text: String,
		font: UIFont = .systemFont(ofSize: 15),
		isScrollEnabled: Bool = true
	) {
		self.text = text
		self.font = font
		self.isScrollEnabled = isScrollEnabled
	}
	
	public func makeUIView(context: Context) -> UITextView {
		let textView = UITextView()
		textView.textContainerInset = .zero
		textView.isEditable = false
		textView.isScrollEnabled = isScrollEnabled
		textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
		textView.text = text
		textView.font = font
		textView.backgroundColor = .clear
		return textView
	}
	
	public func updateUIView(_ uiView: UITextView, context: Context) {
		uiView.text = text
		uiView.font = font
		uiView.isScrollEnabled = isScrollEnabled
	}
	
	public static func calculateTextHeight(
		_ proxy: GeometryProxy,
		text: String,
		font: UIFont
	) -> CGFloat {
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineSpacing = 4
		let total = text.boundingRect(
			with: CGSize(width: proxy.size.width, height: .greatestFiniteMagnitude),
			options: [.usesLineFragmentOrigin],
			attributes: [
				.font: font,
				.paragraphStyle: paragraphStyle
			],
			context: nil
		)
		
		return total.height + font.lineHeight
	}
}

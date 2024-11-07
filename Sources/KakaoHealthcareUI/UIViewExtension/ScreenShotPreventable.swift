import Foundation
import UIKit

public protocol ScreenShotPreventable {
	func preventScreenShot(for callable: UIViewCallable)
}

public extension ScreenShotPreventable where Self: UIKit.UIView {
	func preventScreenShot(for callable: UIViewCallable) {
		let view = callable.uiView
		let textField = UITextField()
		textField.isSecureTextEntry = true
		textField.isUserInteractionEnabled = false
		guard let hiddenView = textField.layer.sublayers?.first?.delegate as? UIView else {
			return
		}
		
		hiddenView.subviews.forEach { $0.removeFromSuperview() }
		hiddenView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(hiddenView)
		NSLayoutConstraint.activate([
			hiddenView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			hiddenView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			hiddenView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			hiddenView.topAnchor.constraint(equalTo: self.topAnchor)
		])
		hiddenView.addSubview(view)
	}
}

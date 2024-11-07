import Foundation
import UIKit
import SwiftUI

public protocol UIViewCallable {
	var uiView: UIView { get }
}

public extension UIViewCallable where Self: UIKit.UIView {
	var uiView: UIView { self }
}

public extension UIViewCallable where Self: SwiftUI.View {
	var uiView: UIView {
		let hostingVC = UIHostingController(rootView: self)
		return hostingVC.view
	}
}

extension UIView: UIViewCallable { }

import UIKit

public protocol Fadable {
	func hide(_ time: TimeInterval)
	func show(_ time: TimeInterval, _ after: TimeInterval, _ completion: (() -> Void)?)
}

public extension Fadable where Self: UIView {
	func hide(_ time: TimeInterval = 0.2) {
		UIView.animate(withDuration: time, animations: {
			self.alpha = 0
		}, completion: { _ in
			self.isHidden = true
		})
	}
	
	func show(_ time: TimeInterval = 0.15, _ after: TimeInterval = 0, _ completion: (() -> Void)? = nil) {
		self.isHidden = false
		UIView.animate(withDuration: time, delay: after, animations: {
			self.alpha = 1
		}) { isComplete in
			if isComplete {
				completion?()
			}
		}
	}
	
	func showAndHide(showTime: TimeInterval = 0.4, hideTime: TimeInterval = 0.2) {
		
		self.isHidden = false
		UIView.animate(withDuration: showTime, animations: {
			self.alpha = 1
		}, completion: { [weak self] _ in
			self?.hide(hideTime)
		})
	}
	
	func toTopTransition(_ duration: CFTimeInterval) {
		let animation: CATransition = CATransition()
		animation.timingFunction = CAMediaTimingFunction(
			name: CAMediaTimingFunctionName.easeInEaseOut
		)
		
		animation.type = CATransitionType.push
		animation.subtype = CATransitionSubtype.fromTop
		animation.duration = duration
		layer.add(animation, forKey: CATransitionType.push.rawValue)
	}
}

extension UIView: Fadable { }

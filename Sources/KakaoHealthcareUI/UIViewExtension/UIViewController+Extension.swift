import UIKit

public extension UIViewController {
	@discardableResult
	func body(@StackBuilder block: () -> [UIView]) -> Self {
		block().forEach({ self.view.add($0) })
		return self
	}
	
	var topMostViewController: UIViewController {
		topViewControllerWithRootViewController(self)
	}
	
	var modalTopViewController: UIViewController {
		if let viewController = presentedViewController {
			return viewController.modalTopViewController
		}
		
		return self
	}
	
	var modalTopMostViewController: UIViewController {
		if let viewController = presentedViewController {
			return viewController.modalTopViewController
		}
		
		return topMostViewController
	}
	
	func dismissAllModalViewController(completion: (() -> Void)? = nil) {
		if let viewController = presentedViewController {
			viewController.dismiss(animated: false) { [weak self] in
				self?.dismissAllModalViewController(completion: completion)
			}
		} else {
			dismiss(animated: false, completion: completion)
		}
	}
	
	private func topViewControllerWithRootViewController(
		_ rootViewController: UIViewController
	) -> UIViewController {
		guard let topViewController = UIApplication.topViewController() else {
			return rootViewController
		}
		
		return topViewController
	}
}

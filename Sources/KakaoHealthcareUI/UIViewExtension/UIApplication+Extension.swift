//
//  UIApplication+Extension.swift
//  UIExtension
//
//  Created by kyle.cha on 3/4/24.
//  Copyright © 2024 Kakao Healthcare Corp. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Using only for SwiftUI
public extension UIApplication {
	var representedKeyWindow: UIWindow? {
		self.connectedScenes
			.map { $0 as? UIWindowScene }
			.compactMap { $0 }
			.first?
			.windows
			.filter { $0.isKeyWindow }
			.first
	}
}

extension UIApplication {
	
	class func topViewController(
		_ viewController: UIViewController? = UIApplication.shared.representedKeyWindow?.rootViewController
	) -> UIViewController? {
		if let navigation = viewController as? UINavigationController {
			return topViewController(navigation.visibleViewController)
		}
		
		if let tab = viewController as? UITabBarController {
			if let selected = tab.selectedViewController {
				return topViewController(selected)
			}
		}
		
		if let presented = viewController?.presentedViewController {
			return topViewController(presented)
		}
		
		return viewController
	}
}

//
//  BaseNavigationController.swift
//  SampleUIKit
//
//  Created by kyle.cha Cha on 2023/09/29.
//

import UIKit

open class BaseNavigationController: UINavigationController {
	open override var preferredStatusBarStyle: UIStatusBarStyle {
		topViewController?.preferredStatusBarStyle ?? .default
	}
	
	override open var childForStatusBarStyle: UIViewController? {
		topViewController
	}
	
	open override func viewDidLoad() {
		super.viewDidLoad()
	}
}

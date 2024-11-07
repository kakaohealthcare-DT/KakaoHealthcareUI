//
//  TabBarModifier.swift
//  SampleUIKit
//
//  Created by kyle.cha on 10/10/23.
//

import Foundation
import SwiftUI
import UIKit

// MARK: - Using only for SwiftUI
public extension UIView {
	func allSubviews() -> [UIView] {
		var subs = self.subviews
		for subview in self.subviews {
			let rec = subview.allSubviews()
			subs.append(contentsOf: rec)
		}
		return subs
	}
}
	
public struct TabbarBackgroundModifier: ViewModifier {
	let backgroundColor: Color
	let tintColor: Color
	
	public init(backgroundColor: Color, tintColor: Color) {
		self.backgroundColor = backgroundColor
		self.tintColor = tintColor
	}
	
	public func body(content: Content) -> some View {
		if #available(iOS 16.0, *) {
			content
				.toolbar(.visible, for: .tabBar)
				.toolbarBackground(backgroundColor, for: .tabBar)
				.tint(tintColor)
				.onAppear {
					let tabBarAppearance = UITabBarAppearance()
					tabBarAppearance.configureWithOpaqueBackground()
					UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
				}
		} else {
			content
				.accentColor(tintColor)
				.onAppear {
					let appearance = UITabBarAppearance()
					let tabBar = UITabBar()
					appearance.configureWithOpaqueBackground()
					appearance.backgroundColor = UIColor(backgroundColor)
					tabBar.standardAppearance = appearance
					UITabBar.appearance().scrollEdgeAppearance = appearance
				}
		}
	}
}

//
//  NavigationBarModifier.swift
//  UIExtension
//
//  Created by bryn on 12/5/23.
//  Copyright © 2023 Kakao Healthcare Corp. All rights reserved.
//

import SwiftUI

public extension View {
	func hideNavigationBar() -> some View {
		self.modifier(NavigationBarHiddenModifier(forTabView: false))
	}
	
	func hideNavigationBarForTabView() -> some View {
		self.modifier(NavigationBarHiddenModifier(forTabView: true))
	}
}

struct NavigationBarHiddenModifier: ViewModifier {
	var forTabView: Bool
	
	func body(content: Content) -> some View {
		if #available(iOS 16.0, *) {
			content.toolbar(.hidden, for: .navigationBar)
		} else if forTabView {
			content.background(NavigationBarHiddenView())
		} else {
			content.navigationBarHidden(true)
		}
	}
}

public struct NavigationBarHiddenView: UIViewControllerRepresentable {
	public typealias UIViewControllerType = UIViewController
	
	let controller = UIViewController()
	
	public init() { }
	
	public func makeCoordinator() -> Coordinator {
		Coordinator()
	}
	
	public func makeUIViewController(context: Context) -> UIViewController {
		context.coordinator
	}
	
	public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
		
	}
	
	public class Coordinator: UIViewControllerType {
		init() {
			super.init(nibName: nil, bundle: nil)
		}
		
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
		
		public override func viewWillAppear(_ animated: Bool) {
			super.viewWillAppear(animated)
			self.navigationController?.setNavigationBarHidden(true, animated: false)
			
			DispatchQueue.main.async {
				self.navigationController?.setNavigationBarHidden(true, animated: false)
			}
		}
	}
}

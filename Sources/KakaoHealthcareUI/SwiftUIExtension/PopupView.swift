//
//  PopupView.swift
//  UIExtension
//
//  Created by bryn on 1/9/24.
//  Copyright © 2024 Kakao Healthcare Corp. All rights reserved.
//

import SwiftUI

public struct PopupView<Content: View>: UIViewControllerRepresentable {
	
	public typealias UIViewControllerType = UIViewController
	
	@Binding var isPresented: Bool
	let contentView: () -> Content
	
	public init(isPresented: Binding<Bool>, contentView: @escaping () -> Content) {
		self._isPresented = isPresented
		self.contentView = contentView
	}
	
	public func makeCoordinator() -> Coordinator {
		Coordinator(isPresented: $isPresented, content: contentView)
	}
	
	public func makeUIViewController(context: Context) -> UIViewControllerType {
		context.coordinator
	}
	
	public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
		if !isPresented {
			uiViewController.dismiss(animated: true)
		}
	}
	
	public class Coordinator: UIViewController {
		@Binding var isPresented: Bool
		let contentView: () -> Content
		
		init(isPresented: Binding<Bool>, content: @escaping () -> Content) {
			self._isPresented = isPresented
			self.contentView = content
			super.init(nibName: nil, bundle: nil)
		}
		
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
		
		public override func viewWillAppear(_ animated: Bool) {
			super.viewWillAppear(animated)
			
			let content = UIHostingController(rootView: self.contentView())
			let newVC = UIViewController()
			newVC.view.backgroundColor = .black.withAlphaComponent(0.5)
			newVC.modalPresentationStyle = .overFullScreen
			newVC.modalTransitionStyle = .crossDissolve
			
			newVC.view.add(content.view) {
				$0.backgroundColor = .clear
				$0.snp.makeConstraints { make in
					make.center.equalToSuperview()
				}
			}
			
			self.view.backgroundColor = .clear
			
			let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
			newVC.view.addGestureRecognizer(tapGesture)
			self.present(newVC, animated: true)
		}
		
		public override func viewWillDisappear(_ animated: Bool) {
			super.viewWillDisappear(animated)
			
			self.presentedViewController?.dismiss(animated: true)
		}
		
		@objc func backgroundTapped() {
			self.isPresented = false
		}
	}
}

public struct PopupModifier<PopupContent: View>: ViewModifier {
	
	@Binding var isPresented: Bool
	let popupContent: () -> PopupContent
	
	public init(isPresented: Binding<Bool>, popupContent: @escaping () -> PopupContent) {
		self._isPresented = isPresented
		self.popupContent = popupContent
	}
	
	public func body(content: Content) -> some View {
		content
			.background(
				Group {
					if isPresented {
						Color.clear.overlay(
							PopupView(isPresented: $isPresented, contentView: popupContent)
						)
						.transition(.opacity)
					}
				}
			)
	}
}

public extension View {
	func popup<PopupContent: View>(
		isPresented: Binding<Bool>,
		@ViewBuilder popupContent: @escaping () -> PopupContent
	) -> some View {
		self.modifier(PopupModifier(isPresented: isPresented, popupContent: popupContent))
	}
}

//
//  SheetProvider.swift
//  UIExtension
//
//  Created by bryn on 1/25/24.
//  Copyright © 2024 Kakao Healthcare Corp. All rights reserved.
//

import SwiftUI

struct SheetProvider<Item, Content: View>: UIViewControllerRepresentable {
	
	@Binding var item: Item?
	
	var sheetView: (Item) -> Content
	let controller: UIViewController
	
	init(item: Binding<Item?>, @ViewBuilder sheetView: @escaping (Item) -> Content) {
		self._item = item
		self.sheetView = sheetView
		self.controller = UIViewController()
	}
	
	func makeUIViewController(context: Context) -> UIViewController {
		controller.view.backgroundColor = .clear
		return controller
	}
	
	func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
		if let item {
			let sheetController = SheetHostingController(rootView: sheetView(item))
			
			uiViewController.present(sheetController, animated: true) {
				self.item = nil
			}
		}
	}
}

final class SheetHostingController<Content: View>: UIHostingController<Content> {
	override func viewDidLoad() {
		super.viewDidLoad()
		if let presentationController = presentationController as? UISheetPresentationController {
			presentationController.detents = [.medium()]
			presentationController.prefersGrabberVisible = true
		}
	}
}

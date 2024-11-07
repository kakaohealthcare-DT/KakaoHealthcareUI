//
//  TransparentView.swift
//  UIExtension
//
//  Created by bryn on 1/3/24.
//  Copyright © 2024 Kakao Healthcare Corp. All rights reserved.
//

import SwiftUI

public struct TransparentView: UIViewRepresentable {
	private class BackgroundRemovalView: UIView {
		
		override func didMoveToWindow() {
			super.didMoveToWindow()
			superview?.superview?.backgroundColor = .clear
		}
	}
	
	public init() { }
	
	public func makeUIView(context: Context) -> UIView {
		BackgroundRemovalView()
	}
	
	public func updateUIView(_ view: UIView, context: Context) { }
}

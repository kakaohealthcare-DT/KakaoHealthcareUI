//
//  ModalBackgroundModifier.swift
//  UIExtension
//
//  Created by bryn on 1/9/24.
//  Copyright © 2024 Kakao Healthcare Corp. All rights reserved.
//

import SwiftUI

struct ModalBackgroundModifier: ViewModifier {
	
	@State private var isAppeared: Bool = false
	@Environment(\.dismiss) var dismiss
	
	@Binding private var dismissTrigger: Bool
	private var isBackgroundTapEnable: Bool
	private var transaction: Transaction = {
		var transaction = Transaction()
		transaction.disablesAnimations = true
		return transaction
	}()
	
	struct Const {
		static var animationDuration = 0.2
	}
	
	public init(
		isBackgroundTapEnable: Bool,
		dismissTrigger: Binding<Bool>
	) {
		self.isBackgroundTapEnable = isBackgroundTapEnable
		self._dismissTrigger = dismissTrigger
	}
	
	func body(content: Content) -> some View {
		ZStack {
			TransparentView()
				.overlay(.black.opacity(0.5))
				.onTapGesture {
					guard isBackgroundTapEnable else { return }
					dismissTrigger = true
				}
			
			content
		}
		.opacity(isAppeared ? 1 : 0)
		.animation(.easeOut(duration: Const.animationDuration), value: isAppeared)
		.onAppear {
			isAppeared = true
		}
		.onChange(of: dismissTrigger, perform: { value in
			guard value == true else { return }
			dismissTrigger = false
			
			Task {
				await dismissAnimation()
				
				withTransaction(transaction) {
					dismiss()
				}
			}
		})
	}
	
	private func dismissAnimation() async {
		withAnimation {
			isAppeared = false
		}
		
		try? await Task.sleep(nanoseconds: UInt64(Const.animationDuration * pow(10, 9)))
	}
}


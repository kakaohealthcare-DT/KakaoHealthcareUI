//
//  GesturePublisher.swift
//  UIExtension
//
//  Created by brunel on 2/14/24.
//  Copyright © 2024 Kakao Healthcare Corp. All rights reserved.
//

import Foundation
import UIKit
import Combine

public struct GesturePublisher<Gesture: UIGestureRecognizer>: Publisher {
	public typealias Output = Void
	public typealias Failure = Never
	
	private weak var gesture: Gesture?
	
	public init(
		gesture: Gesture?
	) {
		self.gesture = gesture
	}
	
	public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Void == S.Input {
		guard let gesture else {
			subscriber.receive(completion: .finished)
			return
		}
		
		let subscription = GestureSubscription(
			subscriber: subscriber,
			gesture: gesture
		)
		subscriber.receive(subscription: subscription)
	}
}

public class GestureSubscription<S: Subscriber, G: UIGestureRecognizer>: Subscription where S.Input == Void {
	private let subscriber: S?
	private weak var gesture: G?
	
	public init(
		subscriber: S?,
		gesture: G?
	) {
		self.subscriber = subscriber
		self.gesture = gesture
		
		self.gesture?.addTarget(self, action: #selector(handleAction))
	}
	
	@objc
	private func handleAction(_ sender: UIGestureRecognizer) {
		_ = self.subscriber?.receive()
	}
	
	public func request(_ demand: Subscribers.Demand) {	}
	public func cancel() {
		self.gesture?.removeTarget(self, action: #selector(handleAction))
		self.gesture = nil
	}
}

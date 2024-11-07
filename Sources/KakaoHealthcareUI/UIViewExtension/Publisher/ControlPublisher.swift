import UIKit
import Combine

// Ref: https://medium.com/divar-mobile-engineering/create-publisher-for-uicontrol-b74ff5871787
public struct ControlPublisher<Control: UIControl>: Publisher {

	public typealias Output = Void
	public typealias Failure = Never
	
	private weak var control: Control?
	private let event: UIControl.Event
	private let haptic: Haptic?
	public init(
		_ control: Control?,
		_ event: UIControl.Event,
		_ haptic: Haptic?
	) {
		self.control = control
		self.event = event
		self.haptic = haptic
	}
	
	public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Output == S.Input {
		guard let control else {
			subscriber.receive(completion: .finished)
			return
		}
		let subscription = ControlSubscription(
			subscriber,
			control,
			event,
			haptic
		)
		subscriber.receive(subscription: subscription)
	}
}

public class ControlSubscription<S: Subscriber, C: UIControl>: Subscription where S.Input == Void {
	private let subscriber: S?
	private weak var control: C?
	private let event: UIControl.Event
	private let haptic: Haptic?
	
	public init(
		_ subscriber: S,
		_ control: C,
		_ event: UIControl.Event,
		_ haptic: Haptic?
	) {
		self.subscriber = subscriber
		self.control = control
		self.event = event
		self.haptic = haptic
		self.control?.addTarget(self, action: #selector(handleAction), for: event)
	}
	
	@objc
	private func handleAction(_ sender: UIControl) {
		_ = self.subscriber?.receive()
		haptic?.generate()
	}
	
	public func request(_ demand: Subscribers.Demand) {	}
	
	public func cancel() {
		self.control?.removeTarget(self, action: #selector(handleAction), for: event)
		self.control = nil
	}
}

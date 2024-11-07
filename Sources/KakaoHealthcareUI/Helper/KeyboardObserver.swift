import Combine
import SwiftUI

public final class KeyboardObserver: ObservableObject {
	@Published public var keyboardHeight: CGFloat = 0
	public var customOffset: CGFloat
	
	private var cancellables: Set<AnyCancellable> = []
	
	public init(customOffset: CGFloat = 0) {
		self.customOffset = customOffset
		let keyboardWillShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
			.compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
			.map { [weak self] in
				guard let self else { return $0.height }
				return $0.height - self.customOffset
			}
			.eraseToAnyPublisher()
		
		let keyboardWillHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
			.map { _ in CGFloat(0) }
			.eraseToAnyPublisher()
		
		keyboardWillShow
			.merge(with: keyboardWillHide)
			.sink { [weak self] height in
				self?.keyboardHeight = height
			}
			.store(in: &cancellables)
	}
}

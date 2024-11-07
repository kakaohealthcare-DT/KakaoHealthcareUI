import UIKit

public extension UIView {
	@discardableResult
	func add<T: UIView>(_ subview: T, then closure: ((T) -> Void)? = nil) -> T {
		addSubview(subview)
		closure?(subview)
		return subview
	}
}

public extension UIStackView {
	@discardableResult
	func addArranged<T: UIView>(_ subview: T, then closure: ((T) -> Void)? = nil) -> T {
		addArrangedSubview(subview)
		closure?(subview)
		return subview
	}
	
	@discardableResult
	func addArranged<T: UIView>(_ subview: T, spacing: CGFloat, then closure: ((T) -> Void)? = nil) -> T {
		addArrangedSubview(subview)
		setCustomSpacing(spacing, after: subview)
		closure?(subview)
		return subview
	}
	
	@discardableResult
	func addArranged<T: UIView>(
		@StackBuilder _ subviews: () -> [T],
		spacing: CGFloat? = nil,
		then closure: (([T]) -> Void)? = nil
	) -> [T] {
		for subview in subviews() {
			addArrangedSubview(subview)
			if let spacing = spacing {
				setCustomSpacing(spacing, after: subview)
			}
		}
		closure?(subviews())
		return subviews()
	}
}

public protocol Then {}
extension Then where Self: AnyObject {
	@inlinable
	public func apply(_ block: (Self) throws -> Void) rethrows -> Self {
		try block(self)
		return self
	}
}

extension NSObject: Then {}

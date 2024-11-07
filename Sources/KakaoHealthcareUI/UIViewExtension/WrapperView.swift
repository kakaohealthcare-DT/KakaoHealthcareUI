import UIKit

public class WrapperView: UIView {
	private var wrappedView: UIView
	private var topConstraint: NSLayoutConstraint?
	private var leadingConstraint: NSLayoutConstraint?
	private var bottomConstraint: NSLayoutConstraint?
	private var trailingConstraint: NSLayoutConstraint?
	private var centerXConstraint: NSLayoutConstraint?
	private var centerYConstraint: NSLayoutConstraint?
	
	public init(
		top: CGFloat? = 0,
		leading: CGFloat? = 0,
		bottom: CGFloat? = 0,
		trailing: CGFloat? = 0,
		centerX: Bool = false,
		centerY: Bool = false,
		center: Bool = false,
		_ view: UIView
	) {
		self.wrappedView = view
		super.init(frame: .zero)
		setupView()
		setupInitialConstraints(top: top, leading: leading, bottom: bottom, trailing: trailing, centerX: centerX, centerY: centerY, center: center)
	}
	
	private func setupView() {
		addSubview(wrappedView)
		wrappedView.translatesAutoresizingMaskIntoConstraints = false
	}
	
	// swiftlint:disable function_parameter_count
	private func setupInitialConstraints(top: CGFloat?, leading: CGFloat?, bottom: CGFloat?, trailing: CGFloat?, centerX: Bool, centerY: Bool, center: Bool) {
		if let top {
			topConstraint = wrappedView.topAnchor.constraint(equalTo: self.topAnchor, constant: top)
		}
		if let leading {
			leadingConstraint = wrappedView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leading)
		}
		if let bottom {
			bottomConstraint = wrappedView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -bottom)
		}
		if let trailing {
			trailingConstraint = wrappedView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -trailing)
		}
		if centerX || center {
			centerXConstraint = wrappedView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
		}
		if centerY || center {
			centerYConstraint = wrappedView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
		}
		
		[topConstraint, leadingConstraint, bottomConstraint, trailingConstraint, centerXConstraint, centerYConstraint].forEach { $0?.isActive = true }
	}
	// swiftlint:enable function_parameter_count
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// Other methods would follow a similar pattern to the `top` method below
	public func top(_ top: CGFloat = 0) -> WrapperView {
		topConstraint?.constant = top
		return self
	}
	
	public func leading(_ leading: CGFloat = 0) -> WrapperView {
		leadingConstraint?.constant = leading
		return self
	}
	
	public func bottom(_ bottom: CGFloat = 0) -> WrapperView {
		bottomConstraint?.constant = bottom
		return self
	}
	
	public func trailing(_ trailing: CGFloat = 0) -> WrapperView {
		trailingConstraint?.constant = trailing
		return self
	}
	
	public func center(_ center: Bool = true) -> WrapperView {
			if center {
					if centerXConstraint == nil {
							centerXConstraint = wrappedView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
							centerXConstraint?.isActive = true
					}
					if centerYConstraint == nil {
							centerYConstraint = wrappedView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
							centerYConstraint?.isActive = true
					}
			} else {
					centerXConstraint?.isActive = false
					centerYConstraint?.isActive = false
					centerXConstraint = nil
					centerYConstraint = nil
			}
			return self
	}

	func centerX(_ centerX: Bool = true) -> WrapperView {
			if centerX && centerXConstraint == nil {
					centerXConstraint = wrappedView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
					centerXConstraint?.isActive = true
			} else if !centerX {
					centerXConstraint?.isActive = false
					centerXConstraint = nil
			}
			return self
	}

	func centerY(_ centerY: Bool = true) -> WrapperView {
			if centerY && centerYConstraint == nil {
					centerYConstraint = wrappedView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
					centerYConstraint?.isActive = true
			} else if !centerY {
					centerYConstraint?.isActive = false
					centerYConstraint = nil
			}
			return self
	}
}

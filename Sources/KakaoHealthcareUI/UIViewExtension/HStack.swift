//
//  HStack.swift
//  SampleUIKit
//
//  Created by nobleidea on 2023/04/05.
//

import UIKit

public final class HStackView: UIStackView, DeclarativeStackView {
	public init(spacing: CGFloat = 0) {
		super.init(frame: .zero)
		self.spacing = spacing
		self.axis = .horizontal
	}
	
	public convenience init(spacing: CGFloat = 0, @StackBuilder _ views: () -> [UIView]) {
		self.init(spacing: spacing)
		addArrangedViews(spacing: spacing, views)
	}
  
  required init(coder: NSCoder) {
    super.init(coder: coder)
  }
}

public final class VStackView: UIStackView, DeclarativeStackView {
	
	public init(spacing: CGFloat = 0) {
		super.init(frame: .zero)
		self.spacing = spacing
		self.axis = .vertical
	}
	
	public convenience init(spacing: CGFloat = 0, @StackBuilder _ views: () -> [UIView]) {
		self.init(spacing: spacing)
		addArrangedViews(spacing: spacing, views)
	}
	
	required init(coder: NSCoder) {
		super.init(coder: coder)
	}
}

public protocol DeclarativeStackView: UIStackView {
	init(spacing: CGFloat, @StackBuilder _ views: () -> [UIView])
	
	func addArrangedViews(spacing: CGFloat, @StackBuilder _ views: () -> [UIView])
}

extension DeclarativeStackView {
	
	public func addArrangedViews(spacing: CGFloat = 0, @StackBuilder _ views: () -> [UIView]) {
		views().forEach { addArrangedSubview($0) }
	}
}

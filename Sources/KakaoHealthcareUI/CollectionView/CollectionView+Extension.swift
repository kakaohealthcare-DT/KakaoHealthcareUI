//
//  VisibleConstants.swift
//  SampleDomain
//
//  Created by kyle.cha on 2023/08/16.
//

import Foundation
import UIKit

public protocol ReusableView {
	static var reuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
	/// reusableIdentifier == ClassName
	public static var reuseIdentifier: String { String(describing: self) }
}

extension UICollectionReusableView: ReusableView {}

public extension UICollectionView {
	func register<T: UICollectionReusableView>(
		_ name: T.Type
	) {
		let cellName = String(describing: T.self)
		let nib = UINib(nibName: cellName, bundle: nil)
		register(nib, forCellWithReuseIdentifier: String(describing: cellName))
	}
	
	func dequeueReusableCell<T: UICollectionViewCell>(
		withClass name: T.Type,
		for indexPath: IndexPath
	) -> T {
		guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: name), for: indexPath) as? T else {
			fatalError("Could not dequeue cell with identifier: \(String(describing: name))")
		}
		return cell
	}
	
	func register<T: UICollectionViewCell>(
		with className: T.Type
	) {
		self.register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
	}
	
	func register<T: UICollectionReusableView>(
		supplementaryViewOfKind kind: String,
		with className: T.Type
	) {
		register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
	}
}

extension UICollectionView {
	func isIndexPathAvailable(
		_ indexPath: IndexPath
	) -> Bool {
		guard dataSource != nil,
					indexPath.section < numberOfSections,
					indexPath.item < numberOfItems(inSection: indexPath.section)
		else {
			return false
		}
		
		return true
	}
	
	func scrollToItemIfAvailable(
		_ indexPath: IndexPath,
		animated: Bool = true
	) {
		guard isIndexPathAvailable(indexPath) else {
			return
		}
		
		DispatchQueue.main.safeAsync {
			self.scrollToItem(
				at: indexPath,
				at: .centeredHorizontally,
				animated: animated
			)
		}
	}
}

open class BaseCollectionViewCell: UICollectionViewCell {
	public override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupViews()
	}
	
	open func setupViews() { }
	
	open func configure(with item: any ItemProtocol) {
		
	}
}

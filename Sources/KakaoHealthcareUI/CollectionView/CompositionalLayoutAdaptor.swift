//
//  DTCompositionalLayoutAdaptor.swift
//  DTUIKit
//
//  Created by kyle.cha on 2023/07/13.
//  Copyright © 2023 Kakao Healthcare Corp. All rights reserved.
//

import Foundation
import UIKit
import KakaoHealthcareFoundation

public protocol SectionProtocol: Hashable {
	func layoutSection(
		collectionView: UICollectionView
	) -> NSCollectionLayoutSection
}

public protocol ItemProtocol: Hashable {
	var cellType: BaseCollectionViewCell.Type { get }
}

extension CompositionalLayoutAdaptor.Section: SectionProtocol {
	public func layoutSection(
		collectionView: UICollectionView
	) -> NSCollectionLayoutSection {
		let layoutForSection = NSCollectionLayoutSection(
			group: group.layoutForGroup(items: items, width: collectionView.frame.width)
		)
		
		switch group {
		case .banner:
			layoutForSection.orthogonalScrollingBehavior = .groupPagingCentered
		case .carousel:
			layoutForSection.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
			layoutForSection.visibleItemsInvalidationHandler = { items, offset, environment in
				items.forEach { item in
					let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
					let minScale: CGFloat = 0.8
					let maxScale: CGFloat = 1.0 - distanceFromCenter / environment.container.contentSize.width
					let scale = max(maxScale, minScale)
					item.transform = CGAffineTransform(
						scaleX: scale,
						y: scale
					)
				}
			}
			
		case .article:
			break
		case .widget:
			break
		case .grid:
			break
		case .gridGroup:
			break
		case .autoDimension:
			break
		case .pinterest:
			break
		}
		
		return layoutForSection
	}
}

extension CompositionalLayoutAdaptor {
	typealias DataSource = UICollectionViewDiffableDataSource<Section, ItemAdaptor>
	typealias SnapShot = NSDiffableDataSourceSnapshot<Section, ItemAdaptor>
	
	public struct Section: Synthesizable {
		let group: Group
		public var items: [ItemAdaptor]
		
		public init(
			group: Group,
			items: [ItemAdaptor.Item]
		) {
			self.group = group
			self.items = items.map { ItemAdaptor(item: $0) }
		}
	}
	
	public struct ItemAdaptor: Hashable {
		public typealias Item = any ItemProtocol
		let item: Item
		
		public init(item: Item) {
			self.item = item
		}
		
		public func hash(into hasher: inout Hasher) {
			item.hash(into: &hasher)
		}
		
		public static func == (lhs: ItemAdaptor, rhs: ItemAdaptor) -> Bool {
			lhs.item.hashValue == rhs.item.hashValue
		}
	}
}

public enum CompositionalLayoutAdaptor {
	public enum Group {
		case banner
		case carousel
		case article
		case widget
		case grid(columns: Int)
		case gridGroup(leading: Int, trailing: Int)
		case autoDimension(estimatedHeight: Int)
		case pinterest(columns: Int)
	}
}

extension CompositionalLayoutAdaptor.Group {
	enum DesignatedLayout { }
	
	func layoutForGroup(
		items: [CompositionalLayoutAdaptor.ItemAdaptor],
		width: CGFloat
	) -> NSCollectionLayoutGroup {
		switch self {
		case .banner:
			return DesignatedLayout.banner
		case .carousel:
			return DesignatedLayout.carousel
		case .article:
			return DesignatedLayout.banner
		case .widget:
			return DesignatedLayout.widget
		case let .grid(columns):
			return DesignatedLayout.grid(columns: columns)
		case let .gridGroup(leading, trailing):
			return DesignatedLayout.gridGroup(
				leading: leading,
				trailing: trailing
			)
		case let .autoDimension(estimatedHeight):
			return DesignatedLayout.autoDimension(
				estimatedHeight: estimatedHeight
			)
		case let .pinterest(columns):
			return DesignatedLayout.pinterest(
				columnsCount: columns,
				items: items.compactMap { $0.item as? Ratioable },
				contentWidth: width
			)
		}
	}
}

extension CompositionalLayoutAdaptor.Group.DesignatedLayout {
	static let banner: NSCollectionLayoutGroup = {
		let layoutForItem = NSCollectionLayoutItem(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .fractionalHeight(1.0)
			)
		)
		
		layoutForItem.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 10, bottom: 10, trailing: 0)
		
		return NSCollectionLayoutGroup.horizontal(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .fractionalHeight(0.32)
			),
			subitems: [layoutForItem]
		)
	}()
	
	static let carousel: NSCollectionLayoutGroup = {
		let itemSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1),
			heightDimension: .fractionalHeight(1)
		)
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let groupSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1),
			heightDimension: .fractionalWidth(1)
		)
		let group = NSCollectionLayoutGroup.horizontal(
			layoutSize: groupSize,
			subitems: [item]
		)
		
		return group
	}()
	
	static let widget: NSCollectionLayoutGroup = {
		let itemSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1),
			heightDimension: .fractionalHeight(1)
		)
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		item.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
		
		let groupSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(0.2),
			heightDimension: .fractionalWidth(0.3)
		)
		
		let group = NSCollectionLayoutGroup.horizontal(
			layoutSize: groupSize,
			subitems: [item]
		)
		
		return group
	}()
	
	static func grid(columns: Int) -> NSCollectionLayoutGroup {
		let itemSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1.0 / CGFloat(columns)),
			heightDimension: .fractionalHeight(1.0)
		)
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		item.contentInsets = .init(
			top: 5,
			leading: 5,
			bottom: 5,
			trailing: 5
		)
		
		let groupSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1.0),
			heightDimension: .fractionalWidth(0.5)
		)
		
		let group = NSCollectionLayoutGroup.horizontal(
			layoutSize: groupSize,
			subitems: [item]
		)
		
		return group
	}
	
	static func gridGroup(
		leading: Int,
		trailing: Int
	) -> NSCollectionLayoutGroup {
		let itemSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1.0),
			heightDimension: .fractionalHeight(1.0)
		)
		
		let item = NSCollectionLayoutItem(
			layoutSize: itemSize
		)
		
		let itemSpacing: CGFloat = 1
		item.contentInsets = NSDirectionalEdgeInsets(
			top: itemSpacing,
			leading: itemSpacing,
			bottom: itemSpacing,
			trailing: itemSpacing
		)
		
		let leadingGroup: NSCollectionLayoutGroup
		
		if #available(iOS 16.0, *) {
			leadingGroup = NSCollectionLayoutGroup.vertical(
				layoutSize: NSCollectionLayoutSize(
					widthDimension: .fractionalWidth(1.0 / 2),
					heightDimension: .fractionalHeight(1.0 / CGFloat(leading))
				),
				repeatingSubitem: item,
				count: leading
			)
		} else {
			leadingGroup = NSCollectionLayoutGroup.vertical(
				layoutSize: NSCollectionLayoutSize(
					widthDimension: .fractionalWidth(1.0 / 2),
					heightDimension: .fractionalHeight(1.0 / CGFloat(leading))
				),
				subitem: item,
				count: leading
			)
		}
		
		let trailingGroup: NSCollectionLayoutGroup
		if #available(iOS 16.0, *) {
			trailingGroup = NSCollectionLayoutGroup.vertical(
				layoutSize: NSCollectionLayoutSize(
					widthDimension: .fractionalWidth(1.0 / 2),
					heightDimension: .fractionalHeight(1.0 / CGFloat(trailing))
				),
				repeatingSubitem: item,
				count: trailing
			)
		} else {
			trailingGroup = NSCollectionLayoutGroup.vertical(
				layoutSize: NSCollectionLayoutSize(
					widthDimension: .fractionalWidth(1.0 / 2),
					heightDimension: .fractionalHeight(1.0 / CGFloat(trailing))
				),
				subitem: item,
				count: trailing
			)
		}
		
		let nestedGroupSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1.0),
			heightDimension: .absolute(1000)
		)
		
		let nestedGroup = NSCollectionLayoutGroup.horizontal(
			layoutSize: nestedGroupSize,
			subitems: [leadingGroup, trailingGroup]
		)
		
		return nestedGroup
	}
	
	static func autoDimension(
		estimatedHeight: Int
	) -> NSCollectionLayoutGroup {
		let heightDimension = NSCollectionLayoutDimension.estimated(CGFloat(estimatedHeight))
		
		let itemSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1.0),
			heightDimension: heightDimension
		)
		
		let layoutItem = NSCollectionLayoutItem(
			layoutSize: itemSize
		)
		
		let layoutGroupSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1.0),
			heightDimension: heightDimension
		)
		
		let layoutGroup = NSCollectionLayoutGroup.vertical(
			layoutSize: layoutGroupSize,
			subitems: [layoutItem]
		)
		layoutGroup.interItemSpacing = .fixed(10)
		
		return layoutGroup
	}
	
	static func pinterest(
		columnsCount: Int,
		items: [Ratioable],
		contentWidth: CGFloat
	) -> NSCollectionLayoutGroup {
		PinterestCollectionLayoutGroup(
			columnsCount: columnsCount,
			itemRatios: items,
			contentWidth: contentWidth
		)
		.layoutGroup
	}
}

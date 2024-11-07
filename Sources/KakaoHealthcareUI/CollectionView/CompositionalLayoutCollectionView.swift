//
//  VisibleConstants.swift
//  SampleDomain
//
//  Created by kyle.cha on 2023/08/16.
//

import Foundation
import UIKit
import KakaoHealthcareFoundation
import Combine

public final class CompositionalLayoutCollectionView: UICollectionView {
    private var designatedSections: [CompositionalLayoutAdaptor.Section] = []
    
    private lazy var designatedDataSource: CompositionalLayoutAdaptor.DataSource = { [unowned self] in
        CompositionalLayoutAdaptor.DataSource(
            collectionView: self
        ) { collectionView, indexPath, adaptor in
            let cell = collectionView.dequeueReusableCell(
                withClass: adaptor.item.cellType,
                for: indexPath
            )
            cell.configure(with: adaptor.item)
            return cell
        }
    }()
    
    public init() {
        super.init(
            frame: .zero,
            // configure fake layout first
            collectionViewLayout: UICollectionViewLayout()
        )
        
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension CompositionalLayoutCollectionView {
    func update(
        sections: [CompositionalLayoutAdaptor.Section],
        animatingDifferences: Bool = false
    ) {
        designatedSections = sections
        setCollectionViewLayout(
            configureLayout(sections: sections),
            animated: false
        )
        
        configureData(
            animatingDifferences: animatingDifferences
        )
    }
    
    func append(
        sections: [CompositionalLayoutAdaptor.Section],
        animatingDifferences: Bool = false
    ) {
        var snapshot = designatedDataSource.snapshot()
        
        for section in sections {
            snapshot.appendItems(
                Array(section.items.suffix(from: section.items.index(after: snapshot.numberOfItems)))
            )
        }
        
        designatedDataSource.apply(
            snapshot,
            animatingDifferences: animatingDifferences
        )
    }
}

private extension CompositionalLayoutCollectionView {
    func configureLayout(
        sections: [CompositionalLayoutAdaptor.Section]
    ) -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            sections[safe: sectionIndex]?.layoutSection(collectionView: self)
        }
    }
    
    func configureData(
        animatingDifferences: Bool
    ) {
        var snapshot = CompositionalLayoutAdaptor.SnapShot()
        snapshot.appendSections(designatedSections)
        
        for section in designatedSections {
            snapshot.appendItems(
                section.items,
                toSection: section
            )
        }
        
        designatedDataSource.apply(
            snapshot,
            animatingDifferences: animatingDifferences
        )
    }
}

extension CompositionalLayoutCollectionView: UICollectionViewDelegate {
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let adaptor = designatedDataSource.itemIdentifier(
            for: indexPath
        ) else { return }
        
        Logger.debug(adaptor.item)
    }
}

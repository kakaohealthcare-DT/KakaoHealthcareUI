//
//  VisibleConstants.swift
//  SampleDomain
//
//  Created by kyle.cha on 2023/08/16.
//

import Foundation
import UIKit

public protocol Ratioable {
    var ratio: CGFloat { get }
}

final class PinterestCollectionLayoutGroup {
    // MARK: - Private methods
    private let numberOfColumns: Int
    private let itemRatios: [Ratioable]
    private let spacing: CGFloat
    private let contentWidth: CGFloat
    
    private var padding: CGFloat {
        spacing / 2
    }
    
    // Padding around cells equal to the distance between cells
    private var insets: NSDirectionalEdgeInsets {
        .init(top: padding, leading: padding, bottom: padding, trailing: padding)
    }
    
    private lazy var frames: [CGRect] = {
        calculateFrames()
    }()
    
    // Max height for section
    private lazy var sectionHeight: CGFloat = {
        (frames
            .map(\.maxY)
            .max() ?? 0
        ) + insets.bottom
    }()
    
    lazy var layoutGroup: NSCollectionLayoutGroup = {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(sectionHeight)
        )
        return NSCollectionLayoutGroup.custom(layoutSize: layoutSize) { _ in
            self.frames.map { .init(frame: $0) }
        }
    }()
    
    init(
        columnsCount: Int,
        itemRatios: [Ratioable],
        spacing: CGFloat = 0,
        contentWidth: CGFloat
    ) {
        self.numberOfColumns = columnsCount
        self.itemRatios = itemRatios
        self.spacing = spacing
        self.contentWidth = contentWidth
    }
    
    private func calculateFrames() -> [CGRect] {
        var contentHeight: CGFloat = 0
        
        // Subtract the margin from the total width and divide by the number of columns
        let columnWidth = (contentWidth - insets.leading - insets.trailing) / CGFloat(numberOfColumns)
        
        // Stores x-coordinate offset for each column. Not changing
        let xOffset = (0..<numberOfColumns).map { CGFloat($0) * columnWidth }
        
        var currentColumn = 0

        // Stores x-coordinate offset for each column.
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        // Total number of frames
        var frames = [CGRect]()
        
        for index in 0..<itemRatios.count {
            let aspectRatio = itemRatios[index]
            
            // Сalculate the frame.
            let frame = CGRect(
                x: xOffset[currentColumn],
                y: yOffset[currentColumn],
                width: columnWidth,
                height: columnWidth / aspectRatio.ratio
            )
            // Total frame inset between cells and along edges
            .insetBy(dx: padding, dy: padding)
            // Additional top and left offset to account for padding
            .offsetBy(dx: 0, dy: insets.leading)
            
            // update the height to keep the correct aspect ratio
            let newFrame = CGRect(
                x: frame.minX,
                y: frame.minY,
                width: frame.width,
                height: frame.width / aspectRatio.ratio
            )
            
            frames.append(newFrame)
        
            // Сalculate the height
            let columnLowestPoint = frame.maxY
            contentHeight = max(contentHeight, columnLowestPoint)
            yOffset[currentColumn] = columnLowestPoint
            // Adding the next element to the minimum height column.
            // We can move sequentially, but then there is a chance that some columns will be much longer than others
            currentColumn = {
                guard yOffset.count > 0 else { return 0 }
                var min = yOffset.first
                var index = 0
                
                yOffset.indices.forEach { cursor in
                    let currentItem = yOffset[cursor]
                    if let minumum = min, currentItem < minumum {
                        min = currentItem
                        index = cursor
                    }
                }
                
                return index
            }()
        }
        return frames
    }
}

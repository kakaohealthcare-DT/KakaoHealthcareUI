//
//  CircleBar.swift
//  SampleUIKit
//
//  Created by gyun on 2023/06/27.
//

import UIKit

@IBDesignable public class CircleBar: UITabBar {
    private var tabWidth: CGFloat = 0
    private var index: CGFloat = 0 {
        willSet {
            self.previousIndex = index
        }
    }
    private var animated = false
    private var selectedImage: UIImage?
    private var previousIndex: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
        
    }
    
    open override func draw(_ rect: CGRect) {
        drawCurve()
    }
}

public extension CircleBar {
    
    func select(itemAt: Int, animated: Bool) {
        self.index = CGFloat(itemAt)
        self.animated = animated
        self.selectedImage = self.selectedItem?.selectedImage
        self.selectedItem?.selectedImage = nil
        self.setNeedsDisplay()
    }
    
    private func drawCurve() {
        let fillColor: UIColor = .white
        tabWidth = self.bounds.width / CGFloat(self.items?.count ?? 0)
        let bezPath = drawPath(for: index)
        
        bezPath.close()
        fillColor.setFill()
        bezPath.fill()
        let mask = CAShapeLayer()
        mask.fillRule = .evenOdd
        mask.fillColor = UIColor.white.cgColor
        mask.path = bezPath.cgPath
        if self.animated {
            let bezAnimation = CABasicAnimation(keyPath: "path")
            let bezPathFrom = drawPath(for: previousIndex)
            bezAnimation.toValue = bezPath.cgPath
            bezAnimation.fromValue = bezPathFrom.cgPath
            bezAnimation.duration = 0.3
            bezAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            mask.add(bezAnimation, forKey: nil)
        }
        self.layer.mask = mask
    }
    
    private func customInit() {
        self.tintColor = .white
        self.barTintColor = .white
        self.backgroundColor = .white
    }
    
    private func drawPath(for index: CGFloat) -> UIBezierPath {
        let bezPath = UIBezierPath()
        
        let tabHeight: CGFloat = tabWidth
        
        let leftPoint = CGPoint(x: (index * tabWidth), y: 0)
        let leftPointCurveUp = CGPoint(
            x: ((tabWidth * index) + tabWidth / 5),
            y: 0)
        let leftPointCurveDown = CGPoint(
            x: ((index * tabWidth) - tabWidth * 0.2) + tabWidth / 4,
            y: tabHeight * 0.40)
        
        let middlePoint = CGPoint(
            x: (tabWidth * index) + tabWidth / 2,
            y: tabHeight * 0.4)
        let middlePointCurveDown = CGPoint(
            x: (((index * tabWidth) - tabWidth * 0.2) + tabWidth / 10) + tabWidth,
            y: tabHeight * 0.40)
        let middlePointCurveUp = CGPoint(
            x: (((tabWidth * index) + tabWidth) - tabWidth / 5),
            y: 0)
        
        let rightPoint = CGPoint(x: (tabWidth * index) + tabWidth, y: 0)
        bezPath.move(to: leftPoint)
        bezPath.addCurve(to: middlePoint, controlPoint1: leftPointCurveUp, controlPoint2: leftPointCurveDown)
        bezPath.addCurve(to: rightPoint, controlPoint1: middlePointCurveDown, controlPoint2: middlePointCurveUp)
        
        bezPath.append(UIBezierPath(rect: self.bounds))
        
        return bezPath
    }
}

extension CircleBar {
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let extendedArea = bounds.inset(by: .init(top: -(self.bounds.width / (CGFloat(items?.count ?? 4))) / 4, left: 0, bottom: 0, right: 0))
        if extendedArea.contains(point) {
            for subview in subviews {
                    let convertedPoint = subview.convert(point, from: self)
                if let result = subview.hitTest(.init(x: convertedPoint.x, y: 0), with: event) {
                        return result
                    }
            }
        }
        return super.hitTest(point, with: event)
    }
}

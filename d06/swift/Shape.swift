//
//  Shape.swift
//  d06
//
//  Created by Danyil ZBOROVKYI on 7/2/19.
//  Copyright © 2019 Danyil ZBOROVKYI. All rights reserved.
//

import UIKit

class Shape: UIView {
    var size: CGFloat = 100
    var circle: Bool = false
    
    init(centerPoint: CGPoint, maxWidth: CGFloat, maxHeight: CGFloat) {
        //Center shape to centerPoint
        var x = centerPoint.x - size / 2
        var y = centerPoint.y - size / 2
        
        //Make frames
        if x + size > maxWidth {
            x = maxWidth - size
        }
        if x < 0 {
            x = 0
        }
        if y + size > maxHeight {
            y = maxHeight - size
        }
        if y < 0 {
            y = 0
        }
        
        //Random shape
        let randomShape = Int(arc4random_uniform(2))
        switch randomShape {
        case 0:
            super.init(frame: CGRect(x: x, y: y, width: size, height: size))
            self.layer.cornerRadius = size / 2
            self.circle = true
        default:
            super.init(frame: CGRect(x: x, y: y, width: size, height: size))
        }
        

        //Random color for background of shape
        let randomColor = Int(arc4random_uniform(6))
        switch randomColor {
        case 0:
            self.backgroundColor = .green
        case 1:
            self.backgroundColor = .blue
        case 2:
            self.backgroundColor = .purple
        case 3:
            self.backgroundColor = .yellow
        case 4:
            self.backgroundColor = .red
        default:
            self.backgroundColor = .orange
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return self.circle ? .ellipse : .rectangle
    }

}

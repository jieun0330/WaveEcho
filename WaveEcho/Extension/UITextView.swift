//
//  UITextView.swift
//  WaveEcho
//
//  Created by 박지은 on 4/24/24.
//

import UIKit

class UnderlineTextView : UITextView {
    var lineHeight: CGFloat = 13.8
    
    override var font: UIFont? {
        didSet {
            if let newFont = font {
                lineHeight = newFont.lineHeight
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.black.cgColor)
        let numberOfLines = Int(rect.height / lineHeight)
        let topInset = textContainerInset.top
        
        for i in 1...numberOfLines {
            let y = topInset + CGFloat(i) * lineHeight
            
            let line = CGMutablePath()
            line.move(to: CGPoint(x: 0.0, y: y))
            line.addLine(to: CGPoint(x: rect.width, y: y))
            context?.addPath(line)
        }
        context?.strokePath()
        super.draw(rect)
    }
}

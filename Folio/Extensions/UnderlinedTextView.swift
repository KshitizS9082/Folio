//
//  UnderlinedTextView.swift
//  card2
//
//  Created by Kshitiz Sharma on 10/05/20.
//  Copyright © 2020 Kshitiz Sharma. All rights reserved.
//

import Foundation
import UIKit

class UnderlinedTextView: UITextView, NSLayoutManagerDelegate {
  var lineHeight: CGFloat = 13.8

  override var font: UIFont? {
    didSet {
      if let newFont = font {
        lineHeight = newFont.lineHeight + self.interLine
      }
    }
  }

  override func draw(_ rect: CGRect) {
    let ctx = UIGraphicsGetCurrentContext()
    ctx?.setStrokeColor(lineColor.cgColor)
    ctx?.setLineWidth(lineWidth)
    let numberOfLines = Int(rect.height / lineHeight)
    let topInset = textContainerInset.top

    for i in 1...numberOfLines {
      let y = topInset + CGFloat(i) * lineHeight

      let line = CGMutablePath()
      line.move(to: CGPoint(x: 0.0, y: y))
      line.addLine(to: CGPoint(x: rect.width, y: y))
      ctx?.addPath(line)
    }

    ctx?.strokePath()

    super.draw(rect)
  }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        layoutManager.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - NSLayoutManagerDelegate

    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return interLine
    }
}

extension UnderlinedTextView{
    var lineWidth: CGFloat{
        return 0.4
    }
    var lineColor: UIColor{
        return #colorLiteral(red: 0.4032981995, green: 0.4032981995, blue: 0.4032981995, alpha: 1)
    }
    var interLine: CGFloat{
        return 9
    }
}

//
//  Utils.swift
//  Baby Owl
//
//  Created by Hao on 11/22/15.
//  Copyright © 2015 Grumble & Homework, Inc. All rights reserved.
//

extension UIView {
    func debug() {
        self.layer.borderColor = UIColor.redColor().CGColor
        self.layer.borderWidth = 1
    }

    func autoAddSubview(subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
    }
}

extension String {
    func reasonableSizeInSize(size: CGSize, font: UIFont) -> CGSize {
        return self.boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil).size
    }
}

class ReasonableCollectionView: UICollectionView {
    override func touchesShouldCancelInContentView(view: UIView) -> Bool {
        return true
    }
}

let CGSomeRect = CGRectMake(0, 0, 500, 500)
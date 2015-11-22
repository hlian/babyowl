//
//  TimelineVM.swift
//  Baby Owl
//
//  Created by Hao on 11/22/15.
//  Copyright © 2015 Grumble & Homework, Inc. All rights reserved.
//

import Foundation
import PureLayout

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

class TweetCell: UICollectionViewCell {
    override init(frame: CGRect) {
        label = UILabel(frame: frame)
        super.init(frame: frame)

        autoAddSubview(label)
        label.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0, 10, 0, 10))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var tweetCM: String? {
        didSet {
            label.text = tweetCM ?? ""
        }
    }

    let label: UILabel
}

class TimelineDataSource: NSObject, UICollectionViewDataSource {
    unowned let vm: TimelineVM
    let tweets: [String]

    init(vm: TimelineVM) {
        self.vm = vm
        self.tweets = ["hello", "goodbye", "lorem", "ipsum", "scroll", "down", "burma", "shave"]
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("tweet cell", forIndexPath: indexPath) as! TweetCell
        cell.tweetCM = tweets[indexPath.row]
        cell.debug()
        return cell
    }

}

class TimelineVM {
    var dataSource: UICollectionViewDataSource!

    init() {
        dataSource = TimelineDataSource(vm: self)
    }

    func registerWithCollectionView(v: UICollectionView) {
        v.registerClass(TweetCell.self, forCellWithReuseIdentifier: "tweet cell")
    }
}
//
//  TimelineVM.swift
//  Baby Owl
//
//  Created by Hao on 11/22/15.
//  Copyright © 2015 Grumble & Homework, Inc. All rights reserved.
//

import Foundation
import PureLayout

private func m(s: String) -> (Tweet, CGFloat -> TweetBlueprints) {
    let t = Tweet(avatarURL: NSURL(string: "www.google.com")!, name: "shark twain", username: "haoformayor", tweet: s)
    let blueprints = bluePrintsOfTweet(t, sheet: tweetStylesheet)
    return (t, blueprints)
}

class TimelineDataSource: NSObject, UICollectionViewDataSource {
    unowned let vm: TimelineVM

    init(vm: TimelineVM) {
        self.vm = vm
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.tweets.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("tweet cell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = vm.tweets[indexPath.row].0
        cell.blueprints = vm.tweets[indexPath.row].1(collectionView.frame.width)
        return cell
    }

}

class TimelineVM {
    var dataSource: UICollectionViewDataSource!
    let tweets: [(Tweet, CGFloat -> TweetBlueprints)]

    init() {
        tweets = [m("hello"), m("goodbye"), m("lorem"), m("ipsum"), m("scroll"), m("down"), m("burma"), m("shave")]
        dataSource = TimelineDataSource(vm: self)
    }

    func registerWithCollectionView(v: UICollectionView) {
        v.registerClass(TweetCell.self, forCellWithReuseIdentifier: "tweet cell")
    }
}
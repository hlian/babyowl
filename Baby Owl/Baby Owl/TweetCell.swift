//
//  TweetCell.swift
//  Baby Owl
//
//  Created by Hao on 11/22/15.
//  Copyright © 2015 Grumble & Homework, Inc. All rights reserved.
//

import Foundation

private var _tweetCellAnimating = false

func beginTweetCellAnimation() {
    _tweetCellAnimating = true
}

func endTweetCellAnimation() {
    _tweetCellAnimating = false
}

struct Tweet {
    let avatarURL: NSURL
    let name: String
    let username: String
    let tweet: String
}

struct TweetBlueprints {
    let avatarPoint: CGPoint
    let avatarSize: CGSize
    let usernamePoint: CGPoint
    let usernameSize: CGSize
    let tweetPoint: CGPoint
    let tweetSize: CGSize
    let totalHeight: CGFloat

    var tweetFrame: CGRect {
        return CGRectMake(tweetPoint.x, tweetPoint.y, tweetSize.width, tweetSize.height)
    }

    var usernameFrame: CGRect {
        return CGRectMake(usernamePoint.x, usernamePoint.y, usernameSize.width, usernameSize.height)
    }

    var avatarFrame: CGRect {
        return CGRectMake(avatarPoint.x, avatarPoint.y, avatarSize.width, avatarSize.height)
    }
}

struct TweetStylesheet {
    let insets: UIEdgeInsets
    let interColumnSpacing: CGFloat
    let interLineSpacing: CGFloat
    let nameFont: UIFont
    let bodyFont: UIFont

    func usableWidth(totalWidth: CGFloat) -> CGFloat {
        return totalWidth - insets.left - insets.right
    }

    var leftWidth: CGFloat {
        return 32
    }

    func rightWidth(totalWidth: CGFloat) ->  CGFloat {
        return usableWidth(totalWidth) - interColumnSpacing - leftWidth
    }
}

func bluePrintsOfTweet(tweet: Tweet, sheet: TweetStylesheet)(totalWidth: CGFloat) -> TweetBlueprints {
    let avatarSize = CGSizeMake(sheet.leftWidth, sheet.leftWidth)
    let usernameSize = tweet.username.reasonableSizeInSize(CGSize(width: sheet.rightWidth(totalWidth), height: CGFloat.max), font: sheet.nameFont)
    let tweetSize = tweet.tweet.reasonableSizeInSize(CGSize(width: sheet.rightWidth(totalWidth), height: CGFloat.max), font: sheet.bodyFont)
    let avatarPoint = CGPointMake(sheet.insets.left, sheet.insets.top)
    let usernamePoint = CGPointMake(avatarPoint.x + avatarSize.width + sheet.interColumnSpacing, sheet.insets.top)
    let tweetPoint = CGPointMake(usernamePoint.x, usernamePoint.y + sheet.interLineSpacing + usernameSize.height)
    let totalHeight = max(avatarPoint.y + avatarSize.height, tweetPoint.y + tweetSize.height) + sheet.insets.bottom
    return TweetBlueprints(avatarPoint: avatarPoint, avatarSize: avatarSize, usernamePoint: usernamePoint, usernameSize: usernameSize, tweetPoint: tweetPoint, tweetSize: tweetSize, totalHeight: totalHeight)
}

class TweetCell: UICollectionViewCell {
    override init(frame: CGRect) {
        tweetLabel = UILabel(frame: frame)
        usernameLabel = UILabel(frame: frame)
        super.init(frame: frame)
        [tweetLabel, usernameLabel, avatarImageView].forEach(addSubview)

        avatarImageView.contentMode = .ScaleAspectFit
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        let animationBlock = {
            if let b = self.blueprints {
                self.tweetLabel.frame = b.tweetFrame
                self.usernameLabel.frame = b.usernameFrame
                self.avatarImageView.frame = b.avatarFrame
            }
        }
        if _tweetCellAnimating {
            UIView.animateWithDuration(0.25, animations: animationBlock)
        } else {
            animationBlock()
        }
    }

    var tweet: Tweet? {
        didSet {
            tweetLabel.text = tweet?.tweet ?? ""
            usernameLabel.text = tweet?.username ?? ""
        }
    }

    var blueprints: TweetBlueprints? {
        didSet {
            setNeedsLayout()
        }
    }

    let tweetLabel: UILabel
    let usernameLabel: UILabel
    let avatarImageView = UIImageView(image: UIImage(named: "jh_feather_25w")!)
}

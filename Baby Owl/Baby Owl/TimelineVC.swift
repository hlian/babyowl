//
//  TimelineVC.swift
//  Baby Owl
//
//  Created by Hao on 11/22/15.
//  Copyright © 2015 Grumble & Homework, Inc. All rights reserved.
//

import ReactiveCocoa

private func makeCollectionViewWithLayout(l: UICollectionViewLayout) -> UICollectionView {
    let v = ReasonableCollectionView(frame: CGSomeRect, collectionViewLayout: l)
    v.delaysContentTouches = false
    v.backgroundColor = UIColor(red:0.995, green:0.98, blue:0.95, alpha:1.0)
    return v
}

private func makeLayout() -> UICollectionViewLayout {
    let l = UICollectionViewFlowLayout()
    l.minimumLineSpacing = 10
    l.minimumInteritemSpacing = 0
    return l
}

private func makeConfiguration() -> NSURLSessionConfiguration {
    let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
    config.HTTPAdditionalHeaders = ["user-agent": "baby owl 1.0"]
    return config
}

class TimelineVC: UIViewController, UICollectionViewDelegateFlowLayout {
    class func make() -> TimelineVC {
        let vc = TimelineVC(nibName: nil, bundle: nil)
        return vc
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        viewModel = TimelineVM()
        tapGesture = UITapGestureRecognizer(target: nil, action: nil)
        OAuth = OAuthManager(mgr: manager)
        super.init(nibName: nil, bundle: nil)

        prepareTapGesture()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let l = makeLayout()
        let v = makeCollectionViewWithLayout(l)
        v.delegate = self
        v.dataSource = viewModel.dataSource

        viewModel.registerWithCollectionView(v)
        view = v
        collectionView = v

        collectionView.addGestureRecognizer(tapGesture)
    }

    let manager = Manager(configuration: makeConfiguration())

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        OAuth.go()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.contentInset.top = max(self.topLayoutGuide.length, collectionView.contentInset.top)
        collectionView.contentInset.bottom = max(self.bottomLayoutGuide.length, collectionView.contentInset.bottom)
    }

    let viewModel: TimelineVM
    let tapGesture: UITapGestureRecognizer
    var collectionView: UICollectionView!
    let OAuth: OAuthManager
    var selectedIndexPath: NSIndexPath?

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let blueprints = viewModel.tweets[indexPath.row].1(collectionView.frame.width)
        return CGSizeMake(collectionView.frame.width, self.selectedIndexPath == indexPath ? 200 : blueprints.totalHeight)
    }
}

extension TimelineVC {
    func prepareTapGesture() {
        tapGesture.rac_gestureSignal().toSignalProducer()
            .map { [unowned self] _ in self.tapGesture.state }
            .filter { state in state == .Ended }
            .filter { [weak self] _ in self != nil }
            .startWithNext {
                [unowned self] _ in
                if let path = self.collectionView.indexPathForItemAtPoint(self.tapGesture.locationInView(self.collectionView)) {
                    self.didTapPath(path)
                }
            }
    }

    func didTapPath(path: NSIndexPath) {
        beginTweetCellAnimation()
        self.collectionView.performBatchUpdates({
            self.selectedIndexPath = (path == self.selectedIndexPath ? nil : path)
        }) {
            _ in
            endTweetCellAnimation()
        }
    }
}
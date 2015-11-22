//
//  TimelineVC.swift
//  Baby Owl
//
//  Created by Hao on 11/22/15.
//  Copyright © 2015 Grumble & Homework, Inc. All rights reserved.
//

let CGSomeRect = CGRectMake(0, 0, 500, 500)


private func makeCollectionViewWithLayout(l: UICollectionViewLayout) -> UICollectionView {
    let v = UICollectionView(frame: CGSomeRect, collectionViewLayout: l)
    v.backgroundColor = UIColor(red:0.995, green:0.98, blue:0.95, alpha:1.0)
    return v
}

private func makeLayout() -> UICollectionViewLayout {
    let l = UICollectionViewFlowLayout()
    l.minimumLineSpacing = 0
    l.minimumInteritemSpacing = 0
    return l
}

private var token: dispatch_once_t = 0

class TimelineVC: UIViewController, UICollectionViewDelegateFlowLayout {
    class func make() -> TimelineVC {
        let vc = TimelineVC(nibName: nil, bundle: nil)
        return vc
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        viewModel = TimelineVM()
        super.init(nibName: nil, bundle: nil)
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
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.contentInset.top = max(self.topLayoutGuide.length, collectionView.contentInset.top)
        collectionView.contentInset.bottom = max(self.bottomLayoutGuide.length, collectionView.contentInset.bottom)
    }

    let viewModel: TimelineVM
    var collectionView: UICollectionView!

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.width, 100)
    }
}
//
//  TBC.swift
//  Baby Owl
//
//  Created by Hao on 11/22/15.
//  Copyright © 2015 Grumble & Homework, Inc. All rights reserved.
//

import Foundation
import UIKit

let timelineNC = TimelineNC.make()
let timelineVC = TimelineVC.make()
let otherVC = UIViewController()

let timelineImage = UIImage(named: "ea_owl_25w")!
let otherImage = UIImage(named: "yc_hamburger_25w")!
let composeImage = UIImage(named: "jh_feather_25w")!

class TBC: UITabBarController {
    override class func initialize() {
        timelineVC.title = "@haoformayor".localized()
        timelineVC.navigationItem.rightBarButtonItem = UIBarButtonItem(image: composeImage, style: .Plain, target: nil, action: nil)

        timelineNC.title = "Tweets".localized()
        otherVC.title = "Sundries".localized()

        timelineNC.tabBarItem.image = timelineImage
        otherVC.tabBarItem.image = otherImage

        timelineNC.viewControllers = [timelineVC]
    }

    class func make() -> TBC {
        let tbc = TBC(nibName: nil, bundle: nil)
        tbc.viewControllers = [timelineNC, otherVC]
        return tbc
    }
}
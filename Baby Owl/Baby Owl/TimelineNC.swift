//
//  TimelineNC.swift
//  Baby Owl
//
//  Created by Hao on 11/22/15.
//  Copyright © 2015 Grumble & Homework, Inc. All rights reserved.
//

import Foundation

class TimelineNC: UINavigationController {
    class func make() -> TimelineNC {
        let nc = TimelineNC(nibName: nil, bundle: nil)
        return nc
    }
}
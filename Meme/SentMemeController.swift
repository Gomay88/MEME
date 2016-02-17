//
//  SentMemeController.swift
//  Meme
//
//  Created by Victor Jimenez on 2/17/16.
//  Copyright © 2016 Victor Jimenez. All rights reserved.
//

import UIKit
import Foundation

class SentMemeController: UITabBarController {

    @IBAction func didTapAdd(sender: AnyObject) {
        performSegueWithIdentifier("showEditor", sender: self)
    }
}

//
//  MemeDetail.swift
//  Meme
//
//  Created by Victor Jimenez on 2/17/16.
//  Copyright © 2016 Victor Jimenez. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var memeImage: UIImageView!
    
    var meme: Meme!
    
    override func viewDidLoad() {
        memeImage.image = meme.memeImage
    }
    
    @IBAction func didTapCancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
}

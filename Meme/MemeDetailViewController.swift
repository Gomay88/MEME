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
    
    var meme = Meme()
    var index: Int!
    
    override func viewDidLoad() {
        memeImage.contentMode = .ScaleAspectFit
        memeImage.image = meme.memeImage
    }
    
    @IBAction func didTapCancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func deletePhoto(sender: AnyObject) {
        let memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        let indexPath = memes.indexOf({$0.memeImage == meme.memeImage})
        
        guard indexPath != nil else {
            print("Not found")
            return
        }
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath!)
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
}

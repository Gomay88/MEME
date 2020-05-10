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
        memeImage.contentMode = .scaleAspectFit
        memeImage.image = meme.memeImage
    }
    
    @IBAction func didTapCancel(sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deletePhoto(sender: AnyObject) {
        let memes = (UIApplication.shared.delegate as! AppDelegate).memes

        guard let indexPath = memes.firstIndex(where: {$0.memeImage == meme.memeImage}) else {
            print("Not found")
            return
        }
        
        (UIApplication.shared.delegate as! AppDelegate).memes.remove(at: indexPath)
        navigationController?.popToRootViewController(animated: true)
    }
    
}

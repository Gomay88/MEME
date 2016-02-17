//
//  SentTableViewCell.swift
//  Meme
//
//  Created by Victor Jimenez on 2/17/16.
//  Copyright © 2016 Victor Jimenez. All rights reserved.
//

import UIKit

class SentTableViewCell: UITableViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var memeLabel: UILabel!
    
    //MARK: Meme
    var meme: Meme {
        get { return _meme }
        set {
            _meme = newValue
            memeImage.image = (newValue.image as UIImage)
            memeLabel.text = (newValue.topText as String)
        }
    }
    
    var _meme = Meme()
    
    override func prepareForReuse() {
        memeImage.image = nil
        memeLabel.text = ""
    }

}

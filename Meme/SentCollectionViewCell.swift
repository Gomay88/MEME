//
//  SentCollectionViewCell.swift
//  Meme
//
//  Created by Victor Jimenez on 2/17/16.
//  Copyright © 2016 Victor Jimenez. All rights reserved.
//

import UIKit

class SentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    //MARK: Publics
    //MARK: Meme
    var meme: Meme {
        get { return _meme }
        set {
            _meme = newValue
            memeImageView.image = (newValue.image as UIImage)
        }
    }
    
    var _meme = Meme()
    
    override func prepareForReuse() {
        memeImageView.image = nil
    }
}

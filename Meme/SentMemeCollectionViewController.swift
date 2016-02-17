//
//  SentMemeCollectionViewController.swift
//  Meme
//
//  Created by Victor Jimenez on 2/17/16.
//  Copyright © 2016 Victor Jimenez. All rights reserved.
//

import UIKit

class SentMemeCollectionViewController: UICollectionViewController {

    var memesArray = [Meme]()
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    //MARK: View
    override func viewWillAppear(animated: Bool) {
        memesArray = appDelegate.memes
        collectionView?.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showDetailFromCollection") {
            let memeDetailViewController: MemeDetailViewController = segue.destinationViewController as! MemeDetailViewController
            memeDetailViewController.meme = memesArray[(collectionView?.indexPathsForSelectedItems()?.first?.row)!]
        }
    }
}
    
//MARK: Delegate
extension SentMemeCollectionViewController {
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memesArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCollectionCell", forIndexPath: indexPath) as! SentCollectionViewCell
        cell.meme = memesArray[indexPath.row]
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showDetailFromCollection", sender: self)
    }
}

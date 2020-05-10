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
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: View
    override func viewWillAppear(_ animated: Bool) {
        memesArray = appDelegate.memes
        collectionView?.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDetailFromCollection") {
            let memeDetailViewController: MemeDetailViewController = segue.destination as! MemeDetailViewController
            memeDetailViewController.meme = memesArray[(collectionView?.indexPathsForSelectedItems?.first?.row)!]
        }
    }
}
    
//MARK: Delegate
extension SentMemeCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memesArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCollectionCell", for: indexPath) as! SentCollectionViewCell
        cell.meme = memesArray[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailFromCollection", sender: self)
    }
}

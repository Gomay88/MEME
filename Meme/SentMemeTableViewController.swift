//
//  SentMemeTableViewController.swift
//  Meme
//
//  Created by Victor Jimenez on 2/17/16.
//  Copyright © 2016 Victor Jimenez. All rights reserved.
//

import UIKit

class SentMemeTableViewController: UITableViewController {
    
    var memesArray = [Meme]()
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    //MARK: View
    override func viewDidAppear(animated: Bool) {
        memesArray = appDelegate.memes
        
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showDetailFromTable") {
            let memeDetailViewController: MemeDetailViewController = segue.destinationViewController as! MemeDetailViewController
            memeDetailViewController.meme = memesArray[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
}

//Delegates
extension SentMemeTableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memesArray.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memeTableViewCell") as! SentTableViewCell
        cell.meme = memesArray[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showDetailFromTable", sender: self)
    }
}

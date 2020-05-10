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
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: View
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memesArray = appDelegate.memes
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDetailFromTable") {
            let memeDetailViewController: MemeDetailViewController = segue.destination as! MemeDetailViewController
            memeDetailViewController.meme = memesArray[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
}

//Delegates
extension SentMemeTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memesArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableViewCell") as! SentTableViewCell
        cell.meme = memesArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailFromTable", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            appDelegate.memes.remove(at: indexPath.row)
            memesArray = appDelegate.memes
            tableView.reloadData()
        }
    }
}

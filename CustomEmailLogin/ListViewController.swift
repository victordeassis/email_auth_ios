//
//  ViewController.swift
//  CustomEmailLogin
//
//  Created by Victor de Assis on 24/03/18.
//  Copyright © 2018 Victor de Assis. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var postData = [String]()
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle?
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return(postData.count)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = postData[indexPath.row]
        
        return(cell)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set the firebase reference
        ref = Database.database().reference()
        
        // Retrieve the posts and listen for changes
        databaseHandle = ref?.child("messages").observe(DataEventType.childAdded, with: { (snapshot) in
            
            // Code to execute when a child is added under "messages"
            // Take the value from the snapshot and added it to the postData array
            
            // Try to convert the value of the data to a string
//            let post = snapshot.value as? String
            
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            
            if let actualPost = postDict["text"], let stringPost = actualPost as? String {
                // Append the data to our postData array
                self.postData.append(stringPost)
                
                // Reload the tableview
                self.tableView.reloadData()
//                self.UITableView.reloadData()
            }
            
        })
        
        databaseHandle = ref?.child("messages").observe(.childRemoved, with: { (snapshot) -> Void in

            let data = snapshot as! DataSnapshot
            let dataObject = data.value as! [String : AnyObject]
            let dataObjectText = dataObject["text"] as! String
            let index = self.postData.index(of: dataObjectText)!
            self.postData.remove(at: index)
            self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: UITableViewRowAnimation.automatic)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



//
//  tableView.swift
//  Ma Made It-Swift
//
//  Created by Joaquim Patrick Ramos Grilo on 2015-12-12.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse


class tableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var messages = [String]()
    var usernames = [String]()
    var imageFiles = [PFFile]()
    var Users = [String: String]()
    var refresher: UIRefreshControl!
    
    
    
    func refresh() {
        print("refreshed")
        
        self.refresher.endRefreshing()
    }
    

    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var slide: UIBarButtonItem!
    
    
    var mainArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull To Refresh")
        refresher.addTarget(self, action: #selector(tableView.refresh), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refresher)
        
        
        let query = PFUser.query()
        
        query?.findObjectsInBackground(block: { (objects, error) -> Void in
            
            if let users = objects {
                
                self.messages.removeAll(keepingCapacity: true)
                self.Users.removeAll(keepingCapacity: true)
                self.imageFiles.removeAll(keepingCapacity: true)
                self.usernames.removeAll(keepingCapacity: true)
                
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        self.Users[user.objectId!] = user.username!
                        
                    }
                }
            }
            
            
            let getCookUsersQuery = PFQuery(className: "cookOrRestaurant")
            
            getCookUsersQuery.whereKey("cook", equalTo: PFUser.current()!.objectId!)
            
            getCookUsersQuery.findObjectsInBackground { (objects, error) -> Void in
                
                if let objects = objects {
                    
                    for object in objects {
                        
                        let cookPost = object["Cook"] as! String
                        
                        let query = PFQuery(className: "Post")
                        
                        query.whereKey("userId", equalTo: cookPost)
                        
                        query.findObjectsInBackground(block: { (objects, error) -> Void in
                            
                            if let objects = objects {
                                
                                for object in objects {
                                    
                                    self.messages.append(object["message"] as! String)
                                     self.messages.append(object["ingredients"] as! String)
                                    self.messages.append(object["foodName"] as! String)
                                    
                                    self.imageFiles.append(object["imageFile"] as! PFFile)
                                    
                                    self.usernames.append(self.Users[object["userId"] as! String]!)
                                    
                                    self.tableView.reloadData()
                                    
                                }
                                
                            }
                            
                            
                        })
                    }
                    
                }
                
            }
            
        })
        
        
        
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        slide.target = self.revealViewController()
        slide.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        
        
        
        
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath2: IndexPath) -> UITableViewCell {
        
        let myCell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath2) as! MainTableCell
        
        myCell.foodTitleLabel.text = "hello"
        
        myCell.foodImage.image = UIImage(named: "containerFood.png")
        myCell.profileImage.image = UIImage(named: "boocircle.png")
        
        
        
        /*
        imageFiles[indexPath2.row].getDataInBackgroundWithBlock { (data, error) -> Void in
        
        if let downloadedImage = UIImage(data: data!) {
        
        myCell.postedImage.image = foodTitleLabel
        
        
        }
        }*/
        
        
        
        
        
        /* myCell.username.text = usernames[indexPath2.row]
        
        myCell.message.text = messages[indexPath2.row]*/
        
        return myCell
        
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "moreFood") {
            let destVC = segue.destination as! MoreDetailedFoodView
            
            
            let indexPath2 : IndexPath = self.tableView.indexPathForSelectedRow!
            
            
            destVC.varView = (indexPath2 as NSIndexPath).row
        }
        
        
    }
    
    /*
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! cell
    
    imageFiles[indexPath.row].getDataInBackgroundWithBlock { (data, error) -> Void in
    
    if let downloadedImage = UIImage(data: data!) {
    
    myCell.postedImage.image = downloadedImage
    
    }
    
    }
    
    
    
    myCell.username.text = usernames[indexPath.row]
    
    myCell.message.text = messages[indexPath.row]
    
    return myCell
    }
    
    */
    
    
    /* override func viewDidAppear(animated: Bool) {
    
    _ = self.navigationController?.navigationBar
    
    
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    imageView.contentMode = .ScaleAspectFit
    
    let imageLogo = UIImage(named: "mahead2.png")
    imageView.image = imageLogo
    
    navigationItem.titleView = imageView
    
    
    }*/
}

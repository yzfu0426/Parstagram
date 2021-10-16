//
//  FeedViewController.swift
//  Parstagram
//
//  Created by 傅羽竹 on 2021/10/6.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var posts = [PFObject] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getData()
        tableView.rowHeight = 800
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getData()
    }
    
    func getData() {
        let query = PFQuery(className:"Posts")
        query.includeKeys(["author"])
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                // Log details of the failure
                print(error.localizedDescription)
            } else if let objects = objects {
                self.posts = objects
                //print(objects)
                self.tableView.reloadData()
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
        
        let post = posts[indexPath.row]
        //print(post["caption"])
        cell.captionLabel.text = post["caption"] as! String
        
        //User Image
        let author = post["author"] as! PFUser
        //print(author)
        let imageFile = author["profileImage"] as! PFFileObject
        let imageUrl = imageFile.url! //String
        let profileUrl = URL(string: imageUrl) //Object
        //cell.userProfile.af.setImage(for: .normal, url: profileUrl!)
        
        //Post Image
        let postImageFile = post["image"] as! PFFileObject
        let postUrl = postImageFile.url!
        let postImageUrl = URL(string: postUrl)
        //print(postUrl)
        cell.postImage.af.setImage(withURL: postImageUrl!)
        
        //af.setImage(for: .normal, url: postImageUrl!)
        
        //cell.userProfile.layer.cornerRadius = 50
        cell.userProfile.af.setBackgroundImage(for: .normal, url: postImageUrl!)
        cell.userProfile.clipsToBounds = true
        cell.userProfile.layer.cornerRadius = 50
        
        //layer.cornerRadius = 50
            
            
        //cell.userProfile.imageView!.frame.size.width / 2
        
        
        
        return cell
    }
    
    
    
    
}

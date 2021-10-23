//
//  FeedViewController.swift
//  Parstagram
//
//  Created by 傅羽竹 on 2021/10/6.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let commentBar = MessageInputBar()
    var showsCommentBar = false
    var posts = [PFObject] ()
    var selectedPost: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        getData()
        tableView.rowHeight = 800
        tableView.keyboardDismissMode = .interactive
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillBeHidden(note: Notification) {
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
    }
    
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return showsCommentBar
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getData()
    }
    
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        //Create the comment
        let comment = PFObject(className: "Comments")
        comment["text"] = text
        comment["post"] = selectedPost
        comment["author"] = PFUser.current()!
        
        selectedPost.add(comment, forKey: "comments")
        
        selectedPost.saveInBackground() { (success, error) in
            if success {
                print ("Comment saved!")
            } else {
                print("Error saving comment!")
            }
            
        }
        tableView.reloadData()
        
        //Clear and dismiss the input
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    
    @IBAction func onLogOutButton(_ sender: Any) {
        PFUser.logOut()
              let main = UIStoryboard(name : "Main", bundle: nil)
               let loginViewController = main.instantiateViewController(identifier: "loginViewController")
               let delegate = self.view.window?.windowScene?.delegate as! SceneDelegate
               delegate.window?.rootViewController = loginViewController
        
    }
    
//    @IBAction func onLogOutButton(_ sender: Any) {
//        PFUser.logOut()
//        let main = UIStoryboard(name : "Main", bundle: nil)
//        let loginViewController = main.instantiateViewController(identifier: "LoginViewController")
//        let delegate = self.view.window?.windowScene?.delegate as! SceneDelegate
//        delegate.window?.rootViewController = loginViewController
//        
//        
//    }
    
    
    func getData() {
        let query = PFQuery(className:"Posts")
        query.includeKeys(["author", "comments", "comments.author"])
        query.limit = 20
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        return comments.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
            
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
            
            cell.userName.setTitle(author["username"] as! String, for: .normal)
            
            return cell
        } else if indexPath.row <= comments.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell") as! CommmentTableViewCell
            
            let comment = comments[indexPath.row - 1]
            cell.commentLabel.text = comment["text"] as? String
            
            let user = comment["author"] as! PFUser
            
            cell.nameLabel.text = user.username
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellHeight: CGFloat = CGFloat()
        if indexPath.row == 0 {
            cellHeight = 630
        } else {
            cellHeight = 40
        }
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.section]
        
        let comments = (post["comments"] as? [PFObject]) ?? []
       
        if indexPath.row == comments.count + 1 {
            showsCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            
            selectedPost = post
        }
        
       
        
        
    }
    
    
    
    
}

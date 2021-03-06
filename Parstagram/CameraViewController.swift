//
//  CameraViewController.swift
//  Parstagram
//
//  Created by 傅羽竹 on 2021/10/6.
//

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onSubmitButton(_ sender: Any) {
        let post = PFObject(className: "Posts")
        let user = PFUser.current()!
        let imageData = imageView.image!.pngData()
        let imageFile = PFFileObject(data: imageData!)

        
        post["author"] = user
        post["caption"] = commentTextView.text
        post["image"] = imageFile
        
        post.saveInBackground { (success, error) in
            if success {
                user["numberOfPosts"] = user["numberOfPosts"] as! Int + 1
                let main = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = main.instantiateViewController(identifier: "mainTabBarController")
                self.view.window?.rootViewController = mainTabBarController
                //dismiss(animated: true, completion: nil)
                print("saved")
            } else {
                print("error!")
            }
            
            
        }
        
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af.imageScaled(to: size)
        
        imageView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

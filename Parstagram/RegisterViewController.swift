//
//  RegisterViewController.swift
//  Parstagram
//
//  Created by 傅羽竹 on 2021/10/5.
//

import UIKit
import Parse

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var UserNameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var FullNameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func onSignUp(_ sender: Any) {
        let user = PFUser()
        let imageData = UIImage(named: "profile_tab")!.pngData()
        
        user.username = UserNameTextField.text
        user.password = PasswordTextField.text
        user["fullname"] = FullNameTextField.text
        user["email"] = EmailTextField.text
        user["profileImage"] = PFFileObject(data: imageData!)!
        user["following"] = 0
        user["followers"] = 0
        user["numberOfPosts"] = 0
        user["description"] = ""
        
        user.signUpInBackground { (success, error) in
            if success {
                self.performSegue(withIdentifier: "loginSegueFromSignUp", sender: nil)
                
            } else {
                print("Error: \(error?.localizedDescription)")
            }
        }
        
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

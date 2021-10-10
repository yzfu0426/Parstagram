//
//  LoginViewController.swift
//  Parstagram
//
//  Created by 傅羽竹 on 2021/10/3.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
   
    @IBAction func onLogin(_ sender: Any) {
        let user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
        
        PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) {(user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                let alert = UIAlertController(title: "Wrong Credentials", message: "Invalid username or password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
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

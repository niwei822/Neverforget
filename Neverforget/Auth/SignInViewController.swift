//
//  SignInViewController.swift
//  Neverforget
//
//  Created by cecily li on 7/17/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

class SignInViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
   
    @IBOutlet weak var ForgotPWButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundimage = UIImageView(frame: UIScreen.main.bounds)
        backgroundimage.image = UIImage(named: "Lavender-Aesthetic-Wallpapers")
        backgroundimage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundimage, at: 0)
        
        emailField.layer.cornerRadius = 10
        emailField.clipsToBounds = true
        passwordField.layer.cornerRadius = 10
        passwordField.clipsToBounds = true
        signInButton.layer.cornerRadius = 10
        signInButton.clipsToBounds = true
        ForgotPWButton.layer.cornerRadius = 10
        ForgotPWButton.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        let defaults = UserDefaults.standard
        let auth = Auth.auth()
        auth.signIn(withEmail: emailField.text!, password: passwordField.text!) {(authResult, error) in
            if error != nil {
                self.present(Service.createAlertController(title: "Error", message: error!.localizedDescription), animated: true, completion: nil)
                return
            }
            defaults.set(true, forKey: "isuserSignedin")
            self.performSegue(withIdentifier: "userSignedInsegue", sender: nil)
        }
    }
    
    @IBAction func forgotPWButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "forgotPWsegue", sender: nil)
    }
}

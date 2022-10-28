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
        emailField.layer.masksToBounds = true
        emailField.layer.borderColor = UIColor.purple.cgColor
        emailField.layer.borderWidth = 0.1
        emailField.attributedPlaceholder = NSAttributedString(string: "Enter email:", attributes: [NSAttributedString.Key.foregroundColor: UIColor.purple])
        passwordField.layer.cornerRadius = 10
        passwordField.clipsToBounds = true
        passwordField.layer.masksToBounds = true
        passwordField.layer.borderColor = UIColor.purple.cgColor
        passwordField.layer.borderWidth = 0.1
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password:", attributes: [NSAttributedString.Key.foregroundColor: UIColor.purple])
        signInButton.layer.cornerRadius = 10
        signInButton.clipsToBounds = true
        ForgotPWButton.layer.cornerRadius = 10
        ForgotPWButton.clipsToBounds = true
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        let defaults = UserDefaults.standard
        UserFBController.signInUser(email: emailField.text ?? "", password: passwordField.text ?? "", onSuccess: {
            defaults.set(true, forKey: "isuserSignedin")
            self.performSegue(withIdentifier: "userSignedInsegue", sender: nil)
        }) { (error) in
            self.present(Service.createAlertController(title: "Error", message: error!.localizedDescription), animated: true, completion: nil)
        }
    }
    
    @IBAction func forgotPWButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "forgotPWsegue", sender: nil)
    }
}

extension SignInViewController: UITextFieldDelegate {
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
    }
}

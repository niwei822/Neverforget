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
        Service.setUpTextFieldUI(input: emailField, placeholderText: "Enter your email")
        Service.setUpTextFieldUI(input: passwordField, placeholderText: "Enter your password")
        setUpUI()
        
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    private func setUpUI() {
        let backgroundimage = UIImageView(frame: UIScreen.main.bounds)
        backgroundimage.image = UIImage(named: "Lavender-Aesthetic-Wallpapers")
        backgroundimage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundimage, at: 0)
        
        signInButton.layer.cornerRadius = 10
        signInButton.clipsToBounds = true
        ForgotPWButton.layer.cornerRadius = 10
        ForgotPWButton.clipsToBounds = true
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        let defaults = UserDefaults.standard
        UserFBController.signInUser(email: emailField.text ?? "", password: passwordField.text ?? "") { result in
            switch result {
            case .success:
                //to store a simple flag if user signs in
                defaults.set(true, forKey: "isuserSignedin")
                self.performSegue(withIdentifier: "userSignedInsegue", sender: nil)
            case .failure(let error):
                self.present(Service.createAlertController(title: "Error", message: error.localizedDescription), animated: true, completion: nil)
            }
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

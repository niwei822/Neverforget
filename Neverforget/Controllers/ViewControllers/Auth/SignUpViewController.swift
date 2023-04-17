//
//  SignUpViewController.swift
//  Neverforget
//
//  Created by cecily li on 7/17/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var signEmailField: UITextField!
    
    @IBOutlet weak var signPasswordField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    var activeTextField : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundimage = UIImageView(frame: UIScreen.main.bounds)
        backgroundimage.image = UIImage(named: "Lavender-Aesthetic-Wallpapers")
        backgroundimage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundimage, at: 0)
        userNameField.layer.cornerRadius = 10
        userNameField.clipsToBounds = true
        userNameField.layer.masksToBounds = true
        userNameField.layer.borderColor = UIColor.purple.cgColor
        userNameField.layer.borderWidth = 0.1
        userNameField.attributedPlaceholder = NSAttributedString(string: "Username:", attributes: [NSAttributedString.Key.foregroundColor: UIColor.purple])
        signEmailField.layer.cornerRadius = 10
        signEmailField.clipsToBounds = true
        signEmailField.layer.masksToBounds = true
        signEmailField.layer.borderColor = UIColor.purple.cgColor
        signEmailField.layer.borderWidth = 0.1
        signEmailField.attributedPlaceholder = NSAttributedString(string: "Enter email:", attributes: [NSAttributedString.Key.foregroundColor: UIColor.purple])
        signPasswordField.layer.cornerRadius = 10
        signPasswordField.clipsToBounds = true
        signPasswordField.layer.masksToBounds = true
        signPasswordField.layer.borderColor = UIColor.purple.cgColor
        signPasswordField.layer.borderWidth = 0.1
        signPasswordField.attributedPlaceholder = NSAttributedString(string: "Create password:", attributes: [NSAttributedString.Key.foregroundColor: UIColor.purple])
        signUpButton.layer.cornerRadius = 10
        signUpButton.clipsToBounds = true
        userNameField.delegate = self
        signEmailField.delegate = self
        signPasswordField.delegate = self
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        let defaults = UserDefaults.standard
        UserFBController.signUpUser(email: signEmailField.text!, password: signPasswordField.text!, name: userNameField.text!) { result in
            switch result {
            case .success:
                defaults.set(true, forKey: "isuserSignedin")
                self.performSegue(withIdentifier: "userSignedupsegue", sender: nil)
            case .failure(let error):
                self.present(Service.createAlertController(title: "Error", message: error.localizedDescription), animated: true, completion: nil)
            }
        }
    }
}

extension SignUpViewController: UITextFieldDelegate {
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
    }
}

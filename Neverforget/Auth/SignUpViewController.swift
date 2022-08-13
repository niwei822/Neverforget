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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundimage = UIImageView(frame: UIScreen.main.bounds)
        backgroundimage.image = UIImage(named: "Lavender-Aesthetic-Wallpapers")
        backgroundimage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundimage, at: 0)
        userNameField.layer.cornerRadius = 10
        userNameField.clipsToBounds = true
        signEmailField.layer.cornerRadius = 10
        signEmailField.clipsToBounds = true
        signPasswordField.layer.cornerRadius = 10
        signPasswordField.clipsToBounds = true
        signUpButton.layer.cornerRadius = 10
        signUpButton.clipsToBounds = true
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        let defaults = UserDefaults.standard
        Service.signUpUser(email: signEmailField.text!, password: signPasswordField.text!, name: userNameField.text!, onSuccess: {
            defaults.set(true, forKey: "isuserSignedin")
            self.performSegue(withIdentifier: "userSignedupsegue", sender: nil)
        }) { (error) in
            self.present(Service.createAlertController(title: "Error", message: error!.localizedDescription), animated: true, completion: nil)
        }
    }
}

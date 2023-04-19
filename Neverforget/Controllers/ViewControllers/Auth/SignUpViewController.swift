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
        
        setUpUI()
        Service.setUpTextFieldUI(input: userNameField, placeholderText: "Username:")
        Service.setUpTextFieldUI(input: signEmailField, placeholderText: "Enter email:")
        Service.setUpTextFieldUI(input: signPasswordField, placeholderText: "Create password:")
        
        userNameField.delegate = self
        signEmailField.delegate = self
        signPasswordField.delegate = self
    }
    
    private func setUpUI() {
        let backgroundimage = UIImageView(frame: UIScreen.main.bounds)
        backgroundimage.image = UIImage(named: "Lavender-Aesthetic-Wallpapers")
        backgroundimage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundimage, at: 0)
        signUpButton.layer.cornerRadius = 10
        signUpButton.clipsToBounds = true
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

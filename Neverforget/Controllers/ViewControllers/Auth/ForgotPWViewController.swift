//
//  ForgotPWViewController.swift
//  Neverforget
//
//  Created by cecily li on 7/17/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

class ForgotPWViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var SendButton: UIButton!
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
        SendButton.layer.cornerRadius = 10
        SendButton.clipsToBounds = true
        emailField.delegate = self
    }
    
    @IBAction func forgotPWButtonTapped(_ sender: Any) {
        UserFBController.forgotPassword(email: emailField.text ?? "") { result in
            switch result {
            case .success:
                let alert = Service.createAlertController(title: "Hurray", message: "A password reset email has been sent!")
                self.present(alert, animated: true, completion: nil)
            case .failure(let error):
                let alert = Service.createAlertController(title: "Error", message: error.localizedDescription )
                self.present(alert, animated: true, completion: nil)
            }
    }
}
}
extension ForgotPWViewController: UITextFieldDelegate {
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
    }
}

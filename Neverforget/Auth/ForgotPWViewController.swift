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
        let backgroundimage = UIImageView(frame: UIScreen.main.bounds)
        backgroundimage.image = UIImage(named: "Lavender-Aesthetic-Wallpapers")
        backgroundimage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundimage, at: 0)
        emailField.layer.cornerRadius = 10
        emailField.clipsToBounds = true
        SendButton.layer.cornerRadius = 10
        SendButton.clipsToBounds = true
        super.viewDidLoad()

       
    }
    
    @IBAction func forgotPWButtonTapped(_ sender: Any) {
        let auth = Auth.auth()
        auth.sendPasswordReset(withEmail: emailField.text!) { (error) in
            if let error = error {
                let alert = Service.createAlertController(title: "Error", message: error.localizedDescription)
                self.present(alert, animated: true, completion: nil)
                return
            }
            let alert = Service.createAlertController(title: "Hurray", message: "A password reset email has been sent!")
            self.present(alert, animated: true, completion: nil)
        }
    }
}

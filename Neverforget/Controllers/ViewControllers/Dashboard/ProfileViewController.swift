//
//  ProfileViewController.swift
//  Neverforget
//
//  Created by cecily li on 10/28/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController:
    UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func LogoutButtonTapped(_ sender: Any) {
        let auth = Auth.auth()
                do {
                    try auth.signOut()
                    let defaults = UserDefaults.standard
                    defaults.set(false, forKey: "isuserSignedin")
                    self.dismiss(animated: true, completion: nil)
                }catch let signOutError {
                    self.present(Service.createAlertController(title: "Error", message: signOutError.localizedDescription), animated: true, completion: nil)
                }
    }
    
    @IBAction func DeleteButtonTapped(_ sender: Any) {
        let defaults = UserDefaults.standard
        let alertController = UIAlertController(title: "Warning!", message: "Are you sure you want to delete your account? All the data associated with this account will be deleted.", preferredStyle: .alert)
        // Create OK button
        let OKAction = UIAlertAction(title: "Confirm", style: .default) { (action:UIAlertAction!) in
            // Code in this block will trigger when OK button tapped.
            UserFBController.deleteuser() { error in
                            if let error = error {
                                print("Error deleting user account: \(error.localizedDescription)")
                            } else {
                                defaults.set(false, forKey: "isuserSignedin")
                                self.performSegue(withIdentifier: "showHomePage", sender: nil)
                                print("User account deleted successfully")
                            }
                        }
                        
                    }
        alertController.addAction(OKAction)
        // Create Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
        }
        alertController.addAction(cancelAction)
        // Present Dialog message
        self.present(alertController, animated: true, completion:nil)
    }
}

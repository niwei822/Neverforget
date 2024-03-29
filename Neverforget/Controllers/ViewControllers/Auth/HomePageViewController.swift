//
//  HomePageViewController.swift
//  Neverforget
//
//  Created by cecily li on 7/17/22.
//

import UIKit

class HomePageViewController: UIViewController {
    
    @IBOutlet weak var SignUpButton: UIButton!
    
    @IBOutlet weak var SignInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        setUPUI()
        checkIfUserIsSignedIn()
    }
    
    private func setUPUI() {
        let backgroundimage = UIImageView(frame: UIScreen.main.bounds)
        backgroundimage.image = UIImage(named: "1234")
        backgroundimage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundimage, at: 0)
        
        SignUpButton.layer.cornerRadius = 10
        SignUpButton.clipsToBounds = true
    }
    
    private func checkIfUserIsSignedIn() {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "isuserSignedin") {
            // If user is signed in, present the welcome view controller
            let viewController = self.storyboard?.instantiateViewController(identifier: "welcomeViewID") as! UINavigationController
            viewController.modalTransitionStyle = .crossDissolve
            viewController.modalPresentationStyle = .overFullScreen
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func SignInButtonTapped(_ sender: Any) {
        // To go to the signin view.
        self.performSegue(withIdentifier: "signInsegue", sender: nil)
    }
    
    @IBAction func SignUpButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "signUpsegue", sender: nil)
    }
}

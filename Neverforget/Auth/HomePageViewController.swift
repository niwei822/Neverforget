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
        let backgroundimage = UIImageView(frame: UIScreen.main.bounds)
        backgroundimage.image = UIImage(named: "1234")
        backgroundimage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundimage, at: 0)
        SignUpButton.layer.cornerRadius = 10
        SignUpButton.clipsToBounds = true
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "isuserSignedin") {
            let viewController = self.storyboard?.instantiateViewController(identifier: "welcomeViewID") as! UINavigationController
            viewController.modalTransitionStyle = .crossDissolve
            viewController.modalPresentationStyle = .overFullScreen
            self.present(viewController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func SignInButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "signInsegue", sender: nil)
    }
    
    
    @IBAction func SignUpButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "signUpsegue", sender: nil)
    }
}

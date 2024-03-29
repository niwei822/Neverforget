//
//  Service.swift
//  Neverforget
//
//  Created by cecily li on 7/17/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

class Service {
    
    static func createAlertController(title:  String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            //alert.dismiss(animated: true, completion: nil)
            print("OK")
        }
        alert.addAction(okAction)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
//                    print("Cancel button tapped");
//                }
//                alert.addAction(cancelAction)
        return alert
    }
    
    static func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        return formatter.string(from: date)
    }
    
    static func stringToDate(date: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        return formatter.date(from: date)!
    }
    
    static func setUpTextFieldUI(input: UITextField, placeholderText: String) {
        input.layer.cornerRadius = 10
        input.clipsToBounds = true
        input.layer.masksToBounds = true
        input.layer.borderColor = UIColor.purple.cgColor
        input.layer.borderWidth = 0.1
        input.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.purple])
    }
}


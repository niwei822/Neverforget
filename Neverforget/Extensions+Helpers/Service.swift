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
    var entries: [[String : Dictionary<String, String>]]
    init() {
        entries = []
    }
    
    static func signUpUser(email: String, password: String, name: String, onSuccess: @escaping() -> Void, onError: @escaping (_ error: Error?) -> Void) {
        let auth = Auth.auth()
        auth.createUser(withEmail: email, password: password) {(authResult, error) in
            if error != nil {
                onError(error)
                //self.present(Service.createAlertController(titile: "Error", message: error!.localizedDescription), animated: true, completion: nil)
                return
            }
            uploadNewUserToDatabase(email: email, name: name, onSuccess: onSuccess)
        }
    }

    static func uploadNewUserToDatabase(email: String, name: String, onSuccess: @escaping() -> Void) {
        let rootref = Database.database().reference()
        let ref = rootref.child("users")
        let uid = Auth.auth().currentUser?.uid
        ref.child(uid!).setValue(["email":email, "name":name, "entries": ""])
        onSuccess()
    }
    
    public func getUserInfo(onSuccess: @escaping () -> Void, onError: @escaping (_ error: Error?) -> Void) {
        let ref = Database.database().reference()
        let defaults = UserDefaults.standard
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not found")
            return
        }
        ref.child("users").child(uid).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : Any] {
                let email = dictionary["email"] as! String
                let name = dictionary["name"] as! String
                defaults.set(email, forKey: "userEmailKey")
                defaults.set(name, forKey: "userNameKey")
                onSuccess()
            }
        }) { (error) in
            onError(error)
        }


        var entries: [[String : Dictionary<String, String>]] = []
        ref.child("users").child(uid).child("entries").observe(.value, with: { (snapshot) in
            entries = []
            for snap in snapshot.children {
                let userSnap = snap as! DataSnapshot
                //print(userSnap.key)
                let userdict = userSnap.value as? NSDictionary
                var eachEntry: [String: Dictionary] = [String: Dictionary<String, String>]()
                var tempDict : [String: String] = [:]
                tempDict["storeName"] = (userdict?.value(forKey: "storeName") as! String)
                tempDict["item"] = (userdict?.value(forKey: "item") as! String)
                tempDict["notes"] = (userdict?.value(forKey: "notes") as! String)
                tempDict["duedate"] = (userdict?.value(forKey: "duedate") as! String)
                tempDict["options"] = (userdict?.value(forKey: "options") as! String)
                eachEntry[userSnap.key] = tempDict
                entries.append(eachEntry)
                onSuccess()
            }
            self.entries = entries
            //print(self.entries)
        })
        { (error) in
            onError(error)
        }
    }
    
    static func createAlertController(title:  String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        return alert
    }
    
    static func uploadEntryToDatabase(storeName: String, itemName: String, notes: String, dueDate: String, options: String, timestamp: String) {
        let rootref = Database.database().reference()
        let ref = rootref.child("users")
        let uid = Auth.auth().currentUser?.uid
//        let count = ref.child(uid!).child("entries").observe(DataEventType.value, with: { (snapshot) in
//            print(snapshot.childrenCount)
//        })
//        print(count)
        //let timestamp = String(Int(NSDate().timeIntervalSince1970))
        ref.child(uid!).child("entries").updateChildValues([timestamp: [
            "storeName": storeName,
            "item": itemName,
            "notes": notes,
            "duedate": dueDate,
            "options": options
        ]])
    }
    
    static func deleteEntryFromDatebase(timestamp: String) {
        let rootref = Database.database().reference()
        let ref = rootref.child("users")
        let uid = Auth.auth().currentUser?.uid
        ref.child(uid!).child("entries").child(timestamp).removeValue { (error, ref) in
            if error != nil {
                print("error \(error)")
            }
        }
    }
    
    static func formattedDate(date: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        return formatter.string(from: date)
    }
}


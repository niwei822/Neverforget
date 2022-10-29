//
//  UserAuthrelated.swift
//  Neverforget
//
//  Created by cecily li on 8/4/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase
import UserNotifications

class UserFBController{
    
    var pickup_list : [PickupReturnModel] = []
    var return_list : [PickupReturnModel] = []
    var email = String()
    var name = String()
    
    static func signInUser(email: String, password: String, onSuccess: @escaping() -> Void, onError: @escaping (_ error: Error?) -> Void) {
        let auth = Auth.auth()
        auth.signIn(withEmail: email, password: password) {(authResult, error) in
            if error != nil {
                onError(error)
                return
            }
            onSuccess()
        }
        print("signin")
    }
    
    static func signUpUser(email: String, password: String, name: String, onSuccess: @escaping() -> Void, onError: @escaping (_ error: Error?) -> Void) {
        let auth = Auth.auth()
        auth.createUser(withEmail: email, password: password) {(authResult, error) in
            if error != nil {
                onError(error)
                return
            }
            uploadNewUserToDatabase(email: email, name: name, onSuccess: onSuccess)
        }
    }
    
    static func forgotPassword(email: String, onSuccess: @escaping() -> Void, onError: @escaping (_ error: Error?) -> Void) {
        let auth = Auth.auth()
        auth.sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                onError(error)
                return
            }
            onSuccess()
        }
    }
    
    static func deleteuser(){
        
        let rootref = Database.database().reference()
        let ref = rootref.child("users")
        let uid = Auth.auth().currentUser?.uid
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests() //remove all pending notifications
        
        ref.child(uid!).removeValue { (error, ref) in
            if error != nil {
                print(error?.localizedDescription ?? "error")
            }
        }
        
        let user = Auth.auth().currentUser
        user?.delete { error in
          if let error = error {
              print("Error Delete Account")
          } else {
              print("Account Deleted")
          }
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
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not found")
            return
        }
        ref.child("users").child(uid).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : Any] {
                //save email as userEmailKey's value
                self.email = dictionary["email"] as! String
                self.name = dictionary["name"] as! String
                onSuccess()
            }
        }) { (error) in
            onError(error)
        }
        ref.child("users").child(uid).child("entries").observe(.value, with: { (snapshot) in
            self.pickup_list = []
            self.return_list = []
           // print(self.pickup_list)
            for snap in snapshot.children {
                let userSnap = snap as! DataSnapshot
                //print(userSnap)
                let userdict = userSnap.value as? NSDictionary
                let formatteddate = Service.stringToDate(date: userdict?.value(forKey: "duedate") as! String)
                let entry = PickupReturnModel(storeName: userdict?.value(forKey: "storeName") as? String ?? "", itemTitle: (userdict?.value(forKey: "item") as? String), dueDate: formatteddate, remindDay: (userdict?.value(forKey: "remindDay") as? String)!, remindHour: (userdict?.value(forKey: "remindHour") as? String)!, remindMinute: (userdict?.value(forKey: "remindMinute") as? String)!, notes: userdict?.value(forKey: "notes") as? String, options: userdict?.value(forKey: "options") as! String, timestamp: userSnap.key)
                if entry.options == "Pickup" {
                    self.pickup_list.append(entry)
                } else if entry.options == "Return" {
                    self.return_list.append(entry)
                }
                onSuccess()
            }
        })
        { (error) in
            onError(error)
        }
    }
    
    static func uploadEntryToDatabase(storeName: String, itemName: String, notes: String, dueDate: String, remind_Day: String, remind_Hour: String, remind_Minute: String, options: String, timestamp: String) {
        let rootref = Database.database().reference()
        let ref = rootref.child("users")
        let uid = Auth.auth().currentUser?.uid
        ref.child(uid!).child("entries").updateChildValues([timestamp: [
            "storeName": storeName,
            "item": itemName,
            "notes": notes,
            "duedate": dueDate,
            "remindDay": remind_Day,
            "remindHour": remind_Hour,
            "remindMinute": remind_Minute,
            "options": options
        ]])
    }
    
    static func deleteEntryFromDatebase(timestamp: String) {
        let rootref = Database.database().reference()
        let ref = rootref.child("users")
        let uid = Auth.auth().currentUser?.uid
        ref.child(uid!).child("entries").child(timestamp).removeValue { (error, ref) in
            if error != nil {
                print(error?.localizedDescription ?? "error")
            }
        }
    }
}



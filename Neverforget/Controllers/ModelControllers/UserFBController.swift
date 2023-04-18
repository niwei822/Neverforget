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

enum UserFBError: Error {
    case currentUserNotFound
    case emailNotFound
    case nameNotFound
}

class UserFBController {
    
    var pickup_list : [PickupReturnModel] = []
    var return_list : [PickupReturnModel] = []
    var email = ""
    var name = ""
    // the completion closure takes a Result<Void, Error> parameter, where Void represents a successful result
    static func signInUser(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let auth = Auth.auth()
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    
    static func signUpUser(email: String, password: String, name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let auth = Auth.auth()
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                uploadNewUserToDatabase(email: email, name: name) { result in
                    switch result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    static func forgotPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let auth = Auth.auth()
        auth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    //Error by default is optional, either error or nil
    static func deleteuser(completion: @escaping (Error?) -> Void) {
        let rootref = Database.database().reference()
        let ref = rootref.child("users")
        let uid = Auth.auth().currentUser?.uid
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests() //remove all pending notifications
        
        ref.child(uid!).removeValue { (error, ref) in
            if let error = error {
                completion(error)
                return
            }
        }
        
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    static func uploadNewUserToDatabase(email: String, name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(UserFBError.currentUserNotFound))
            return
        }
        
        let rootRef = Database.database().reference()
        let usersRef = rootRef.child("users")
        let userRef = usersRef.child(uid)
        
        let values = ["email": email, "name": name, "entries": ""]
        
        userRef.setValue(values) { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    public func getUserInfo(onSuccess: @escaping () -> Void, onError: @escaping (_ error: Error?) -> Void) {
        let ref = Database.database().reference()
        guard let uid = Auth.auth().currentUser?.uid else {
            print("User not found")
            return
        }
        // observe the 'users' node in Firebase database
        ref.child("users").child(uid).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : Any] {
                //save email as userEmailKey's value
                self.email = dictionary["email"] as? String ?? ""
                self.name = dictionary["name"] as? String ?? ""
                onSuccess()
            }
        }) { (error) in
            onError(error)
        }
        // observe the 'entries' node for the user's pickups and returns
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

                                              

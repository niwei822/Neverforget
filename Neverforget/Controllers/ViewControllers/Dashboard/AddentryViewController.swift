//
//  AddentryViewController.swift
//  Neverforget
//
//  Created by cecily li on 7/17/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import DropDown
import UserNotifications

class AddentryViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    var options : String = ""
    var selectStore: String? = ""
    @IBOutlet weak var storeField: UITextField!
    
    @IBOutlet weak var itemDetailField: UITextField!
    
    @IBOutlet weak var notesField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    public var completion: ((String, String, String, Date, String) -> Void)?
    
    let dropdown = DropDown()
    let notificationCenter = UNUserNotificationCenter.current()
    var identifier : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundimage = UIImageView(frame: UIScreen.main.bounds)
        backgroundimage.image = UIImage(named: "Lavender-Aesthetic-Wallpapers")
        backgroundimage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundimage, at: 0)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapsaveButton))
        storeField.delegate = self
        itemDetailField.delegate = self
        notesField.delegate = self
        datePicker.overrideUserInterfaceStyle = .light
        //Requesting Notification Permission
        notificationCenter.requestAuthorization(options: [.alert,.badge,  .sound]) {
            (permissionGranted, error) in
            if(!permissionGranted)
            {
                print("Permission Denied")
            }
        }
    }
    
    @IBAction func checkPolicyButton(_ sender: UIButton) {
        dropdown.dataSource = ["Walmart", "Target", "Amazon", "Kohl's", "Costco", "DSW", "Apple", "Macy's"]
        dropdown.anchorView = sender
        dropdown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        dropdown.show()
        dropdown.selectionAction = { [weak self] (index: Int, store: String) in
            guard let _ = self else { return }
            sender.setTitle(store, for: .normal)
            self!.selectStore = store
        }
    }
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        guard let policy = storeReturnPolicy[self.selectStore!]
                
        else {
            self.present(Service.createAlertController(title: "Please note:", message: "Select which store you want to check."), animated: true, completion: nil)
            return
        }
        UIApplication.shared.open(URL(string: policy )! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func optionButtonTapped(_ sender: UIButton) {
        dropdown.dataSource = ["Return", "Pickup"]
        dropdown.anchorView = sender
        dropdown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        dropdown.show()
        dropdown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            sender.setTitle(item, for: .normal)
            self!.options = item
        }
    }
    
    @objc func didTapsaveButton() {
        notificationCenter.getNotificationSettings { (settings) in
            // completion block called on background thread
            //update settings property on the main
            //excute main thread first while updating UIalert
            DispatchQueue.main.async
            { [self] in
                let title = storeField.text
                let message =  options + " " + itemDetailField.text! + " " + notesField.text!
                let date = datePicker.date
                if(settings.authorizationStatus == .authorized)
                { ReminderController.shared.sendNotification(title: title ?? "", message: message, date: date, identifier: identifier)
                    self.present(Service.createAlertController(title: "Reminder Scheduled!", message: "At " + Service.formattedDate(date: self.datePicker.date)), animated: true, completion: nil)
                }
                else {
                    let ac = UIAlertController(title: "Enable reminders?", message: "To use this feature you must enable notifications in settings", preferredStyle: .alert)
                    let goToSettings = UIAlertAction(title: "Settings", style: .default)
                    { (_) in
                        guard let setttingsURL = URL(string: UIApplication.openSettingsURLString)
                        else
                        {
                            return
                        }
                        if(UIApplication.shared.canOpenURL(setttingsURL))
                        {
                            UIApplication.shared.open(setttingsURL) { (_) in}
                        }
                    }
                    ac.addAction(goToSettings)
                    ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in}))
                    self.present(ac, animated: true)
                }
            }
        }
        if let storeName = storeField.text, !storeName.isEmpty,
           let itemTitle = itemDetailField.text, !itemTitle.isEmpty,
           let note = notesField.text, !note.isEmpty {
            let targetDate = datePicker.date
            let dateStr = Service.formattedDate(date: targetDate)
            //print(self.options)
            if self.options.isEmpty{
                self.present(Service.createAlertController(title: "Please note:", message: "Select Pickup or Return."), animated: true, completion: nil)
            }
            let timestamp = String(Int(NSDate().timeIntervalSince1970))
            identifier = timestamp
            completion?(storeName, itemTitle, note, targetDate, timestamp)
            UserFBController.uploadEntryToDatabase(storeName: storeName, itemName: itemTitle, notes: note, dueDate: dateStr, options: self.options, timestamp: timestamp)
        }
    }
}

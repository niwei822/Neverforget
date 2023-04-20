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
    
    @IBOutlet weak var reminderDayField: UITextField!
    
    @IBOutlet weak var reminderHourField: UITextField!
    
    @IBOutlet weak var reminderMinuteField: UITextField!
    
    public var completion: ((String, String, String, Date, String) -> Void)?
    
    let dropdown = DropDown()
    let notificationCenter = UNUserNotificationCenter.current()
    var identifier : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpTextFields()
        requestNotificationPermission()
        setUpBackgroundUI()
    }

    private func setUpNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapsaveButton))
    }

    private func setUpTextFields() {
        Service.setUpTextFieldUI(input: storeField, placeholderText: "Enter store name:")
        Service.setUpTextFieldUI(input: itemDetailField, placeholderText: "What you want to return/pickup?")
        Service.setUpTextFieldUI(input: notesField, placeholderText: "Notes:")
        storeField.delegate = self
        itemDetailField.delegate = self
        notesField.delegate = self
        reminderDayField.delegate = self
        reminderHourField.delegate = self
        reminderMinuteField.delegate = self
        datePicker.overrideUserInterfaceStyle = .light
    }

    private func requestNotificationPermission() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (permissionGranted, error) in
            if(!permissionGranted) {
                print("Permission Denied")
            }
        }
    }

    private func setUpBackgroundUI() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Lavender-Aesthetic-Wallpapers")
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
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
        guard let policy = storeReturnPolicy[self.selectStore!]?[0]
                
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
            //update settings property on the main,send ui related work to main quene
            //excute main thread first while updating UIalert
            //The main queue is responsible for drawing UI and responding to user input.
            //Move UI-related work to the main queue
            DispatchQueue.main.async
            { [self] in
                // Get the values entered by the user
                let title = storeField.text
                let message =  options + " " + itemDetailField.text! + " " + notesField.text!
                let date = datePicker.date
                let reminderDay = reminderDayField.text
                let reminderHour = reminderHourField.text
                let reminderMinute = reminderMinuteField.text
                
                print(reminderDay! + "Days" + reminderHour! + "Hours" + reminderMinute! + "Minutes")
                if (settings.authorizationStatus == .authorized) {
                    if self.options.isEmpty{
                        self.present(Service.createAlertController(title: "Please note:", message: "Select Pickup or Return."), animated: true, completion: nil)
                    }
                    if (reminderDay! == "0" && reminderHour! == "0" && reminderMinute! == "0") {
                        ReminderController.shared.sendNotificationByDate(title: title ?? "", message: message, date: date, identifier: identifier)
                        self.present(Service.createAlertController(title: "Reminder Scheduled!", message: "At " + Service.formattedDate(date: self.datePicker.date)), animated: true, completion: nil)
                    } else {
                        // Send a notification at a frequency determined by the user
                        ReminderController.shared.sendNotificationByFrequency(title: title ?? "", message: message, remindDay: reminderDay!, remindHour: reminderHour!, remindMinute: reminderMinute!, identifier: identifier)
                        self.present(Service.createAlertController(title: "Reminder Scheduled!", message: "Remind every " + (reminderDay ?? "0") + "Days" + (reminderHour ?? "0") + "Hours" + (reminderMinute ?? "0") + "Minutes"), animated: true, completion: nil)
                    }
                } else {
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
        // If all required fields have been filled out, upload the entry to the database
        if let storeName = storeField.text, !storeName.isEmpty,
            let itemTitle = itemDetailField.text, !itemTitle.isEmpty,
            let note = notesField.text, !note.isEmpty,
            let remindDay = reminderDayField.text, !remindDay.isEmpty,
            let remindHour = reminderHourField.text, !remindHour.isEmpty,
            let remindMinute = reminderMinuteField.text, !remindMinute.isEmpty {
            let targetDate = datePicker.date
            let dateStr = Service.formattedDate(date: targetDate)
            if self.options.isEmpty{
                self.present(Service.createAlertController(title: "Please note:", message: "Select Pickup or Return."), animated: true, completion: nil)
            }
            let timestamp = String(Int(NSDate().timeIntervalSince1970))
            identifier = timestamp
            completion?(storeName, itemTitle, note, targetDate, timestamp)
            UserFBController.uploadEntryToDatabase(storeName: storeName, itemName: itemTitle, notes: note, dueDate: dateStr, remind_Day: remindDay, remind_Hour: remindHour, remind_Minute: remindMinute, options: self.options, timestamp: timestamp)
        }
    }
}

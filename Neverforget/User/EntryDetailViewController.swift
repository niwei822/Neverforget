//
//  EntryDetailViewController.swift
//  Neverforget
//
//  Created by cecily li on 7/17/22.
//

import UIKit
import DropDown
import UserNotifications

class EntryDetailViewController: UIViewController {
    
    @IBOutlet weak var OptionButton: UIButton!
    @IBOutlet weak var storeField: UITextField!
    @IBOutlet weak var itemDetailField: UITextField!
    @IBOutlet weak var notesField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var options : String? = ""
    var selectStore: String? = ""
    let dropdown = DropDown()
    var entry: PickupReturnModel?
    var date: Date?
    let notificationCenter = UNUserNotificationCenter.current()
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundimage = UIImageView(frame: UIScreen.main.bounds)
        backgroundimage.image = UIImage(named: "Lavender-Aesthetic-Wallpapers")
        backgroundimage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundimage, at: 0)
        updateViews()
        
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
        
    @IBAction func UpdateButtonTapped(_ sender: Any) {
        guard let storename = storeField.text, !storename.isEmpty,
              let item = itemDetailField.text, !item.isEmpty,
              let notes = notesField.text, !notes.isEmpty
        else { return }
        if self.date == nil {
            self.date = entry?.dueDate
        }
        if self.options == "" {
            self.options = entry?.options
        }
        Service.uploadEntryToDatabase(storeName: storename, itemName: item, notes: notes, dueDate: Service.formattedDate(date: self.date!), options: self.options!, timestamp: entry!.timestamp)
        let scheduler = NotificationSettings()
        let entry = PickupReturnModel(storeName: storename, itemTitle: item, dueDate: self.date!, notes: notes, options: self.options!, timestamp: entry!.timestamp)
        scheduler.removeScheduledNotification(for: entry)
        notificationCenter.getNotificationSettings { (settings) in

            DispatchQueue.main.async
            { [self] in
                let title = self.storeField.text!
                let message = (self.options ?? "") + " " + itemDetailField.text! + " " + self.notesField.text!
                let date = self.datePicker.date

                if(settings.authorizationStatus == .authorized)
                {
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.body = message

                    let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)

                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
                    let request = UNNotificationRequest(identifier: entry.timestamp, content: content, trigger: trigger)

                    self.notificationCenter.add(request) { (error) in
                        if(error != nil)
                        {
                            print("Error " + error.debugDescription)
                            return
                        }
                    }
                    let ac = UIAlertController(title: "Reminder Updated!", message: "At " + Service.formattedDate(date: date), preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in}))
                    self.present(ac, animated: true)
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func DatepickerTapped(_ sender: Any) {
        self.date = datePicker.date
    }
    
    @IBAction func optionButtonTapped(_ sender: UIButton) {
        dropdown.dataSource = ["Return", "Pickup"]
        dropdown.anchorView = sender
        //sender.setTitle(entry?.options, for: .normal)
        dropdown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        dropdown.show()
        dropdown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            sender.setTitle(item, for: .normal)
            self!.options = item
        }
    }
    
    func updateViews() {
        guard let entry = entry else { return }
        itemDetailField.text = entry.itemTitle
        storeField.text = entry.storeName
        notesField.text = entry.notes
        datePicker.date = entry.dueDate
    }
}



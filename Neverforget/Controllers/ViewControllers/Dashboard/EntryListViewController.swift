//
//  WelcomeViewController.swift
//  Neverforget
//
//  Created by cecily li on 7/17/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase
import UserNotifications
import CoreLocation

class EntryListViewController: UIViewController {
    
    @IBOutlet weak var WelcomeLabel: UILabel!
    
    @IBOutlet weak var table: UITableView!
    
    var reminders = [PickupReturnModel]()
    var user = UserFBController()
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        table.backgroundView = UIImageView(image: UIImage(named: "Lavender-Aesthetic-Wallpapers"))
        table.delegate = self
        table.dataSource = self
        readDate()
        locationManager.requestAlwaysAuthorization()
    }
    
    func readDate() {
        //let defaults = UserDefaults.standard
        user.getUserInfo(onSuccess: { [self] in
            ReminderController.shared.Pickup = self.user.pickup_list
            ReminderController.shared.Return = self.user.return_list
            self.table.reloadData()
            self.WelcomeLabel.font = UIFont(name: "NoteWorthy", size: 20)
            //get user name by looking at the userNameKey
            self.WelcomeLabel.text = "Welcome \(user.name)"
            //self.WelcomeLabel.text = "Welcome"
        }) { (error) in
            self.present(Service.createAlertController(title: "Error", message: error!.localizedDescription), animated: true, completion: nil)
        }
    }
    
//    @IBAction func LogoutButtonTapped(_ sender: Any) {
//        let auth = Auth.auth()
//        do {
//            try auth.signOut()
//            let defaults = UserDefaults.standard
//            defaults.set(false, forKey: "isuserSignedin")
//            self.dismiss(animated: true, completion: nil)
//        }catch let signOutError {
//            self.present(Service.createAlertController(title: "Error", message: signOutError.localizedDescription), animated: true, completion: nil)
//        }
//    }
    
    @IBAction func didTapAdd(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "add") as? AddentryViewController else {
            return
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { storename, item, note, date, timestamp in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension EntryListViewController: UITableViewDelegate, UITableViewDataSource {
    //
    func numberOfSections(in tableView: UITableView) -> Int {
        return ReminderController.shared.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReminderController.shared.sections[section].count
    }
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionCell = ReminderController.shared.sections[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.font = UIFont(name: "NoteWorthy", size: 15)
        cell.textLabel?.text = sectionCell.storeName + " " + (sectionCell.itemTitle ?? "") + " " + sectionCell.notes!
        let date = sectionCell.dueDate
        cell.detailTextLabel?.font = UIFont(name: "NoteWorthy", size: 15)
        cell.detailTextLabel?.text = "Due Date: " + Service.formattedDate(date: date)
        return cell
    }
    ///Tells the delegate a row is selected.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    ///Asks the delegate for a view to display in the header of the specified section of the table view
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header1 = UIView()
            let sectionLabel1 = UILabel(frame: CGRect(x: 8, y: 28, width:
                                                        tableView.bounds.size.width, height: tableView.bounds.size.height))
            sectionLabel1.font = UIFont(name: "NoteWorthy", size: 15)
            sectionLabel1.textColor = UIColor.purple
            sectionLabel1.text = "Return"
            sectionLabel1.sizeToFit()
            header1 .addSubview(sectionLabel1)
            return header1
        } else if section == 1 {
            let header2 = UIView()
            let sectionLabel2 = UILabel(frame: CGRect(x: 8, y: 28, width:
                                                        tableView.bounds.size.width, height: tableView.bounds.size.height))
            sectionLabel2.font = UIFont(name: "NoteWorthy", size: 15)
            sectionLabel2.textColor = UIColor.purple
            sectionLabel2.text = "Pickup"
            sectionLabel2.sizeToFit()
            header2 .addSubview(sectionLabel2)
            return header2
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    //Asks the data source to commit the insertion or deletion of a specified row.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = ReminderController.shared.sections[indexPath.section][indexPath.row]
            ReminderController.shared.deleteEntry(entry)
            tableView.deleteRows(at: [indexPath], with: .fade)
            let id = entry.timestamp
            Database.database().reference().child("entries").child(id).removeValue()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEntryDetail" {
            guard let indexPath = table.indexPathForSelectedRow,
                  let destination = segue.destination as? EntryDetailViewController
            else { return }
            let entry = ReminderController.shared.sections[indexPath.section][indexPath.row]
            destination.entry = entry
        }
    }
}


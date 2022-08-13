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

class EntryListViewController: UIViewController {

    @IBOutlet weak var WelcomeLabel: UILabel!
    
    @IBOutlet weak var table: UITableView!
    
    var reminders = [PickupReturnModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        table.backgroundView = UIImageView(image: UIImage(named: "Lavender-Aesthetic-Wallpapers"))
        //        UINavigationBarAppearance().backgroundColor = .systemBlue
        //navigationController?.setNavigationBarHidden(true, animated: true)
        table.delegate = self
        table.dataSource = self
        readDate()
        
       // self.table.reloadData()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        readDate()
//        self.table.reloadData()
//    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        //self.viewDidLoad()
//        self.table.reloadData()
//    }
    func readDate() {
        let defaults = UserDefaults.standard
        let service = Service()
        service.getUserInfo(onSuccess: {
            var tmpPickup: [PickupReturnModel] = []
            var tmpReturn: [PickupReturnModel] = []
            for entry in service.entries{
                print("@@@@@@@@@@@@@@@@@@@@@@@@@")
                print(entry)
                for key in entry.keys{
                    let duedate = DateFormatter()
                    duedate.dateFormat = "MM-dd-yyyy HH:mm"
                    let dateStr = duedate.date(from: entry[key]!["duedate"]!)
                    let new = PickupReturnModel(storeName: entry[key]!["storeName"]!, itemTitle: entry[key]!["item"], dueDate: dateStr!, notes: entry[key]!["notes"], options: entry[key]!["options"]!, timestamp: key)
                    //self.reminders.append(new)
                    if entry[key]!["options"] == "Pickup" {
                        tmpPickup.append(new)
                    } else if entry[key]!["options"] == "Return" {
                        tmpReturn.append(new)
                    }
                }
            }
            
            guard !tmpPickup.isEmpty || !tmpReturn.isEmpty else { return }
                        
            ReminderController.shared.Pickup = tmpPickup
            ReminderController.shared.Return = tmpReturn
            
         
            self.table.reloadData()
            self.WelcomeLabel.font = UIFont(name: "Lucy Said Ok Personal Use", size: 30)
            //self.WelcomeLabel.textColor = UIColor(red: 126.0, green: 52.0, blue: 120.0, alpha: 1.0)
            self.WelcomeLabel.text = "Welcome \(defaults.string(forKey: "userNameKey")!)"
        }) { (error) in
            self.present(Service.createAlertController(title: "Error", message: error!.localizedDescription), animated: true, completion: nil)
        }
    }
    
    @IBAction func LogoutButtonTapped(_ sender: Any) {
        let auth = Auth.auth()
        do {
            try auth.signOut()
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: "isuserSignedin")
            self.dismiss(animated: true, completion: nil)
            //exit(0)
        }catch let signOutError {
            self.present(Service.createAlertController(title: "Error", message: signOutError.localizedDescription), animated: true, completion: nil)
        }
    }

    @IBAction func didTapAdd(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "add") as? AddentryViewController else {
            return
        }
        //vc.title = "New Reminder"
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
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return ReminderController.shared.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReminderController.shared.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionCell = ReminderController.shared.sections[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.font = UIFont(name: "Deysia Brush", size: 15)
        cell.textLabel?.text = sectionCell.storeName + " " + (sectionCell.itemTitle ?? "") + " " + sectionCell.notes!
    
        let date = sectionCell.dueDate
        //print(reminders)
        cell.detailTextLabel?.font = UIFont(name: "Deysia Brush", size: 15)
        cell.detailTextLabel?.text = "Due Date: " + Service.formattedDate(date: date)

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let header1 = UIView()
            //header1.backgroundColor = UIColor.
            let sectionLabel1 = UILabel(frame: CGRect(x: 8, y: 28, width:
                                                        tableView.bounds.size.width, height: tableView.bounds.size.height))
            sectionLabel1.font = UIFont(name: "Lucy Said Ok Personal Use", size: 20)
            
            sectionLabel1.textColor = UIColor.purple
            sectionLabel1.text = "Return"
            sectionLabel1.sizeToFit()
            header1 .addSubview(sectionLabel1)
            return header1
            
        } else if section == 1 {
            let header2 = UIView()
            //header2.backgroundColor = UIColor.systemCyan
            let sectionLabel2 = UILabel(frame: CGRect(x: 8, y: 28, width:
                                                        tableView.bounds.size.width, height: tableView.bounds.size.height))
            sectionLabel2.font = UIFont(name: "Lucy Said Ok Personal Use", size: 20)
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


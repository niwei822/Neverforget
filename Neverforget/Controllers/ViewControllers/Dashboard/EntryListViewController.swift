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

    // MARK: - Properties
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var table: UITableView!

//    private let model = EntryList(user: UserFBController(), locationManager: CLLocationManager())
   //    var sections: [[PickupReturnModel]] {
   //        return [model.pickups, model.returns]
   //    }
    private let user = UserFBController()
    private let locationManager = CLLocationManager()

    var sections: [[PickupReturnModel]] {
        return [returns, pickups]
    }
    var returns = [PickupReturnModel]()
    var pickups = [PickupReturnModel]()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        readData()
        // triggers the location permission dialog
        locationManager.requestAlwaysAuthorization()
    }

    private func setupTableView() {
        table.backgroundView = UIImageView(image: UIImage(named: "Lavender-Aesthetic-Wallpapers"))
        table.delegate = self
        table.dataSource = self
    }

    func readData() {
        //let defaults = UserDefaults.standard
        user.getUserInfo(
            onSuccess: { [weak self] in
                guard let self = self else { return }
                self.pickups = self.user.pickup_list
                self.returns = self.user.return_list
                self.table.reloadData()
                self.configureWelcomeLabel(with: self.user.name)
            },
            onError: { [weak self] error in
                self?.present(Service.createAlertController(title: "Error", message: error?.localizedDescription ?? ""), animated: true, completion: nil)
            }
        )
    }

    private func configureWelcomeLabel(with name: String) {
        welcomeLabel.font = UIFont(name: "NoteWorthy", size: 20)
        welcomeLabel.text = "Welcome \(name)"
    }

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
        return  sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  sections[section].count
    }
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionCell = sections[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.font = UIFont(name: "NoteWorthy", size: 15)
        cell.textLabel?.text = "\(sectionCell.storeName) \(sectionCell.itemTitle ?? "") \(sectionCell.notes!)"
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
        let header = UIView()
        let sectionLabel = UILabel(frame: CGRect(x: 8, y: 28, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        
        sectionLabel.font = UIFont(name: "NoteWorthy", size: 15)
        sectionLabel.textColor = UIColor.purple
        
        if section == 0 {
            sectionLabel.text = "Return"
        } else if section == 1 {
            sectionLabel.text = "Pickup"
        }
        
        sectionLabel.sizeToFit()
        header.addSubview(sectionLabel)
        
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    //Asks the data source to commit the insertion or deletion of a specified row.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = sections[indexPath.section][indexPath.row]
            deleteEntry(entry)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func deleteEntry(_ entry: PickupReturnModel) {
        if let index = returns.firstIndex(of: entry) {
            returns.remove(at: index)
        } else if let index = pickups.firstIndex(of: entry) {
            pickups.remove(at: index)
        }
        UserFBController.deleteEntryFromDatebase(timestamp: entry.timestamp)
        ReminderController.shared.removeScheduledNotification(for: entry)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showEntryDetail",
              let indexPath = table.indexPathForSelectedRow,
              let destination = segue.destination as? EntryDetailViewController
        else {
            print("Error: invalid segue or destination")
            return
        }
        let entry = sections[indexPath.section][indexPath.row]
        destination.entry = entry
    }
}


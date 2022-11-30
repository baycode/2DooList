//
//  ViewController.swift
//  TwoDoo
//
//  Created by Bayram Ayyildiz on 2022-11-07.
//

import UIKit
import UserNotifications

class TwoDooViewController: UIViewController {
    
    

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    
    var twoDooItems: [TwoDooItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        
        // Put all of what you need when the app launching.
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
        autherizeLocalNotification()
    }
    
    // Notification Authoruzation
    func autherizeLocalNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard error == nil else {
                print("ERROR: \(error!.localizedDescription)")
                return
            }
            if granted {
                print("Notifications Authoruzation Granted")
            } else {
                print("The User has denied notifications")
            }
            
        }
    }
    
    func setNotifications() {
        guard twoDooItems.count > 0 else {
            return
        }
        //Remove Notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // re-create with updated data
        for index in 0..<twoDooItems.count {
            if twoDooItems[index].reminderSet {
                let twoDooItem = twoDooItems[index]
                twoDooItems[index].notitificationID = setCalendarNatification(title: twoDooItem.name, subtitle: "", body: twoDooItem.notes, badgeNumber: nil, sound: .default, date: twoDooItem.date)
            }
        }
    }
    
    func setCalendarNatification(title: String, subtitle: String, body: String, badgeNumber: NSNumber?, sound: UNNotificationSound?, date: Date) -> String {
        // Notification content
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = sound
        content.badge = badgeNumber
        
        // Notification Trigger
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        dateComponents.second = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // Notification Request
        let notificationID = UUID().uuidString
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        
        //Register Request
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("ERROR: \(error.localizedDescription) adding notification request went wrong!")
            } else {
                print("Notification scheduled \(notificationID), title: \(content.title)")
            }
        }
        return notificationID
    }
    
    // Load Data
    func loadData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("twodooitems").appendingPathExtension("json")
        
        guard let data = try? Data(contentsOf: documentURL) else {return}
        let jsonDecoder = JSONDecoder()
        do {
            twoDooItems = try jsonDecoder.decode(Array<TwoDooItem>.self, from: data)
            tableView.reloadData()
        } catch {
            print("Error! Could not load data \(error.localizedDescription)")
        }
    }
    
    // Save the data to Device
    func saveData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("twodooitems").appendingPathExtension("json")
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(twoDooItems)
        do {
            try data?.write(to: documentURL, options: .noFileProtection)
        } catch {
            print("Error! Could not save data \(error.localizedDescription)")
        }
        setNotifications()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! TwoDooDetailTableViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.twoDooItem = twoDooItems[selectedIndexPath.row]
        } else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    // Get the data from DetailsVC
    @IBAction func updatedFromDetail(segue: UIStoryboardSegue) {
        let source = segue.source as! TwoDooDetailTableViewController
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            twoDooItems[selectedIndexPath.row] = source.twoDooItem
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: twoDooItems.count, section: 0)
            twoDooItems.append(source.twoDooItem)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
        saveData()
    }

    
    // Edit Button Pressed Function
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
            addBarButton.isEnabled = false
        }
    }
    
}

extension TwoDooViewController: UITableViewDelegate, UITableViewDataSource, ListTableViewCellDelegate {
    func checkBoxToggle(sender: ListTableViewCell) {
        if let selectedIndexPath = tableView.indexPath(for: sender) {
            twoDooItems[selectedIndexPath.row].completed = !twoDooItems[selectedIndexPath.row].completed
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            saveData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return twoDooItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
        cell.delegate = self
        cell.twoDooItem = twoDooItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            twoDooItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveData()
        }
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = twoDooItems[sourceIndexPath.row]
        twoDooItems.remove(at: sourceIndexPath.row)
        twoDooItems.insert(itemToMove, at: destinationIndexPath.row)
        saveData()
    }
    
}

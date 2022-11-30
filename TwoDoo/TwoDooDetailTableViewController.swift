//
//  TwoDooDetailTableViewController.swift
//  TwoDoo
//
//  Created by Bayram Ayyildiz on 2022-11-07.
//

import UIKit
import UserNotifications

//Date Formatter - We can use it just in this file.(Private)
private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .short
    return dateFormatter
}()

class TwoDooDetailTableViewController: UITableViewController {
    
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteView: UITextView!
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var dateLabel: UILabel!
    
    var twoDooItem: TwoDooItem!
    
    let datePickerIndexPath = IndexPath(row: 1, section: 1)
    let notesTextViewIndexPath = IndexPath(row: 0, section: 2)
    
    // In the extension, it is return to CGFloat
    let notesRowHeight: CGFloat = 200
    let defaultRowHeight: CGFloat = 44
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Hide Keyboard if users click to outside of field
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    
        
        nameField.delegate = self
        
        if twoDooItem == nil {
            twoDooItem = TwoDooItem(name: "", date: Date().addingTimeInterval(24*60*60), notes: "", reminderSet: false, completed: false)
            nameField.becomeFirstResponder()
        }
        updateUserInterface()
    }
    
    func updateUserInterface() {
        nameField.text = twoDooItem.name
        datePicker.date = twoDooItem.date
        noteView.text = twoDooItem.notes
        reminderSwitch.isOn = twoDooItem.reminderSet
        //For change the reminder switch color use the ternary operator
        dateLabel.textColor = (reminderSwitch.isOn ? .black : .gray)
        dateLabel.text = dateFormatter.string(from: twoDooItem.date)
        enableDisableSaveButton(text: nameField.text!)
        
//        if reminderSwitch.isOn {
//            dateLabel.textColor = .black
//        } else {
//            dateLabel.textColor = .gray
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        twoDooItem = TwoDooItem(name: nameField.text!, date: datePicker.date, notes: noteView.text, reminderSet: reminderSwitch.isOn, completed: twoDooItem.completed)
    }
    
    func enableDisableSaveButton(text:String) {
        if text.count > 0 {
            saveBarButton.isEnabled = true
        } else {
            saveBarButton.isEnabled = false
        }
    }

    
    // Cancel Button Pressed Function
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func reminderSwitchChanged(_ sender: UISwitch) {
        // Keyboard dismiss when click the date picker
        self.view.endEditing(true)
        dateLabel.textColor = (reminderSwitch.isOn ? .black : .gray)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        // Keyboard dismiss when click the date picker
        self.view.endEditing(true)
        dateLabel.text = dateFormatter.string(from: sender.date)
        
    }
    
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        enableDisableSaveButton(text: sender.text!)
    }
    
}

extension TwoDooDetailTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath:
            return reminderSwitch.isOn ? datePicker.frame.height : 0
        case notesTextViewIndexPath:
            return notesRowHeight
        default:
            return defaultRowHeight
            
        }
    }
}
//Keyboard return key
extension TwoDooDetailTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        noteView.becomeFirstResponder()
        return true
    }
}

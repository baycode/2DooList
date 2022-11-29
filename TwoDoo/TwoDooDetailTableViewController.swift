//
//  TwoDooDetailTableViewController.swift
//  TwoDoo
//
//  Created by Bayram Ayyildiz on 2022-11-28.
//

import UIKit

class TwoDooDetailTableViewController: UITableViewController {
    
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteView: UITextView!
    
    var twoDooItem: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if twoDooItem == nil {
            twoDooItem = ""
        }
        nameField.text = twoDooItem
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        twoDooItem = nameField.text
    }


    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
}

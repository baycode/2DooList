//
//  ViewController.swift
//  TwoDoo
//
//  Created by Bayram Ayyildiz on 2022-11-19.
//

import UIKit

class TwoDooViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var twoDooArray = ["Walmart Shopping", "Work meeting", "Online Shopping", "To do Assignment"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! TwoDooDetailTableViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.twoDooItem = twoDooArray[selectedIndexPath.row]
        } else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    @IBAction func updatedFromDetail(segue: UIStoryboardSegue) {
        let source = segue.source as! TwoDooDetailTableViewController
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            twoDooArray[selectedIndexPath.row] = source.twoDooItem
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: twoDooArray.count, section: 0)
            twoDooArray.append(source.twoDooItem)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
        
    }

 
}

extension TwoDooViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return twoDooArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = twoDooArray[indexPath.row]
        return cell
    }
}

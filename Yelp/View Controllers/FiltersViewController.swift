//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Tran Khanh Trung on 10/22/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String])
}
class FiltersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate?
    var categories: [[String:String]]!
    var switchStates = [Int:Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        categories = YelpClient.yelpCategories()
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSearchButtonTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        
        var filters = [String]()
        for (row, isSelected) in switchStates{
            if isSelected {
                filters.append(categories[row]["code"]!)
            }
        }
        if filters.count > 0 {
            delegate?.filtersViewController(filtersViewController: self, didUpdateFilters: filters)
        }
    }
    
    @IBAction func onCancelButtonTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}

extension FiltersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categories != nil {
            return categories.count
        } else {
            return 0 
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
        cell.switchLabel.text = categories[indexPath.row]["name"]
        
        cell.delegate = self
        cell.onSwitch.isOn = switchStates[indexPath.row] ?? false

        return cell
    }
}

extension FiltersViewController: SwitchCellDelegate {
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)!
        switchStates[indexPath.row] = value
    }
}

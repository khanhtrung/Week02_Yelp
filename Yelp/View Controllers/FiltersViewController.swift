//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Tran Khanh Trung on 10/22/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

let CATEGORY_NAME = "Category"
let SORT_NAME = "Sort"
let DISTANCE_NAME = "Distance"
let DEALS_NAME = "Deals"
let LIMIT_NAME = "Limit"

let CATEGORY_INDEX = 0
let SORT_INDEX = 1
let DISTANCE_INDEX = 2
let DEALS_INDEX = 3
let LIMIT_INDEX = 4

let SORT_BEST_MATCHED = "Best matched"
let SORT_DISTANCE = "Distance"
let SORT_HIGHEST_RATED = "Highest Rated"

let DISTANCE_BEST_MATCHED = "Best matched"
let DISTANCE_0_3 = "0.3 miles"
let DISTANCE_1 = "1 mile"
let DISTANCE_5 = "5 miles"
let DISTANCE_20 = "20 miles"

let DEALS_OFFERING = "Offering a Deal"

let LIMIT_NONE = "None"
let LIMIT_5 = "5 results to return"
let LIMIT_10 = "10 results to return"
let LIMIT_15 = "15 results to return"


@objc protocol FiltersViewControllerDelegate {
    @objc func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String])
}

class FiltersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate?
    var sectionNames: [String]!
    
    var sortSwitchOn = true
    var distanceSwitchOn = true
    
    var switchStates = [Int:Bool]()
    var sortCheckStates = [Int:Bool]()
    var distanceCheckStates = [Int:Bool]()
    var dealsCheckStates = [Int:Bool]()
    var limitCheckStates = [Int:Bool]()
    
    var categories: [[String:String]]!
    var categoryNames: [String]!
    var sortName: [String]!
    var distanceName: [String]!
    var dealsValue: [String]!
    var limitName: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        categories = YelpClient.yelpCategories()
        createSections()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSearchButtonTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        
        var categoriesFilters = [String]()
        for (row, isSelected) in switchStates{
            if isSelected {
                categoriesFilters.append(categories[row]["code"]!)
            }
        }
        //        if categoriesFilters.count > 0 {
        //BusinessFilters.sharedInstance.categories = categoriesFilters
        delegate?.filtersViewController(filtersViewController: self, didUpdateFilters: categoriesFilters)
        
        //        }
    }
    
    @IBAction func onCancelButtonTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func createSections(){
        self.sectionNames = [String]()
        self.sectionNames = [CATEGORY_NAME,SORT_NAME,DISTANCE_NAME,DEALS_NAME,LIMIT_NAME]
        
        self.categoryNames = [String]()
        for item in self.categories {
            self.categoryNames.append(item["name"]! as String)
        }
        
        self.sortName = [String]()
        self.sortName = [SORT_BEST_MATCHED, SORT_DISTANCE, SORT_HIGHEST_RATED]
        
        self.distanceName = [String]()
        self.distanceName = [DISTANCE_BEST_MATCHED,DISTANCE_0_3,DISTANCE_1,DISTANCE_5,DISTANCE_20]
        
        self.dealsValue = [String]()
        self.dealsValue = [DEALS_OFFERING]
        
        self.limitName = [String]()
        self.limitName = [LIMIT_NONE,LIMIT_5,LIMIT_10,LIMIT_15]
    }
}

//MARK: - Table methods
extension FiltersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section] as String
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case CATEGORY_INDEX:
            return self.categoryNames.count
            
        case SORT_INDEX:
            return self.sortName.count
            
        case DISTANCE_INDEX:
            return self.distanceName.count
            
        case DEALS_INDEX:
            return dealsValue.count
            
        case LIMIT_INDEX:
            return self.limitName.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch (indexPath as NSIndexPath).section {
        case CATEGORY_INDEX:
            return 44
            
        case SORT_INDEX:
            if sortSwitchOn {
                return 44
            } else {
                return (indexPath as NSIndexPath).row == 0 ? 44 : 0
            }
            
        case DISTANCE_INDEX:
            if distanceSwitchOn {
                return 44
            } else {
                return (indexPath as NSIndexPath).row == 0 ? 44 : 0
            }
            
        case DEALS_INDEX:
            return 44
            
        case LIMIT_INDEX:
            return 44
        default: return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath as NSIndexPath).section {
            
        case CATEGORY_INDEX:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            cell.switchLabel.text = categories[indexPath.row]["name"]
            cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
            cell.delegate = self
            return cell
            
        case SORT_INDEX:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckCell", for: indexPath) as! CheckCell
            cell.checkLabel.text = sortName[indexPath.row]
            cell.sectionName = SORT_NAME
            
            // Check Best Matched as Default
            if (sortName[indexPath.row] == SORT_BEST_MATCHED) {
                sortCheckStates[indexPath.row] = true
                BusinessFilters.sharedInstance.sort = sortName.index(of:SORT_BEST_MATCHED)
            }
            cell.isChecked = sortCheckStates[indexPath.row] ?? false
            cell.delegate = self
            return cell
            
        case DISTANCE_INDEX:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckCell", for: indexPath) as! CheckCell
            cell.checkLabel.text = distanceName[indexPath.row]
            cell.sectionName = DISTANCE_NAME
            
            // Check Best Matched as Default
            if (distanceName[indexPath.row] == DISTANCE_BEST_MATCHED) {
                distanceCheckStates[indexPath.row] = true
                BusinessFilters.sharedInstance.radius = distanceName.index(of:SORT_BEST_MATCHED)
            }
            cell.isChecked = distanceCheckStates[indexPath.row] ?? false
            cell.delegate = self
            return cell
            
        case DEALS_INDEX:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckCell", for: indexPath) as! CheckCell
            cell.checkLabel.text = dealsValue[indexPath.row]
            cell.sectionName = DEALS_NAME
            cell.isChecked = dealsCheckStates[indexPath.row] ?? false
            cell.delegate = self
            return cell
            
        case LIMIT_INDEX:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckCell", for: indexPath) as! CheckCell
            cell.checkLabel.text = limitName[indexPath.row]
            cell.sectionName = LIMIT_NAME
            
            // Check unlimit as Default
            if (limitName[indexPath.row] == LIMIT_NONE) {
                limitCheckStates[indexPath.row] = true
                BusinessFilters.sharedInstance.limit = limitName.index(of:LIMIT_NONE)
            }
            cell.isChecked = limitCheckStates[indexPath.row] ?? false
            cell.delegate = self
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}

//MARK: - Switch Cell methods
extension FiltersViewController: SwitchCellDelegate {
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)!
        switchStates[indexPath.row] = value
    }
}

//MARK: - Dropdown Cell methods
extension FiltersViewController: DropdownCellDelegate {
    func dropdownCell(dropdownCell: DropdownCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: dropdownCell)!
        switchStates[indexPath.row] = value
        //tableView.reloadSections(IndexSet(ixnteger: 1), with: .automatic)
    }
}

//MARK: - Check Cell methods
extension FiltersViewController: CheckCellDelegate {
    func checkCell(checkCell: CheckCell, didChangeValue value: Bool) {
        
        let indexPath = tableView.indexPath(for: checkCell)!
        switch checkCell.sectionName{
            
        case SORT_NAME:
            // Allow only one cell checked
            for row in 0..<tableView.numberOfRows(inSection: SORT_INDEX){
                let currentIndexPath = NSIndexPath(row: row, section: SORT_INDEX)
                let cell = tableView.cellForRow(at: currentIndexPath as IndexPath) as! CheckCell
                if currentIndexPath as IndexPath == indexPath{
                    cell.isChecked = true
                } else {
                    cell.isChecked = false
                }
                sortCheckStates[row] = cell.isChecked
            }
            BusinessFilters.sharedInstance.sort = sortName.index(of: checkCell.checkLabel.text!)
            
            
        case DISTANCE_NAME:
            // Allow only one cell checked
            for row in 0..<tableView.numberOfRows(inSection: DISTANCE_INDEX){
                let currentIndexPath = NSIndexPath(row: row, section: DISTANCE_INDEX)
                let cell = tableView.cellForRow(at: currentIndexPath as IndexPath) as! CheckCell
                if currentIndexPath as IndexPath == indexPath{
                    cell.isChecked = true
                } else {
                    cell.isChecked = false
                }
                distanceCheckStates[row] = cell.isChecked
            }
            BusinessFilters.sharedInstance.radius = distanceName.index(of: checkCell.checkLabel.text!)
            
        case LIMIT_NAME:
            // Allow only one cell checked
            for row in 0..<tableView.numberOfRows(inSection: LIMIT_INDEX){
                let currentIndexPath = NSIndexPath(row: row, section: LIMIT_INDEX)
                let cell = tableView.cellForRow(at: currentIndexPath as IndexPath) as! CheckCell
                if currentIndexPath as IndexPath == indexPath{
                    cell.isChecked = true
                } else {
                    cell.isChecked = false
                }
                limitCheckStates[row] = cell.isChecked
            }
            BusinessFilters.sharedInstance.limit = limitName.index(of: checkCell.checkLabel.text!)
            
        default:
            dealsCheckStates[indexPath.row] = value
            BusinessFilters.sharedInstance.deals = value
        }
    }
}

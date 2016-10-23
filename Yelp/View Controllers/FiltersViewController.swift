//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Tran Khanh Trung on 10/22/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

let CATEGORY = "Category"
let SORT = "Sort"
let DISTANCE = "Distance"
let DEALS = "Deals"

let SORT_BEST_MATCHED = "Best matched"
let SORT_DISTANCE = "Distance"
let SORT_HIGHEST_RATED = "Highest Rated"

let DEALS_OFFERING = "Offering a Deal"


@objc protocol FiltersViewControllerDelegate {
    @objc func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String])
}

class FiltersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate?
    var categories: [[String:String]]!
    var switchStates = [Int:Bool]()
    
    var sectionNames: [String]!
    
    var categoryNames: [String]!
    var sortName: [String]!
    var distanceName: [String]!
    var dealsValue: [String]!

    var sortSwitchOn = true
    var distanceSwitchOn = true
    
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
    
    func createSections(){
        self.sectionNames = [String]()
        self.sectionNames = [CATEGORY,SORT,DISTANCE,DEALS]
        
        self.categoryNames = [String]()
        for item in self.categories {
            self.categoryNames.append(item["name"]! as String)
        }
        
        self.sortName = [String]()
        self.sortName = [SORT_BEST_MATCHED, SORT_DISTANCE, SORT_HIGHEST_RATED]
        
        self.distanceName = [String]()
        self.distanceName = ["5 mi","10 mi","15 mi"]
        
        self.dealsValue = [String]()
        self.dealsValue = [DEALS_OFFERING]
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
        case sectionNames.index(of: CATEGORY)!:
            return self.categoryNames.count
            
        case sectionNames.index(of: SORT)!:
            return self.sortName.count
            
        case sectionNames.index(of: DISTANCE)!:
            return self.distanceName.count
            
        case sectionNames.index(of: DEALS)!:
            return dealsValue.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch (indexPath as NSIndexPath).section {
        case sectionNames.index(of: CATEGORY)!:
            return 44
            
        case sectionNames.index(of: SORT)!:
            if sortSwitchOn {
                return 44
            } else {
                return (indexPath as NSIndexPath).row == 0 ? 44 : 0
            }

        case sectionNames.index(of: DISTANCE)!:
            if distanceSwitchOn {
                return 44
            } else {
                return (indexPath as NSIndexPath).row == 0 ? 44 : 0
            }
            
        case sectionNames.index(of: DEALS)!:
            return 44
        default: return 300
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath as NSIndexPath).section {
            
        case sectionNames.index(of: CATEGORY)!:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            cell.switchLabel.text = categories[indexPath.row]["name"]
            cell.delegate = self
            cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
            return cell
        
        case sectionNames.index(of: SORT)!:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckCell", for: indexPath) as! CheckCell
            cell.checkLabel.text = sortName[indexPath.row]
            cell.sectionName = SORT
            cell.delegate = self
            
            // Check Best Matched as Default
//            if (sortName[indexPath.row] == SORT_BEST_MATCHED) {
//                switchStates[indexPath.row] = true
//            }
            cell.isChecked = switchStates[indexPath.row] ?? false
            
            return cell
            
        case sectionNames.index(of: DISTANCE)!:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckCell", for: indexPath) as! CheckCell
            cell.checkLabel.text = distanceName[indexPath.row]
            cell.sectionName = DISTANCE
            cell.delegate = self
            cell.isChecked = switchStates[indexPath.row] ?? false
            return cell
            
        case sectionNames.index(of: DEALS)!:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckCell", for: indexPath) as! CheckCell
            cell.checkLabel.text = dealsValue[indexPath.row]
            cell.delegate = self
            cell.isChecked = switchStates[indexPath.row] ?? false
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch (indexPath as NSIndexPath).section {
//        case sectionNames.index(of: SORT)!:
//            
//        case sectionNames.index(of: DISTANCE)!:
//        default:
//        }
//        
//        if (indexPath as NSIndexPath).section == 1 {
//            if (indexPath as NSIndexPath).row != 0 {
//                selectedLanguage = languages[(indexPath as NSIndexPath).row - 1]
//                tableView.reloadSections(IndexSet(integer: 1), with: .none)
//            }
//        }
//    }
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
        switchStates[indexPath.row] = value
        
        switch checkCell.sectionName{
        case SORT:
            BusinessFilters.sharedInstance.sort = sortName.index(of: checkCell.checkLabel.text!)
        case DISTANCE:
            BusinessFilters.sharedInstance.radius = distanceName.index(of: checkCell.checkLabel.text!)
        default:
            BusinessFilters.sharedInstance.deals = value
        }
        
        //print(value)
    }
}

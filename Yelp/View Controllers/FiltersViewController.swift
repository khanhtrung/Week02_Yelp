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
    
    var sectionNames: [String]!
    
    var categoryNames: [String]!
    var sortName: [String]!
    var distanceName: [String]!
    var dealsValue: [String]!

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
        self.sectionNames = ["Category","Sort","Distance","Deals"]
        
        self.categoryNames = [String]()
        for item in self.categories {
            self.categoryNames.append(item["name"]! as String)
        }
        
        self.sortName = [String]()
        self.sortName = ["Best matched","Distance","Highest Rated"]
        
        self.distanceName = [String]()
        self.distanceName = ["5 mi","10 mi","15 mi"]
        
        self.dealsValue = [String]()
        self.dealsValue = ["Offering a Deal"]
    }
}

//MARK: - Table methods
extension FiltersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // Category
            return self.categoryNames.count
            
        case 1: // Sort
            return self.sortName.count
            
        case 2: // Distance
            return self.distanceName.count
            
        case 3: // Deals
            return dealsValue.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath as NSIndexPath).section {
        case 0: // Category
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell

            cell.switchLabel.text = categories[indexPath.row]["name"]
            cell.delegate = self
            cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
            return cell
        
        case 1: // Sort
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            
            cell.switchLabel.text = sortName[indexPath.row]
            cell.delegate = self
            cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
            return cell
        case 2: // Distance
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            
            cell.switchLabel.text = distanceName[indexPath.row]
            cell.delegate = self
            cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
            return cell
        case 3: // Deals
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            
            cell.switchLabel.text = dealsValue[indexPath.row]
            cell.delegate = self
            cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
            return cell
            
//        case 1:
//            if (indexPath as NSIndexPath).row == 0 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
//                cell.onSwitch.isOn = switchOn
//                cell.delegate = self
//                return cell
//            } else {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCell", for: indexPath) as! SelectCell
//                let language = languages[(indexPath as NSIndexPath).row - 1]
//                cell.languageLabel.text = language
//                cell.checkImageView.isHidden = language != selectedLanguage
//                return cell
//            }
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section] as String
    }
}

//MARK: - Switch methods
extension FiltersViewController: SwitchCellDelegate {
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)!
        switchStates[indexPath.row] = value
    }
}

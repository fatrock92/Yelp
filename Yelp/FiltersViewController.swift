//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Fateh Singh on 4/6/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:Any])
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FilterCellDelegate {

    @IBOutlet weak var filtersTableView: UITableView!
    
    var switchStates = [IndexPath:Bool]()
    
    weak var delegate: FiltersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filtersTableView.delegate = self
        filtersTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let data = UserDefaults.standard.object(forKey: "switchStates") else {
            return
        }
        guard let retrievedData = data as? Data else {
            return
        }
        let unarchivedObject = NSKeyedUnarchiver.unarchiveObject(with: retrievedData)
        switchStates = unarchivedObject as! [IndexPath: Bool]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let defaults = UserDefaults.standard
        let archiver = NSKeyedArchiver.archivedData(withRootObject: switchStates)
        defaults.set(archiver, forKey: "switchStates")
        defaults.synchronize()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FiltersCell", for: indexPath) as! FiltersCell
        
        switch indexPath.section {
        case 0:
            cell.filterLabel.text = "Offering a Deal"
        case 1:
            cell.filterLabel.text = distanceDictionary[indexPath.row]["name"] as? String
        case 2:
            cell.filterLabel.text = sortByDictionary[indexPath.row]["name"] as? String
        case 3:
            cell.filterLabel.text = categoriesDictionary[indexPath.row]["name"]
        default:
            break
        }
        
        cell.delegate = self
        
        cell.filterSwitch.isOn = switchStates[indexPath] ?? false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return distanceDictionary.count
        case 2:
            return sortByDictionary.count
        case 3:
            return categoriesDictionary.count
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Distance"
        case 2:
            return "Sort By"
        case 3:
            return "Category"
        default:
            return ""
        }
    }
    
    @IBAction func onSearchAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
        var filters = [String: Any]()
        
        var selectedCategories = [String]()
        var selectedDistance = 0
        var selectedSortBy = 0
        var selectedDeals = false
        
        for (indexPath, isSelected) in switchStates {
            if isSelected {
                switch indexPath.section {
                case 0:
                    selectedDeals = true
                case 1:
                    selectedDistance = distanceDictionary[indexPath.row]["distance"] as! Int
                case 2:
                    selectedSortBy = sortByDictionary[indexPath.row]["value"] as! Int
                case 3:
                    selectedCategories.append(categoriesDictionary[indexPath.row]["code"]!)
                default:
                    break
                }
            }
        }
        
        filters["categories"] = selectedCategories
        filters["distance"]   = selectedDistance
        filters["sortBy"]     = selectedSortBy
        filters["deals"]      = selectedDeals
        
        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: filters)
    }

    @IBAction func onCancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func switchCell(switchCell: FiltersCell, didChangeValue value: Bool) {
        let indexPath = filtersTableView.indexPath(for: switchCell)!
        switchStates[indexPath] = value
        
    }

}

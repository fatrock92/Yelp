//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, FiltersViewControllerDelegate {
    
    var businesses: [Business]!
    let searchBar = UISearchBar()
    var searchString = String("Restaurants")
    var sortBy: YelpSortMode = .bestMatched
    var deals  = false
    var categories: [String] = []
    var distance = 0
    
    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.rowHeight  = UITableViewAutomaticDimension
        mainTableView.estimatedRowHeight = 100
        
        // Add the search bar in.
        searchBar.delegate = self
        searchBar.text = "Restaurants"
        self.navigationItem.titleView = searchBar
        
        Business.searchWithTerm(term: searchString!, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.mainTableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        )
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        cell.business = businesses[indexPath.row]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchString = searchBar.text
        Business.searchWithTerm(term: searchString!, sort: sortBy, categories: categories, deals: deals, distance: distance, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.mainTableView.reloadData()
        }
        )
    }
    
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        searchString = searchBar.text
        Business.searchWithTerm(term: searchString!, sort: sortBy, categories: categories, deals: deals, distance: distance, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.mainTableView.reloadData()
        }
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController
        let filtersViewController = navController.topViewController as! FiltersViewController

        filtersViewController.delegate = self
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : Any]) {
        let value = filters["sortBy"] as! Int
        sortBy = YelpSortMode(rawValue: value)!
        deals = filters["deals"] as! Bool
        
        categories = filters["categories"] as! [String]
        distance = filters["distance"] as! Int
        
        Business.searchWithTerm(term: searchString!, sort: sortBy, categories: categories, deals: deals, distance: distance, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.mainTableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        )
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
}

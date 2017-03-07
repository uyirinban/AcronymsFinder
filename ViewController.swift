//
//  ViewController.swift
//  AcronymsFinder
//
//  Created by Jeevanantham Kalyanasundram on 3/7/17.
//  Copyright © 2017 Jeevanantham Kalyanasundram. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, AcronymsFinderManagerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var listView: UITableView!
    
    var searchActive : Bool = false
    var acronymsManager: AcronymsFinderManager!
    var searchResultList = [String]()
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /* Setup delegates */
        acronymsManager = AcronymsFinderManager(delegate: self)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: -
    // MARK: UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    
    // MARK: -
    // MARK: UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.listView.dequeueReusableCell(withIdentifier: "LSInfoCell") as! LSInfoCell
        
        let lsInfo = searchResultList[indexPath.row]
        
        cell.lsValueLbl.text = lsInfo

        return cell
    }

    
    // MARK: -
    
    // MARK: UISearchBarDelegate methods
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        
        guard let searchStr = searchBar.text, !(searchBar.text?.isEmpty)! else {
            return
        }
        
        searchBar.resignFirstResponder()

        acronymsManager.getAcronymsDetails(acronyms: searchStr)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard (searchBar.text?.isEmpty)! else {
            return
        }
        
        searchResultList.removeAll()
        
        DispatchQueue.main.async {
            
            guard let tableViewWithFlight = self.listView else { //Code refactoring
                return
            }
            
            tableViewWithFlight.reloadData()
            
        }
        
        
    }

    
    // MARK: -
    // MARK: AcronymsFinderManagerDelegate methods
    
    func didGetLongFormList(searchResult: LongformDetails) {
        // This method is called asynchronously and updates all the labels.
        
        if searchResult.longformList.count > 0 { //Code refactoring
            searchResultList = searchResult.longformList
        }
        
        DispatchQueue.main.async {
            
            guard let tableViewWithFlight = self.listView, self.searchResultList.count > 0 else { //Code refactoring
                return
            }
            tableViewWithFlight.reloadData()
            
        }
        
    }
    
    func didNotGetLongFormList(error: NSError) {
        
        print("didNotGetFlightList error: \(error)")
        
    }
    
    // MARK: - Utility methods
    func showNoResultAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "OK",
            style:  .default,
            handler: nil
        )
        alert.addAction(okAction)
        present(
            alert,
            animated: true,
            completion: nil
        )
    }
    
    
}


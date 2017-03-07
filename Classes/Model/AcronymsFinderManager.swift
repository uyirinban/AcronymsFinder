//
//  AcronymsFinderManager.swift
//  AcronymsFinder
//
//  Created by Jeevanantham Kalyanasundram on 3/7/17.
//  Copyright © 2017 Jeevanantham Kalyanasundram. All rights reserved.
//

import Foundation

// The delegate method didGetLongFormList is called if the flights data was received.
// The delegate method didNotGetLongFormList method is called if flights data was not received.
protocol AcronymsFinderManagerDelegate {
    func didGetLongFormList(searchResult: LongformDetails)
    func didNotGetLongFormList(error: NSError)
    func showNoResultAlert(title: String, message: String)
}


// MARK: AcronymsFinderManager

class AcronymsFinderManager {
    
    private let AcronymsFinderBaseURL = "http://www.nactem.ac.uk/software/acromine/dictionary.py/"
    
    private var delegate: AcronymsFinderManagerDelegate
    
    
    // MARK: -
    init(delegate: AcronymsFinderManagerDelegate) {
        self.delegate = delegate
    }
    
    func getAcronymsDetails(acronyms: String) {
        
        // This is the shared session will do.
        let session = URLSession.shared
        
        let searchStr = acronyms.replacingOccurrences(of: " ", with: "")
        
        let acronymsRequestURL =  URL(string: "\(AcronymsFinderBaseURL)?sf=\(searchStr)")!
        
        
        let task = session.dataTask(with: acronymsRequestURL, completionHandler: { (data, response, error) in
            
            if let networkError = error {
                // An error occurred while trying to get data from the server.
                self.delegate.didNotGetLongFormList(error: networkError as NSError)
            }
            else {
                print("Success")
                // We got data from the server!
                
                do {
                    
                    if let jsonResult = try JSONSerialization.jsonObject(with:data!, options: []) as? [[String:AnyObject]] {
                        
                        if jsonResult.count > 0 {
                            
                            // Initializing dictionary to Flight details struct.
                            let lsInfo = LongformDetails(acronymsData: jsonResult)
                            
                            self.delegate.didGetLongFormList(searchResult: lsInfo)
                        }
                        else {
                            self.delegate.showNoResultAlert(title: "Sorry", message: "No Result Found!")
                        }
                        
                    }
                    
                }
                catch let jsonError as NSError {
                    self.delegate.didNotGetLongFormList(error: jsonError)
                }
                
            }
            
        })
        
        task.resume()
        
    }
    
}

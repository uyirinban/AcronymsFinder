//
//  LongformDetails.swift
//  AcronymsFinder
//
//  Created by Jeevanantham Kalyanasundram on 3/7/17.
//  Copyright © 2017 Jeevanantham Kalyanasundram. All rights reserved.
//

import Foundation


struct LongformDetails {
    
    private var longformValue = [[String:AnyObject]]()
    var longformList = [String]()
    
    init(acronymsData: [[String:AnyObject]]) {
        
        for lsInfo in acronymsData {
            
            longformValue = lsInfo["lfs"] as! [[String : AnyObject]]
            
            for IfInfo in longformValue {
                longformList.append(IfInfo["lf"] as! String)
            }
            
        }
        
    }
    
}


//
//  Harddrive.swift
//  MenuBar
//
//  Created by Marist User on 1/28/16.
//  Copyright © 2016 Marist User. All rights reserved.
//

import Foundation

class HardDrive{
    
    func HarddriveStartup()
    {
        for t in 1...3
        {
            for s in 1...8
            {
                for b in 1...8
                {
                    var memString = ""
                    memString += String(t)
                    memString += String(s)
                    memString += String(b)
                    
                    //determine localstorage
                    _localStorage[memString] = "0";
                }
                
            }
            
        }
        
    }
    
    func setValue(targettsb: String, value: String)
    {
        //set the value in local storage
        _localStorage[targettsb] =  value;
    }
    
    func getValue(targettsb: String) -> String
    {
        //get value at tsb
        if let returnVal = _localStorage[targettsb]
        {
            return returnVal;
        }
        return "null";
    }
    
}
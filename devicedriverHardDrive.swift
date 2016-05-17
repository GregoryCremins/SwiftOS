//
//  devicedriverHardDrive.swift
//  XcodeOS
//
//  Created by Marist User on 3/3/16.
//  Copyright © 2016 Marist User. All rights reserved.
//

import Foundation

/**
* Created by Whar on 12/6/2014.
*/
//poop By Dan Treccagyolo

class deviceDriverHardDrive : DeviceDriver
        {
            init()
            {
                super.init();
            hdDriverEntry();
            startHardDrive();
            }
    
            func hdDriverEntry() -> String {
                // Initialization routine for this, the kernel-mode Keyboard Device Driver.
                self.status = "loaded";
                return "";
                // More?
            }
            func startHardDrive() -> String
            {
                _HardDrive.HarddriveStartup();
//                for entry in _localStorage
//                {
//                    print(entry.0 + ": " + entry.1);
//                }
                return "";
            }
            func formatHardDrive()
            {
                
                if !_CPU.isExecuting
                {
                    for (var t = 0; t < 3; t++) {
                        for (var s = 0; s < 8; s++) {
                            for (var b = 0; b < 8; b++)
                            {
                                var target = "";
                                target = target  + String(t);
                                target = target + "";
                                target = target + String(s);
                                target = target + "";
                                target = target + String(b);
                               // var target = "" + t + "" + s + "" + b;
                                _HardDrive.setValue(target, value: "0")
                                
                            }
                        }
                        
                    }

                    //_StdOut.putText("Successfully formatted disk");
                    _StdOut.string = "Successfully formatted disk" + _StdOut.string!;
                }
                else
                {
                    //_StdOut.putText("Error: Please wait for execution to complete before formatting the hard drive.")
                    _StdOut.string = "Error: Please wait for execution to complete before formatting the hard drive" + _StdOut.string!;
                }

            }
            //method to write file into page table
    func createFile(fileName:String) -> String
            {
                var targetLoc = "000"
                var target = false;
                while(targetLoc != "077" && target == false)
                {
                    let targetLocFirstVal = _HardDrive.getValue(targetLoc);
                    if(Int(String(targetLocFirstVal[targetLocFirstVal.startIndex])) == 0)
                    {
                        _HardDrive.setValue(targetLoc, value: String("1") + fileName);
                        //alert("createed file " + fileName + "at location " + targetLoc);
                        target = true;
                    }
                    else
                    {
                        var location = Int("0" + targetLoc , radix: 8)!;
                        location = location + 1;
                        targetLoc = String(location, radix: 8);
                        while(targetLoc.characters.count < 3)
                        {
                            targetLoc = "0" + targetLoc;
                        }
                    }
                    
                }
                

                if(target == false)
                {
                    //_StdOut.putText("Unable to create file. Page table is full.");
                     _StdOut.string = "Unable to create file. Page table is full." + _StdOut.string!;
                }
                else
                {
                     _StdOut.string = "File created in memory" + _StdOut.string!;
                    return targetLoc;
                    
                    
                   // _StdOut.putText("File created in memory.");
                    
                }
                return "";
            }
            
            //write to file
                func writeToFile(fileName :String, var data:String)
            {
                //first find the index of the file in the page table
                var pageLoc = "000";
                var foundFile = false;
                while(pageLoc != "077" && foundFile == false)
                {
                    //if we found it, stop looping
                //    var targetobj = _HardDrive.getValue(pageLoc);
                    let f = _HardDrive.getValue(pageLoc).indexOf(fileName);
                    if(_HardDrive.getValue(pageLoc)[_HardDrive.getValue(pageLoc).startIndex] == "1" && f > -1)
                    {
                        foundFile = true;
                    }
                    else
                    {
                      //  var location = parseInt("0" + pageLoc , 8);
                        var location = Int(("0" + pageLoc), radix:8)!;
                        location = location + 1;
                        //pageLoc = location.toString(8);
                        pageLoc = String(location, radix: 8)
                        while(pageLoc.characters.count < 3)
                        {
                            pageLoc = "0" + pageLoc;
                        }
                    }

                }
                //if we found the file, then we must attempt to write to it
                if(foundFile == true)
                {
                    //now we write the data
                    var targetLoc = "100"
                   // var target = false;
                    let numBlocks = Int(ceil(CGFloat(data.characters.count) / 60));
                    var runningCountOfBlocks = 0;
                    var flag = false;
                    //first find a space in memory which will fit the data
                   while (targetLoc != "277" && flag == false) {
                        if (String(_HardDrive.getValue(targetLoc)[_HardDrive.getValue(targetLoc).startIndex]) == "0")
                        {
                            runningCountOfBlocks += 1;
                            var location = Int(("0" + targetLoc), radix: 8)!;
                            location = location + 1;
                            targetLoc = String(location, radix: 8);
                            while(targetLoc.characters.count < 3)
                            {
                                targetLoc = "0" + targetLoc;
                            }
                        }
                        else
                        {
                            runningCountOfBlocks == 0;
                            var location = Int(("0" + targetLoc), radix: 8)!;
                            location = location + 1;
                            targetLoc = String(location, radix:8);
                            while(targetLoc.characters.count < 3)
                            {
                                targetLoc = "0" + targetLoc;
                            }
                        }
                        if (runningCountOfBlocks == numBlocks) {
                            flag = true;
                        }
                    }

                    //then begin the write if we found a suitable space
                    if (flag == true)
                    {
                        //first get starting location
                        let startLoc = Int("0" + targetLoc)! - Int(numBlocks);
                        //save the location of the first page of data to the page table
                        //print("Page: " + pageLoc + " : " + "Value: " + String(startLoc));
                        _HardDrive.setValue(pageLoc, value: String(_HardDrive.getValue(pageLoc) + String(startLoc)));
                        var currentLoc = String(startLoc);
                        while(currentLoc.characters.count < 3)
                        {
                            currentLoc = "0" + currentLoc;
                        }
                        //alert("Write to:" + currentLoc);
                        //then we begin the write.
                        var counter = 0;
                        _HardDrive.setValue(currentLoc, value: "1")
                        while (data.characters.count > 0) {
                            let temp = String(data.substringWithRange(Range<String.Index>(start: data.startIndex, end: data.startIndex.successor())));
                            _HardDrive.setValue(currentLoc, value: _HardDrive.getValue(currentLoc) + temp);
                            let index1 = data.startIndex.advancedBy(1);
                            data = data.substringFromIndex(index1);
                            counter++;
                            //then if we need to swap blocks. we do so
                            if (counter % 60 == 0)
                            {
                                //first, fill in the last 3 bytes with the index of the next block and the first byte set to 1 for used
                                let nextLoc = Int("0" + currentLoc)! + 1;
                                var nextLocString = String(nextLoc);
                                _HardDrive.setValue(nextLocString, value: "1");
                                while (nextLocString.characters.count < 3)
                                {
                                    nextLocString = "0" + nextLocString;
                                }
                                _HardDrive.setValue(currentLoc, value: "1" + _HardDrive.getValue(currentLoc).substringFromIndex(_HardDrive.getValue(currentLoc).startIndex.successor()) + nextLocString);
                                //then go to the next block
                                currentLoc = nextLocString;
                            }
                        }
                       // _StdOut.putText("Data successfully written to hard drive");
                        _StdOut.string = ("Data successfully writtern to hard drive") + _StdOut.string!;
                                                _StdOut.string = ("\r\n") + _StdOut.string!;
                       // _StdOut.advanceLine();
                    }
                        //if we did not find a large enough space to put the data, throw error
                    else
                    {
                     //   _StdOut.putText("Write Error: No large enough space exists for data. Try clearing some files and try again.")
                        _StdOut.string = ("Write Error: No large enough space exists for data. Try clearing some files and try again.") + _StdOut.string!;
                    }
                }
                    //otherwise we did not find the file
                else
                {
                  //  _StdOut.putText("Write Error: File not found. Please make sure the name is correct.")
                    _StdOut.string = ("Write Error: File not found. Please make sure the name is correct.") + _StdOut.string!;
                }
                
            }
            //read and display file contents from memory
                func readFromFile(filename:String) -> String
            {
                //first find the file in memory
                var pageLoc = "000";
                var foundFile = false;
                while(pageLoc != "077" && foundFile == false)
                {
                    //if we found it, stop looping
                    if(String(_HardDrive.getValue(pageLoc)[_HardDrive.getValue(pageLoc).startIndex]) == "1" && _HardDrive.getValue(pageLoc).indexOf(filename) > -1)
                    {
                        foundFile = true;
                    }
                    else
                    {
                        var location = Int(("0" + pageLoc), radix: 8)!;
                        location = location + 1;
                        pageLoc = String(location, radix:8);
                        while(pageLoc.characters.count < 3)
                        {
                            pageLoc = "0" + pageLoc;
                        }
                    }
                

                    
                }
                
                //if we found it, we need to print it
                if(foundFile)
                {
                    //check if the file has a destination location
                    let page = _HardDrive.getValue(pageLoc);
                    let index3 = page.startIndex.advancedBy(page.characters.count - 3);
                   let dataLocString = page.substringFromIndex(index3);
                    if(dataLocString != "" && Int(dataLocString)! < Int("0277"))
                    {
                        var dataLoc = Int(("0" + dataLocString),radix: 8)!;
                        var currentData = _HardDrive.getValue(String(dataLoc, radix:8));
                        let startInd = currentData.startIndex.successor();
                        var endInd = currentData.endIndex;
                        if(currentData.characters.count == 64)
                        {
                        endInd = currentData.startIndex.advancedBy(61);
                        }
                        var outString = currentData.substringWithRange(Range<String.Index>(start: startInd, end: endInd));
                        while (currentData.characters.count == 64 && dataLoc < 255) {
                            currentData = _HardDrive.getValue(String(dataLoc, radix:8));
                            dataLoc += 1;
                            let startInd1 = currentData.startIndex.successor();
                            let endInd1 = currentData.startIndex.advancedBy(61);
                            outString = outString + currentData.substringWithRange(Range<String.Index>(start: startInd1, end: endInd1))
                        }
                        //alert("READ " + outString);
                        return outString;
                    }
                    else
                    {
                        //_StdOut.putText("File exists, but there is no data");
                        _StdOut.string = "File exists, but there is no data." + "\n\r" + _StdOut.string!;
                        return "File exists, but there is no data";
                    }
                }
                else
                {
                    //_StdOut.putText("Error: file not found");
                    _StdOut.string = "Error: file not found" + _StdOut.string!;
                    return "Error: file not found";
                }
            }
    
    
            //delete file from memory
            func deleteFile(filename:String) -> Bool
            {
                //first find the file in memory
                var pageLoc = "000";
                var foundFile = false;
                while(pageLoc != "077" && foundFile == false)
                {
                    //if we found it, stop looping
                    if(String(_HardDrive.getValue(pageLoc).substringWithRange(Range<String.Index>(start: _HardDrive.getValue(pageLoc).startIndex, end: _HardDrive.getValue(pageLoc).startIndex.successor()))) == "1" && _HardDrive.getValue(pageLoc).indexOf(filename) > -1)
                    {
                        foundFile = true;
                    }
                    else
                    {
                        var location = Int("0" + pageLoc, radix: 8)!;
                        location = location + 1;
                        pageLoc = String(location, radix:8);
                        while(pageLoc.characters.count < 3)
                        {
                            pageLoc = "0" + pageLoc;
                        }
                    }

                }
                //if we found it, we need to remove it
                if(foundFile)
                {
                    var dataLocString = ""
                    let page = _HardDrive.getValue(pageLoc);
                    if(page.characters.count > 4)
                    {
                    let index4 = page.startIndex.advancedBy(page.characters.count - 3)
                    dataLocString = page.substringFromIndex(index4);
                    }

                    if(dataLocString != "" && Int("0" + dataLocString, radix: 8)! < Int("0277", radix: 8)!)
                    {
                        print("here");
                        var dataLoc = Int("0" + dataLocString, radix: 8)!;
                        //reset the page table block
                        _HardDrive.setValue(pageLoc, value: "0");
                        //reset data
                        var currentData = _HardDrive.getValue(String(dataLoc, radix:8));
                        //if no extra pages then just clean this one
                        if(currentData.characters.count > 1 && currentData.characters.count < 64)
                        {
                            _HardDrive.setValue(String(dataLoc, radix:8), value: "0");
                        }
                        while (currentData.characters.count == 64 && dataLoc < 255) {
                            currentData = _HardDrive.getValue(String(dataLoc, radix:8));
                            _HardDrive.setValue(String(dataLoc, radix:8), value: "0");
                            dataLoc += 1;
                        }
                        for entry in _localStorage
                                    {
                                        print(entry.0 + ": " + entry.1);
                                    }
                        return true;
                        
                    }

                }
                else
                {
                    //alert("Delete error: File not found");
                    return false;
                }
                return false;
            }
            
            func listHardDrive()
            {
                
                var pageLoc = "000";
                var endFile = false;
             //   _StdOut.putText("Name of file[location of track sector and block of file data]")
                _StdOut.string = "Name of file[location of track sector and block of file data]" + _StdOut.string!;
              //  _StdOut.advanceLine()
                _StdOut.string = "\r\n" + _StdOut.string!;
                _StdOut.string = "Hard drive:" + _StdOut.string!;
              //  _StdOut.putText("Hard drive:")
                while(pageLoc != "077" && endFile == false)
                {
                    if(String(_HardDrive.getValue(pageLoc)).substringWithRange(Range<String.Index>(start: _HardDrive.getValue(pageLoc).startIndex, end: _HardDrive.getValue(pageLoc).startIndex.advancedBy(1))) == "1")
                    {
                //        _StdOut.advanceLine();
                        _StdOut.string = "\r\n" + _StdOut.string!;
                        _StdOut.string = _HardDrive.getValue(pageLoc).substringFromIndex(_HardDrive.getValue(pageLoc).startIndex.successor()) + _StdOut.string!;
                //        _StdOut.putText(_HardDrive.getValue(pageLoc).substring(1));
                        var location = Int("0" + pageLoc, radix: 8);
                        location = location! + 1;
                        pageLoc = String(location)
                        while(pageLoc.characters.count < 3)
                        {
                            pageLoc = "0" + pageLoc;
                        }
                    }
                    else
                    {
                        //_StdOut.advanceLine();
                        endFile = true;
                    }
                }
            }
        }


extension String {
    func indexOf(string: String) -> Int
    {
        var startIndex = self.startIndex;
        var num = 0;
        
        while(startIndex != string.endIndex)
        {
            if(string.substringWithRange(Range<String.Index>(start: startIndex, end: startIndex.advancedBy(string.characters.count))) == string)
            {
                return num;
            }
            num+=1;
            startIndex = startIndex.predecessor();
        }
        return -1;
    }
}



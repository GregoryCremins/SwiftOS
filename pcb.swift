//
//  pcb.swift
//  XcodeOS
//
//  Created by Marist User on 4/14/16.
//  Copyright © 2016 Marist User. All rights reserved.
//

import Foundation

/**
* Created by Greg on 10/7/2014.
* Class to hadle the values of a current process
*/
class PCB {
      var   PC = 0;
      var   Acc = 0;
      var   Xreg = 0;
      var   Yreg = 0;
      var   Zflag = 0;
      var   PID = 0;
      var   base = 0;
      var   limit = 0;
      var   priority = 0;
     var    hardDriveLoc: String = "N/A";
        
        init(PC2:Int = 0, Acc2:Int = 0, Xreg2:Int = 0, Yreg2:Int = 0, Zflag2:Int = 0) {
        PC = PC2;
        Acc = Acc2;
        Xreg = Xreg2;
        Yreg = Yreg2;
        Zflag = Zflag2;
        }
        
    func setPID(value:Int) {
        PID = value;
        }
        
    func setPCval(value:Int) {
        PC = value;
        }
        
    func setLimit(value:Int) {
        limit = value;
        }
        
    func setBase(value: Int) {
        base = value;
        }
    func setPriority(value:Int)
        {
        priority = value;
        }
        
        func getPriority() -> Int
        {
        return priority;
        }
    func setHardDriveLoc(loc: String)
        {
        hardDriveLoc = loc;
        }
        func getHardDriveLoc() -> String
        {
        return hardDriveLoc;
        }
    func getPID() -> Int
    {
        return self.PID;
    }
        
        /**
        * Function to load the values of this PCB to the CPU
        */
        func loadToCPU() {
        _CPU.load(self.PC, Acc: self.Acc, Xreg: self.Xreg, Yreg: self.Yreg, Zflag: self.Zflag, base: self.base, limit: self.limit);
        
        }
        
        /**
        * Method to store the parameters to this PCB
        * @param PC
        * @param Acc
        * @param Xreg
        * @param Yreg
        * @param Zflag
        */
    func storeVals(PC2:Int, Acc2:Int, Xreg2:Int, Yreg2:Int, Zflag2:Int) {
        PC = PC2;
        Acc = Acc2;
        Xreg = Xreg2;
        Yreg = Yreg2;
        Zflag = Zflag2;
        }
        
        /**
        * Function to print the PCB's contents to the screen
        */
        func printToScreen()
        {
            _PCBElement = _RootController.getPCBView();
            let pidStr = "Process #: " + String(self.PID);
            let pcStr = "PC: " + String(self.PC);
            let accStr = "Acc: " + String(self.Acc);
            let xregStr = "Xreg: " + String(self.Xreg);
            let yregStr = "Yreg: " + String(self.Yreg);
            let zflagStr = "ZFlag: " + String(self.Zflag);
            let baseStr = "Base Reg: " + String(self.base);
            let priorityStr = "Priority: " + String(self.priority);
            let tsbStr = "TSB: " + self.hardDriveLoc;
            _PCBElement.string = _PCBElement.string! + pidStr + " ";
            _PCBElement.string = _PCBElement.string! + pcStr + " ";
            _PCBElement.string = _PCBElement.string! + accStr + " ";
            _PCBElement.string = _PCBElement.string! + xregStr + " ";
            _PCBElement.string = _PCBElement.string! + yregStr + " ";
            _PCBElement.string = _PCBElement.string! + zflagStr + " ";
            _PCBElement.string = _PCBElement.string! + baseStr + " " ;
            _PCBElement.string = _PCBElement.string! + priorityStr + " "
            _PCBElement.string = _PCBElement.string! + tsbStr;
            _PCBElement.string = _PCBElement.string! + "\r\n";
            //let tsbStr = "TSB: " + String(self.)
            
        //new PCB writer
        //var newRow = <HTMLTableRowElement>_PCBElement.insertRow();
        //for (var j = 0; j < 10; j++) {
        //var targetCell = newRow.insertCell(j);
        //switch (j) {
        //case 0:
        //{
        //targetCell.innerHTML = "" + this.PID;
        //break;
        //}
        //case 1:
        //{
       // targetCell.innerHTML = "0x" + this.toHexDigit(this.PC);
       // break;
       // }
       // case 2:
       // {
       // targetCell.innerHTML = "0x" + this.toHexDigit(this.Acc);
       // break;
       // }
       // case 3:
       // {
      //  targetCell.innerHTML = "0x" + this.toHexDigit(this.Xreg);
       // break;
       // }
       // case 4:
       // {
       // targetCell.innerHTML = "0x" + this.toHexDigit(this.Yreg);
       // break;
       // }
        //case 5:
       // {
        //targetCell.innerHTML = "0x" + this.toHexDigit(this.Zflag);
       // break;
       // }
       // case 6:
       // {
       // targetCell.innerHTML = "0x" + this.toHexDigit(this.base);
        // break;
       // }
       // case 7:
       // {
       // targetCell.innerHTML = "0x" + this.toHexDigit(this.limit);
       // break;
       // }
       // case 8:
       // {
       // targetCell.innerHTML = " " + this.priority;
       // break;
       // }
       // case 9:
       // {
       // targetCell.innerHTML = this.hardDriveLoc;
        //break;
       // }
       // default:
        //{
       // break;
       // }
       // }
       // }
        
        }
        
        /**
        * Function to convert a number to hex
        * @param dec the decimal number to be converted
        * @returns {string} the string of the hexedecimal equivalenbt
        */
    func toHexDigit(dec:Int) -> String
    {
        return String(format:"%2X", dec)
    }
}
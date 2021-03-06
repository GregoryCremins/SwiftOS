//
//  MemoryHandler.swift
//  XcodeOS
//
//  Created by Marist User on 4/14/16.
//  Copyright © 2016 Marist User. All rights reserved.
//

import Foundation
import Cocoa

/**
* Created by Greg on 10/5/2014.
* class to handle the memory array
*/
    class memory
    {
        var accumulator = 0;
        init()
        {
        accumulator = 0;
        
        }
        
        //loads an item into memory
        func load(mem: String, index : Int)
        {
         //   print("original string:" + mem);
        //alert(mem);
      //  if(typeof(mem) == typeof(123))
     //   {
        //it is a hex digit, we need to do conversion
    //    var first = 0;
     //   if(mem > 16) {
     //   first = Math.floor(mem / 16);
     //   }
     //   else
     //   {
     //   first = 0;
     //   }
     //   var second = mem % 16;
     //   var firstChar = this.ConvertToString(first);
     //   var secondChar = this.ConvertToString(second);
        
    //    _Memory[index] = firstChar + secondChar;
     //   this.updateMem();
     //   }
     //   else
     //   {
     //   if(mem == undefined)
     //   {
     //   mem = "00"
     //   }
        //otherwise, its already disassembly
     //   _Memory[index] = mem;
     //   this.updateMem();
      //  }
        
            //integer case
//        if let _ = Int(mem)
//        {
//            var first = 0;
//            let memInt = Int(mem)!
//           // print ("At load point" + String(memInt));
//            if(memInt > 16)
//            {
//                first = Int(floor(Double(memInt / 16)));
//            }
//            else
//            {
//                first = 0;
//            }
//            let second = (memInt % 16);
//            let firstChar = self.ConvertToString(first);
//            let secondChar = self.ConvertToString(second);
//            _Memory[index] = firstChar + secondChar;
//            self.updateMem();
//            
//        }
            //string case
//        else
//        {
            _Memory[index] = mem;
            self.updateMem();
          //  }
            //print("IN MEMORY: " + _Memory[index]);
        }
        
        func load(mem: Int, index:Int)
        {
           
                var first = 0;
                let memInt = Int(mem)
                // print ("At load point" + String(memInt));
                if(memInt > 16)
                {
                    first = Int(floor(Double(memInt / 16)));
                }
                else
                {
                    first = 0;
                }
                let second = (memInt % 16);
                let firstChar = self.ConvertToString(first);
                let secondChar = self.ConvertToString(second);
                _Memory[index] = firstChar + secondChar;
                self.updateMem();
                
            

        }
        /**
        * Function to convert the given hex digit to a string
        * @param digit the hex digit to be converted
        * @returns {string} the string which is generated
        * @constructor
        */
            func ConvertToString(digit:Int) -> String
        {
        switch(digit)
        {
        case 15:
        return "F";
        //break;
        
        case 14:
        return "E";
        //break;
        
        case 13:
        return "D";
        //break;
        
        case 12:
        return "C";
        //break;
        
        case 11:
        return "B";
       // break;
        
        case 10:
        return "A";
       // break;
        
        default:
        return "" + String(digit);
       // break;
        
        }
        }
        
        /**
        * Function to read a value from memory at the given index
        * @param index the index which we which to read from memory
        * @returns {Object} the value at that given index
        */
            func read(index: Int) -> String
        {
        return _Memory[index];
        }
        
        /**
        * Function to update memory on the UI
        */
        func updateMem() {
           // print("CP1");
        _CPUElement.stringValue = "";
        var offset = 256 * (_currentProcess - 1);
        if (offset < 0) {
        offset = 0;
        }
        if(_Processes.count > 0 && _currentProcess > 0)
        {
        offset = _Processes[_currentProcess - 1].base;
        }
       for (var i = 0; i < 256; i++)
        {
        _DisplayedMem[i] = "" + _Memory[i + offset];
            _RootController.offSet = _currentProcess - 1;
            //_RootController.updateTable();
           //print( _RootController.getMemoryView().dataSource()!);
           // print("In Memory Display: " + String(i + offset) + ": " + _DisplayedMem[i]);
        
        }
            _RootController.updateTable();
          //  print("CP2");
            _CPU.updateUI();
          //  print("CP3");
            _RootController.getPCBView().string = "";
        if (_Processes.count > 0) {
        for (var j = 0; j < _Processes.count; j++) {
        _Processes[j].printToScreen();
        }
         //   print("CP4");
        }
        
        let readyQueueElement = _RootController.getReadyQueueView();
        let resultQueue2 = Queue(q2: [PCB]());
        readyQueueElement.string = "";
        while (_ReadyQueue.getSize() > 0) {
        let testProcess = _ReadyQueue.dequeue()!;
        resultQueue2.enqueue(testProcess);
            
            let pidStr = "Process #: " + String(testProcess.PID);
            let pcStr = "PC: " + String(testProcess.PC);
            let accStr = "Acc: " + String(testProcess.Acc);
            let xregStr = "Xreg: " + String(testProcess.Xreg);
            let yregStr = "Yreg: " + String(testProcess.Yreg);
            let zflagStr = "ZFlag: " + String(testProcess.Zflag);
            let baseStr = "Base Reg: " + String(testProcess.base);
            let priorityStr = "Priority: " + String(testProcess.priority);
            let tsbStr = "TSB: " + testProcess.hardDriveLoc;
            readyQueueElement.string = readyQueueElement.string! + pidStr + " ";
            readyQueueElement.string = readyQueueElement.string! + pcStr + " ";
            readyQueueElement.string = readyQueueElement.string! + accStr + " ";
            readyQueueElement.string = readyQueueElement.string! + xregStr + " ";
            readyQueueElement.string = readyQueueElement.string! + yregStr + " ";
            readyQueueElement.string = readyQueueElement.string! + zflagStr + " ";
            readyQueueElement.string = readyQueueElement.string! + baseStr + " " ;
            readyQueueElement.string = readyQueueElement.string! + priorityStr + " "
            readyQueueElement.string = readyQueueElement.string! + tsbStr;
            readyQueueElement.string = readyQueueElement.string! + "\r\n";
            
            }
            _ReadyQueue = resultQueue2;
            //print("DONE WITH MEM UPDATE");
        }
        
        
    }
    
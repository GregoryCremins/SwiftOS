//
//  cpu.swift
//  XcodeOS
//
//  Created by Marist User on 4/28/16.
//  Copyright © 2016 Marist User. All rights reserved.
//

import Foundation
//<reference path="../globals.ts" />

/* ------------
CPU.ts

Requires global.ts.

Routines for the host CPU simulation, NOT for the OS itself.
In this manner, it's A LITTLE BIT like a hypervisor,
in that the Document environment inside a browser is the "bare metal" (so to speak) for which we write code
that hosts our client OS. But that analogy only goes so far, and the lines are blurred, because we are using
TypeScript/JavaScript in both the host and client environments.

This code references page numbers in the text book:
Operating System Concepts 8th edition by Silberschatz, Galvin, and Gagne.  ISBN 978-0-470-12872-5
------------ */

    
    class Cpu {
        
        var PC : Int;
        var Acc: Int;
        var Xreg: Int;
        var Yreg: Int;
        var Zflag: Int;
        var runningCycleCount: Int;
        var base: Int;
        var limit: Int;
        var isExecuting: Bool;
        var scheduling: String;
        init (PC:Int = 0, Acc:Int = 0, Xreg:Int = 0, Yreg:Int = 0, Zflag:Int = 0, runningCycleCount:Int = 0, base:Int = 0, limit:Int = 0, isExecuting:Bool = false, scheduling:String = "rr") {
            self.PC = PC
            self.Acc = Acc
            self.Xreg = Xreg;
            self.Yreg = Yreg;
            self.Zflag = Zflag;
            self.runningCycleCount = runningCycleCount;
            self.base = base;
            self.limit = limit;
            self.isExecuting = isExecuting;
            self.scheduling = scheduling;
        
        }
    
        func initCPU(){
        self.PC = 0;
        self.Acc = 0;
        self.Xreg = 0;
        self.Yreg = 0;
        self.Zflag = 0;
        self.isExecuting = false;
        }
        
        func cycle() {
        //context swap
        if ((self.runningCycleCount % _quantum) == 0 && _ReadyQueue.getSize() > 0 && self.runningCycleCount > 0 && self.scheduling == "rr") {
        if (_currentProcess == 0) {
        _Kernel.krnTrace("Completed Program " + String(_currentProcess));
        let process = _ReadyQueue.dequeue()!;
        if(process.getHardDriveLoc() != "N/A")
        {
        self.rollIn(process);
        }
        else
        {
        process.loadToCPU();
        }
        _currentProcess = process.PID;
       // _Kernel.krnTrace('Loading Program ' + _currentProcess);
        self.runningCycleCount = 0;
        }
        else {
        //alert("CONTEXTSWAP");
            print("contextswap");
        _Kernel.krnTrace("Context Swap from " + String(_currentProcess));
        //alert(_currentProcess);
        //alert("CONTEXT SWAPPIN ACTION");
        self.contextSwitch();
        self.runningCycleCount = 0;
        }
        }
        else {
        if (_currentProcess == 0 && _ReadyQueue.getSize() == 0) {
         //   print("Completed all execution");
        _Kernel.krnTrace("Completed all execution");
        self.isExecuting = false;
        }
        else {
        if (_currentProcess == 0 && _ReadyQueue.getSize() != 0) {
        _Kernel.krnTrace("Completed Program " + String(_currentProcess));
          //  print("READY QUEUE SIZE: " + String(_ReadyQueue.getSize()));
        let process = _ReadyQueue.dequeue()!;
        if(process.getHardDriveLoc() != "N/A")
        {
        self.rollIn(process);
        }
        else {
        process.loadToCPU();
        }
        _currentProcess = process.PID;
          //  print("Loading program: " + String(process.PID));
        _Kernel.krnTrace("Loading Program " + String(_currentProcess));
        self.runningCycleCount = 0;
        }
        else {
        _Kernel.krnTrace("CPU cycle");
        // TODO: Accumulate CPU usage and profiling statistics here.
        // Do the real work here. Be sure to set this.isExecuting appropriately.
          //  print("AT CYCLE: " + _MemoryHandler.read(self.PC));
        self.handleCommand(_MemoryHandler.read(self.PC));
            self.runningCycleCount = self.runningCycleCount + 1;
        }
        
        }
        }
        
        
        }
        
        /**
        * Function to update the UI
        */
        func updateUI() {
        _CPUElement.stringValue = "";
        _CPUElement.stringValue += "CPU \n";
        _CPUElement.stringValue += "PC: 0x" + self.toHexDigit(self.PC) + "\n";
        _CPUElement.stringValue += "Acc: 0x" + self.toHexDigit(self.Acc) + "\n";
        _CPUElement.stringValue += "Xreg: 0x" + self.toHexDigit(self.Xreg) + "\n";
        _CPUElement.stringValue += "Yreg: 0x" + self.toHexDigit(self.Yreg) + "\n";
        _CPUElement.stringValue += "Zflag: 0x" + self.toHexDigit(self.Zflag) + "\n";
        _CPUElement.stringValue += "Scheduling: " + self.scheduling + "\n";
        }
        
        /**
        * Function to load the CPU with the specified values
        * @param PC
        * @param Acc
        * @param Xreg
        * @param Yreg
        * @param Zflag
        * @param base
        * @param limit
        */
        func load(PC :Int, Acc :Int, Xreg:Int, Yreg:Int, Zflag:Int, base:Int, limit:Int) {
        self.PC = PC;
        self.Acc = Acc;
        self.Xreg = Xreg;
        self.Yreg = Yreg;
        self.Zflag = Zflag;
        self.base = base;
        self.limit = limit;
        }
        
        /**
        * Function to handle the dissasembly command
        * @param command the command written in 2 digit hex
        */
        func handleCommand(command:String) {
         //   print("COMMAND READ:" + command);
        // alert(command);
        switch (command) {
        case "A9":
        //load a constant
        self.Acc = Int(_MemoryHandler.read(self.PC + 1), radix:16)!;
        self.PC = self.PC + 2;
        _MemoryHandler.updateMem();
        break;
        
        case "AD":
        
        //load from memory
        
        let oldPC = self.PC;
        self.PC = (self.base) +  Int(_MemoryHandler.read(self.PC + 2) + _MemoryHandler.read(self.PC + 1), radix:16)!;
        
        if (self.checkbounds(self.PC)) {
            self.Acc = Int(_MemoryHandler.read(self.PC), radix:16)!;
            self.PC = oldPC + 3;
        _MemoryHandler.updateMem();
        }
        else {
       // _StdOut.putText("ERROR on AD: Index out of bounds error on process " + _currentProcess);
            _StdOut.string = "ERROR on AD: Index out of bounds error on process" + String(_currentProcess) + _StdOut.string!;
       // _StdOut.advanceLine()
            _StdOut.string = "\r\n" + _StdOut.string!;
       // _StdOut.putText("PC: " + this.PC + " is not in the memory bounds of " + this.base + " and " + this.limit);
            _StdOut.string = "PC: " + String(self.PC) + " is not in the memory bounds of " + String(self.base) + " and " + String(self.limit) + _StdOut.string!;
       // _StdOut.advanceLine();
            _StdOut.string = "\r\n" + _StdOut.string!;
        self.PC = oldPC;
        self.storeToPCB(_currentProcess);
        _currentProcess = 0;
        
        
        break;
        }
        case "8D":
        //store to memory
            let memLoc = (self.base) +  Int((_MemoryHandler.read(self.PC + 2) + _MemoryHandler.read(self.PC + 1)), radix: 16)!;
          //  print("memory location: " + String(memLoc));
        //    print("Combination of: " + String(self.PC + 1) + " : " + _MemoryHandler.read(self.PC + 1));
          //  print("And : " + String(self.PC + 2) + " : " + _MemoryHandler.read(self.PC + 2));
        if (self.checkbounds(memLoc)) {
        if (self.Acc < 9) {
        _MemoryHandler.load(String("0" + String(self.Acc)), index: memLoc);
        }
        else {
            _MemoryHandler.load(self.Acc, index: memLoc);
        }
        self.PC += 3;
        _MemoryHandler.updateMem();
        }
        else {
        //alert(this.base);
        //alert(this.limit);
       // _StdOut.putText("ERROR on 8D: Index out of bounds error on process " + _currentProcess + " PC: " + this.PC);
            _StdOut.string = "ERROR on 8D: Index out of bounds error on process " + String(_currentProcess) + " PC: " + String(self.PC) + _StdOut.string!;
       // _StdOut.advanceLine()
            _StdOut.string = "\r\n" + _StdOut.string!;
       // _StdOut.putText("Memory Location: " + memLoc + " is not in the memory bounds of " + this.base + " and " + this.limit);
            _StdOut.string = "Memory Location: " + String(memLoc) + " is not in the memory bounds of " + String(self.base) + " and " + String(self.limit) + _StdOut.string!;
       // _StdOut.advanceLine();
            _StdOut.string = "\r\n" + _StdOut.string!;
        _Kernel.krnTrace("MemoryOutOfBoundsError");
        self.storeToPCB(_currentProcess);
        _currentProcess = 0;
        }
        break;
        
        case "6D":
        
        //add with carry
        let oldPC = self.PC;
        self.PC = (self.base) + Int(_MemoryHandler.read(self.PC + 2) + _MemoryHandler.read(self.PC + 1), radix:16)!;
        if (self.checkbounds(self.PC)) {
            self.Acc += Int(_MemoryHandler.read(self.PC), radix:16)!;
        self.PC = oldPC + 3;
        _MemoryHandler.updateMem();
        }
        else {
       // _StdOut.putText("ERROR on 6D: Index out of bounds error on process " + _currentProcess);
            _StdOut.string = "ERROR on 6D: Index out of bounds error on process " + String(_currentProcess) + _StdOut.string!;
        //_StdOut.advanceLine();
            _StdOut.string = "\r\n" + _StdOut.string!;
        //_StdOut.putText("PC: " + this.PC + " is not in the memory bounds of " + this.base + " and " + this.limit);
            _StdOut.string = "PC: " + String(self.PC) + " is not in the memory bounds of " + String(self.base) + " and " + String(self.limit) + _StdOut.string!;
        //_StdOut.advanceLine();
            _StdOut.string = "\r\n" + _StdOut.string!;
        _Kernel.krnTrace("IndexOutOfBoundsError");
        self.PC = oldPC;
        self.storeToPCB(_currentProcess);
        _currentProcess = 0;
        }
        break;
        
        case "A2":
         //   print("PC: " + String(self.PC))
       // print("Memory: " + _MemoryHandler.read(self.PC + 1))
          //  print(Int("00" + _MemoryHandler.read(self.PC + 1), radix: 16)!)
        //alert("Xregister loaded with: " + parseInt("0x" + (_MemoryHandler.read(this.PC + 1))));
        //load constant into x register
            self.Xreg = Int("00" + (_MemoryHandler.read(self.PC + 1)) ,radix:16)!;
        self.PC = self.PC + 2;
        _MemoryHandler.updateMem();
        break;
        
        case "AE":
        
        //load x register from memory
        let oldPC = self.PC;
            self.PC = (self.base) + Int("00" + _MemoryHandler.read(self.PC + 2) + _MemoryHandler.read(self.PC + 1),radix:16)!;
        if (self.checkbounds(self.PC)) {
            self.Xreg = Int(_Memory[self.PC], radix:16)!;
        self.PC = oldPC + 3;
        _MemoryHandler.updateMem();
        }
        else {
        //_StdOut.putText("ERROR: Index out of bounds error on process " + _currentProcess);
       _StdOut.string = "ERROR: Index out of bounds error on process " + String(_currentProcess) + _StdOut.string!;
        // _StdOut.advanceLine()
          _StdOut.string = "\r\n" + _StdOut.string!;
       // _StdOut.putText("PC: " + this.PC + " is not in the memory bounds of " + this.base + " and " + this.limit);
            _StdOut.string = "PC: " + String(self.PC) + " is not in the memory bounds of " + String(self.base) + " and " + String(self.limit) + _StdOut.string!;
       // _StdOut.advanceLine();
            _StdOut.string = "\r\n" + _StdOut.string!;
        _Kernel.krnTrace("IndexOutOfBoundsError");
        self.PC = oldPC;
        self.storeToPCB(_currentProcess);
        _currentProcess = 0;
        }
        break;
        
        case "A0":
        
        //load constant into y register
            self.Yreg = Int(_MemoryHandler.read(self.PC + 1),radix:16)!;
        self.PC = self.PC + 2;
        _MemoryHandler.updateMem();
        break;
        
        
        case "AC":
        //load y register from memory
        let oldPC = self.PC;
            self.PC = self.base + Int(_MemoryHandler.read(self.PC + 2) + _MemoryHandler.read(self.PC + 1),radix:16)!;
        if (self.checkbounds(self.PC)) {
            self.Yreg = Int(_MemoryHandler.read(self.PC),radix:16)!;
        self.PC = oldPC + 3;
        _MemoryHandler.updateMem();
        }
        else {
      //  _StdOut.putText("ERROR: Index out of bounds error on process " + _currentProcess);
            _StdOut.string = "ERROR: Index out of bounds error on process " + String(_currentProcess) + _StdOut.string!;
      //  _StdOut.advanceLine()
            _StdOut.string = "\r\n" + _StdOut.string!;
      //  _StdOut.putText("PC: " + this.PC + " is not in the memory bounds of " + this.base + " and " + this.limit);
            _StdOut.string = "\r\n" + _StdOut.string!;
      //  _StdOut.advanceLine();
            _StdOut.string = "PC: " + String(self.PC) + " is not in the memory bounds of " + String(self.base) + " and " + String(self.limit) + _StdOut.string!;
        _Kernel.krnTrace("IndexOutOfBoundsError");
        self.PC = oldPC;
        self.storeToPCB(_currentProcess);
        _currentProcess = 0;
        
        }
        break;
        case "EA":
        
        //Nothing op code
        self.PC = self.PC + 1;
        break;
        
        case "00":
        
        //Break
        //self.isExecuting = false;
        _CPU.storeToPCB(_currentProcess);
        _MemoryHandler.updateMem();
        //document.getElementById("btnStep").disabled = true;
        _RootController.getStepButton().enabled = false;
        _currentProcess = 0;
        break;
        
        case "EC":
        
        //Equals compare of memory to the Xreg
        //first get memory variable
        let oldPC = self.PC;
        self.PC = self.base + Int(_MemoryHandler.read(self.PC + 2) + _MemoryHandler.read(self.PC + 1),radix:16)!;
        if (self.checkbounds(self.PC)) {
            let temp = Int(_MemoryHandler.read(self.PC), radix:16);
        // alert (this.Xreg + " = " + temp );
        if (temp == self.Xreg) {
        // alert("Zflag set to true!");
        self.Zflag = 1;
        }
        else {
        self.Zflag = 0;
        }
        self.PC = oldPC + 3;
        _MemoryHandler.updateMem();
        }
        else {
        //_StdOut.putText("ERROR on EC: Index out of bounds error on process " + _currentProcess);
            _StdOut.string = "ERROR on EC: Index out of bounds error on process " + String(_currentProcess) + _StdOut.string!;
        //_StdOut.advanceLine()
            _StdOut.string = "\r\n" + _StdOut.string!;
        //_StdOut.putText("PC: " + this.PC + " is not in the memory bounds of " + this.base + " and " + this.limit);
            _StdOut.string = "PC: " + String(self.PC) + " is not in the memory bounds of " + String(self.base) + " and " + String(self.limit) + _StdOut.string!;
        //_StdOut.advanceLine();
            _StdOut.string = "\r\n" + _StdOut.string!;
        _Kernel.krnTrace("IndexOutOfBoundsError")
        self.PC = oldPC;
        self.storeToPCB(_currentProcess);
        _currentProcess = 0;
        }
        break;
        
        case "D0":
        
        //  alert("Z flag is " + this.Zflag);
        //BEQ if z flag is not set, branch
        if (self.Zflag == 0) {
        // alert(_MemoryHandler.read(this.PC + 1) + ": Target in mem");
            let offset = Int(_MemoryHandler.read(self.PC + 1), radix:16)!;
        self.PC = self.PC + offset;
        if (self.PC > _Processes[_currentProcess - 1].limit)
        {
        self.PC = self.PC - 255;
        if (!self.checkbounds(self.PC)) {
        //_StdOut.putText("ERROR on D0: Index out of bounds error on process " + _currentProcess);
            _StdOut.string = "ERROR on D0: Index out of bounds error on process " + String(_currentProcess) + _StdOut.string!;
        //_StdOut.advanceLine();
            _StdOut.string = "\r\n" + _StdOut.string!;
       // _StdOut.putText("PC: " + this.PC + " is not in the memory bounds of " + this.base + " and " + this.limit);
            _StdOut.string = "PC: " + String(self.PC) + " is not in the memory bounds of " + String(self.base) + " and " + String(self.limit) + _StdOut.string!;
        _Kernel.krnTrace("IndexOutOfBoundsError")
            
            _StdOut.string = "\r\n" + _StdOut.string!;
       // _StdOut.advanceLine();
        self.PC = self.PC + 255;
        self.storeToPCB(_currentProcess);
        _currentProcess = 0;
        }
        // alert("PC = " + this.PC + " This process is: " + _currentProcess);
        }
        else {
        self.PC = self.PC + 1;
        if (!self.checkbounds(self.PC)) {
       // _StdOut.putText("ERROR on D0: Index out of bounds error on process " + _currentProcess);
            _StdOut.string = "ERROR on D0: Index out of bounds error on process " + String(_currentProcess) + _StdOut.string!;
       // _StdOut.advanceLine();
            _StdOut.string = "\r\n" + _StdOut.string!;
       // _StdOut.putText("PC: " + this.PC + " is not in the memory bounds of " + this.base + " and " + this.limit);
            _StdOut.string = "PC: " + String(self.PC) + " is not in the memory bounds of " + String(self.base) + " and " + String(self.limit) + _StdOut.string!;
       // _StdOut.advanceLine();
            _StdOut.string = "\r\n" + _StdOut.string!;
        _Kernel.krnTrace("IndexOutOfBoundsError")
        self.PC = self.PC - 1;
        self.storeToPCB(_currentProcess);
        _currentProcess = 0;
        }
        //   alert("PC = " + this.PC + " This process is: " + _currentProcess);
        }
        self.PC = self.PC + 1;
        }
        else {
        self.PC = self.PC + 2;
        //   alert("NOT BRANCHING")
        }
        _MemoryHandler.updateMem();
        break;
        
        case "EE":
        
        //increment the byte
        //first read it
        let oldPC = self.PC;
        self.PC = self.base +  Int(_MemoryHandler.read(self.PC + 2) + _MemoryHandler.read(self.PC + 1), radix:16)!;
        if (self.checkbounds(self.PC)) {
            var temp = Int(_MemoryHandler.read(self.PC), radix:16)!;
        //    print(String(self.PC) + ": " + String(temp));
        temp = temp + 1;
        if(temp < 256)
        {
          //  print(temp);
         //   print(String(temp));
        _MemoryHandler.load(temp, index: self.PC);
        _MemoryHandler.updateMem();
        self.PC = oldPC + 3;
        }
        else
        {
      //  _StdOut.putText("ERROR on EE: overflow error on process: " + _currentProcess);
            _StdOut.string = "ERROR on EE: overflow error on process: " + String(_currentProcess) + _StdOut.string!;
      //  _StdOut.advanceLine()
            _StdOut.string = "\r\n" + _StdOut.string!;
        _Kernel.krnTrace("OverFlowError")
        self.PC = oldPC;
        self.storeToPCB(_currentProcess);
        _currentProcess = 0;
        }
        }
        else {
        //_StdOut.putText("ERROR on EE: Index out of bounds error on process " + _currentProcess);
            _StdOut.string = "ERROR on EE: Index out of bounds error on process " + String(_currentProcess) + _StdOut.string!;
        //_StdOut.advanceLine()
            _StdOut.string = "\r\n" + _StdOut.string!;
        //_StdOut.putText("PC: " + this.PC + " is not in the memory bounds of " + this.base + " and " + this.limit);
            _StdOut.string = "PC: " + String(self.PC) + " is not in the memory bounds of " + String(self.base) + " and " + String(self.limit) + _StdOut.string!;
        //_StdOut.advanceLine();
            _StdOut.string = "\r\n" + _StdOut.string!;
        _Kernel.krnTrace("IndexOutOfBoundsError")
        self.PC = oldPC;
        self.storeToPCB(_currentProcess);
        _currentProcess = 0;
        
        }
        break;
        
        
        case "FF":
        //print("INXREG")
        //System Call, check the Xreg
        if (self.Xreg == 2) {
           // print("IN XREG == 2");
        //_StdOut.advanceLine();
            _StdOut.string = "\r\n" + _StdOut.string!;
        //print the yreg to the screen
        var i = self.base;
        var outString = ""
        while (_MemoryHandler.read(self.Yreg + i) != "00" && i < self.limit) {
        //alert("Target = " + (this.Yreg + i));
        //alert(_MemoryHandler.read(this.Yreg + i));
            let charCode = Int(_MemoryHandler.read(self.Yreg + i),radix:16)!;
            let char = String(UnicodeScalar(charCode));
        //_StdOut.putText(char);
            outString = outString + char;
            
        i++;
        }
            //print("PID: " + String(_currentProcess));
           // print("PRINTING: " + outString);
            _StdOut.string = outString + _StdOut.string!;
        }
        if (self.Xreg == 1) {
        //_StdOut.advanceLine();
        _StdOut.string = "\r\n" + _StdOut.string!;
        //_StdOut.putText("" + this.Yreg);
        _StdOut.string = "" + String(self.Yreg) + _StdOut.string!;
        }
        _MemoryHandler.updateMem();
        self.PC += 1;
        break;
        
        default:
        
        //NOT A VALID HEXCODE
        //THROW AN ERROR
       // _DrawingContext.putText("Invalid Code");
       // _DrawingContext.advanceLine();
        self.isExecuting = false;
        _MemoryHandler.updateMem();
        break;
        
        
        }
        }
        
        /**
        * Function to store the current CPU values back to a given PID
        * @param PID the process to store the CPU contents in
        */
        func storeToPCB(PID:Int) {
        _Processes[PID - 1].storeVals(self.PC, Acc2: self.Acc, Xreg2: self.Xreg, Yreg2: self.Yreg, Zflag2: self.Zflag);
        }
        
        /**
        * Function to make a context switch
        */
        func contextSwitch() {
        //alert("Swapping contexts");
        self.storeToPCB(_currentProcess);
        let nextProcess = _ReadyQueue.dequeue()!;
        if(nextProcess.getHardDriveLoc() == "N/A")
        {
        _ReadyQueue.enqueue(_Processes[_currentProcess - 1]);
        nextProcess.loadToCPU();
        }
        else
        {
        // alert(nextProcess == null);
        //alert("ROLLOUT AUTOBOT : " + nextProcess.PID);
        self.rollIn(nextProcess);
        }
        
        //alert(nextProcess.PID + " PC = " + this.PC);
        // alert(this.PC == nextProcess.PC);
        _currentProcess = nextProcess.PID;
        }
        
        /**
        * Function to check the bounds of a function
        * @param memLoc the location to be checked
        * @returns {boolean} wheither or not the program went out of bounds
        */
        func checkbounds(memLoc:Int) ->Bool {
        return memLoc >= self.base && memLoc <= self.limit;
        }
        
        /**
        * Function to convert a number to hex
        * @param dec the decimal number to be converted
        * @returns {string} the string of the hexedecimal equivalenbt
        */
        func toHexDigit(dec: Int) -> String {
        //return dec.toString(16);
        return String(dec, radix: 16)
        }
        
        func rollOut() -> Int
        {
        let targetFile = "Process" + String(_currentProcess);
        //alert("name of file =" + targetFile);
        var buffer = "";
       // var zeroCombo = 0;
        for i in (self.base ... self.limit)
        {
        buffer = buffer + self.toHexDigit(Int(_MemoryHandler.read(i))!);
        }
        _HardDriveDriver.deleteFile(targetFile);
        let holder = _HardDriveDriver.createFile(targetFile);
        _Processes[_currentProcess - 1].setHardDriveLoc(holder);
        _HardDriveDriver.writeToFile(targetFile, data: buffer);
        _ReadyQueue.enqueue(_Processes[_currentProcess - 1]);
        //   alert(_Processes[_currentProcess - 1].base + " target base");
        return _Processes[_currentProcess - 1].base;
        //alert(nextProcess.PID + " PC = " + this.PC);
        // alert(this.PC == nextProcess.PC);
        }
        func rollIn(process:PCB)
        {
        let fileName = "Process" + String(process.PID);
        var buffer = "" + _HardDriveDriver.readFromFile(fileName);
        //alert(nextProcess.PID + " PC = " + this.PC);
        // alert(this.PC == nextProcess.PC);
            let temp = self.rollOut();
        process.PC = process.PC - process.base;
        process.setBase(temp);
        process.setLimit(temp + 255);
        process.PC = process.PC + temp;
        //  alert("Process " + process.PID +  " has pc of " + process.PC + "which should be in between " + process.base + "and " +process.limit);
        process.loadToCPU();
        _currentProcess = process.PID;
        // alert("ROLLING IN " +_currentProcess);
        _HardDriveDriver.deleteFile(fileName);
        //  alert("HEEERE");
        // alert("base " + temp);
      //  var zeroCombo = 1;
        for(var i = process.base; i < process.limit; i++)
        {
        //alert("HALP" + i);
        //alert(buffer.substring(0,2));
        let endIndex = buffer.startIndex.predecessor().predecessor();
        if(buffer.substringWithRange(Range<String.Index>(start: buffer.startIndex, end: endIndex)) == "")
        {
        _MemoryHandler.load("00",index: i);
        }
        else {
        _MemoryHandler.load(buffer.substringWithRange(Range<String.Index>(start: buffer.startIndex, end: endIndex)), index: i);
        }
        //alert("value = " +_MemoryHandler.read(i));
        buffer = buffer.substringWithRange(Range<String.Index>(start: endIndex,end: buffer.endIndex));
        //if we are at the end of the file, fill 0's
        if(buffer.characters.count == 0)
        {
        buffer = "00";
        }
        
        }
        _MemoryHandler.updateMem();
        //  alert("finito");
        process.setHardDriveLoc("N/A");
        }
        }
    
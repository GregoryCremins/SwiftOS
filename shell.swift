//
//  shell.swift
//  XcodeOS
//
//  Created by Marist User on 4/24/16.
//  Copyright © 2016 Marist User. All rights reserved.
//

import Foundation
///<reference path="shellCommand.ts" />
///<reference path="userCommand.ts" />
///<reference path="../utils.ts" />

/* ------------
Shell.ts

The OS Shell - The "command line interface" (CLI) for the console.
------------ */

// TODO: Write a base class / prototype for system services and let Shell inherit from it.

    class Shell {
        // Properties
        var promptStr = ">";
        var  commandList = [ShellCommand]();
        var curses = "[fuvg],[cvff],[shpx],[phag],[pbpxfhpxre],[zbgureshpxre],[gvgf]";
        var apologies = "[sorry]";
        
        
        init() {
        
        }
        
        func initShell() {
            //
            // Load the command list.
            
            // ver
          var sc = ShellCommand(function: shellVer,command:"ver",description:"- Displays the current version data.");
            commandList.append(sc);
            
            // help
            sc = ShellCommand(function: shellHelp,command:"help",description:"- This is the help command. Seek help.");
            commandList.append(sc);
            
            // shutdown
            sc = ShellCommand(function: shellShutdown,command:"shutdown",description:"- Shuts down the virtual OS but leaves the underlying hardware simulation running.");
            commandList.append(sc);
            
            // cls
            sc = ShellCommand(function:shellCls,command:"cls",description:"- Clears the screen and resets the cursor position.");
            commandList.append(sc);
            
            // man <topic>
            sc = ShellCommand(function:shellMan,command:"man",description:"<topic> - Displays the MANual page for <topic>.");
            commandList.append(sc);
            
            // trace <on | off>
            sc = ShellCommand(function:shellTrace,command:"trace",description: "<on | off> - Turns the OS trace on or off.");
            commandList.append(sc);
            
            // rot13 <string>
            sc = ShellCommand(function:shellRot13,command:"rot13",description:"<string> - Does rot13 obfuscation on <string>.");
            commandList.append(sc);
            
            // prompt <string>
            sc = ShellCommand(function:shellPrompt,command:"prompt",description:"<string> - Sets the prompt.");
            commandList.append(sc);
            
            //status
            sc = ShellCommand(function:shellStatusUpdate,command:"status",description:"<string> - Sets the status");
            commandList.append(sc);
            //load
            sc = ShellCommand(function:shellLoad, command:"load", description:"Loads the program input area value");
            commandList.append(sc);
            //run
            sc = ShellCommand(function:shellRun, command:"run",description:"<int> - Runs the process with the given pid");
            commandList.append(sc);
            //step
            sc = ShellCommand(function: shellStep, command:"step",description:"<int> -Runs the process with the given pid in single step mode")
            commandList.append(sc);
            //date
            sc = ShellCommand(function:shellDateTime,command:"datetime", description:"- Tells you the date and time.");
            commandList.append(sc);
            
            //location
            sc = ShellCommand(function: shellLocation, command: "whereami", description:"- Tells you what stage you are on.");
            commandList.append(sc);
            
            //travel to new location
            sc = ShellCommand(function: shellTravel, command:"travel",description: "- Travels you to a new location with a new challenger!");
            commandList.append(sc);
            
            //cause blue screen of death
            sc =  ShellCommand(function: shellBSOD, command: "lose", description: "- Causes a blue screen of death image");
            commandList.append(sc);
            
            //clear the memory
            sc =  ShellCommand(function: shellClearMem, command:"clearmem", description:"-Clears all of the contents in memory");
            commandList.append(sc);
            
            //set the quantum
            sc = ShellCommand(function: shellQuantum, command:"quantum", description:"<int> -Sets the quantum for round robin scheduling");
            commandList.append(sc);
            
            //run all processes
            sc = ShellCommand(function: shellRunAll, command: "runall", description:"-Runs all processes in memory");
            commandList.append(sc);
            
            // processes - list the running processes and their IDs
            sc = ShellCommand(function:shellPS, command:"ps", description: "-Lists all running processes");
            commandList.append(sc);
            
            // kill <id> - kills the specified process id.
            sc = ShellCommand(function:shellKillProcess, command:"kill", description: "<int> -Kills the specified process ")
            commandList.append(sc);
            
            //create <filename>- creates a file in the page table
            sc = ShellCommand(function:shellCreateFile, command:"create", description: "<string> -Creates a file in the page table.");
            commandList.append(sc);
            
            // ls - lists the files in the page table
            sc = ShellCommand(function:shellListDirectory, command:"ls", description: "Lists all files in memory");
            commandList.append(sc);
            
            //write <filename> - read from the file if it exists
            sc = ShellCommand(function:shellWriteFile, command:"write", description:"<string> \"<string>\" - writes the data enclosed in quotes to the file with the given filename");
            commandList.append(sc);
            
            //delete <filename> -deletes a file
            sc = ShellCommand(function:shellDeleteFile, command:"delete", description:"<string> - deletes the specified file from the hard drive");
            commandList.append(sc);
            
            //read <filename> - read a file
            sc = ShellCommand(function:shellReadFile, command:"read", description:"<string> -reads the contents of a file in memory");
            commandList.append(sc);
            
            //format
            sc = ShellCommand(function:shellFormat, command:"format", description: "- Formats the hard drive");
            commandList.append(sc);
            
            //setschedule <schedule> - set the scheduling algorithm
            sc =  ShellCommand(function:shellSetSchedule, command: "setschedule", description: "<string> - sets the scheduling algorithm")
            commandList.append(sc);
            //
            // Display the initial prompt.
            putPrompt();
        }
        
        func putPrompt() {
        //StdOut.putText(this.promptStr);
        }
        
        func handleInput(buffer:String)
        {
        _StdIn.stringValue = ">";
        _Kernel.krnTrace("Shell Command~" + buffer);
       // print(buffer);
        //
        // Parse the input...
        //
        let userCommand = parseInput(buffer);
        // ... and assign the command and args to local variables.
        let cmd = userCommand.command;
        let args = userCommand.args;
        //
        // Determine the command and execute it.
        //
        // JavaScript may not support associative arrays in all browsers so we have to
        // iterate over the command list in attempt to find a match.  TODO: Is there a better way? Probably.
        var index = 0;
        var found = false;
        var fn :([String] -> String);
            fn =   {_ in
                return "dummy";
            }
        while (!found && index < commandList.count) {
        if (commandList[index].command == cmd) {
        found = true;
        fn = commandList[index].function;
        } else {
          
        ++index;
        }
        }
        if (found) {
            execute(fn, args:args);
        } else {
        // It's not found, so check for curses and apologies before declaring the command invalid.
//        if (curses.indexOf("[" + Utils.rot13(cmd) + "]") >= 0) {     // Check for curses. {
//            execute(fn:shellCurse, args:[]);
//        } else if (apologies.indexOf("[" + cmd + "]") >= 0) {    // Check for apologies. {
//            execute(fn:shellApology,args:[]);
//        } else { // It's just a bad command. {
//            execute(fn:shellInvalidCommand,args:[]);
//        }
        }
        }
        
        // args is an option parameter, ergo the ? which allows TypeScript to understand that
        func execute(fn:[String]->String, args:[String]) {
        // We just got a command, so advance the line...
        //_StdOut.advanceLine();
        // ... call the command function passing in the args...
        fn(args);
        // Check to see if we need to advance the line again
       // if (_StdOut.currentXPosition > 0) {
            //_StdOut.string = _StdOut.string! + "\r\n";
        //_StdOut.advanceLine();
       /// }
        // ... and finally write the prompt again.
        putPrompt();
        }
        
        func parseInput(buffer:String) -> UserCommand
        {
        let retVal = UserCommand();
        var buffer2 = buffer;
        // 1. Remove leading and trailing spaces.
            let utils = Utils();
        buffer2 = utils.trim(buffer2);
        
        // 2. Lower-case it.
            let start = buffer2.startIndex;
            var end = buffer2.endIndex;
           if let endTest = buffer2.characters.indexOf(" ")
           {
            end = endTest;
            }
            buffer2 = buffer2.substringWithRange(Range<String.Index>(start: start, end: end)).lowercaseString + buffer2.substringFromIndex(end);
            //print("TEST: " + String(buffer2.characters.count));
           // buffer2 = buffer.substring(0, buffer.indexOf(" ")).toLowerCase() + buffer.substring(buffer.indexOf(" "));
        
        // 3. Separate on spaces so we can determine the command and command-line args, if any.
            var tempList = buffer2.componentsSeparatedByString(" ");
        
        // 4. Take the first (zeroth) element and use that as the command.
        var cmd = tempList.removeFirst()  // Yes, you can do that to an array in JavaScript.  See the Queue class.
        // 4.1 Remove any left-over spaces.
        cmd = utils.trim(cmd);
        // 4.2 Record it in the return value.
        retVal.command = cmd;
        if(tempList.count > 0)
        {
        // 5. Now create the args array from what's left.
        for i in 0...tempList.count - 1 {
        let arg = utils.trim(tempList[i]);
        if (arg != "") {
        retVal.args.append(tempList[i]);
        }
        }
            }
        return retVal;
        }
        
        //
        // Shell Command Functions.  Again, not part of Shell() class per se', just called from there.
        //
        func shellInvalidCommand(args:[String]) {
        _StdOut.string = "\r\n" + _StdOut.string!;
        _StdOut.string =  "Invalid Command." + _StdOut.string! ;
        //_StdOut.putText("Invalid Command. ");
        if (_SarcasticMode) {
        _StdOut.string = " Duh. Go back to your Speack & Spell." + _StdOut.string!  ;
        //_StdOut.putText("Duh. Go back to your Speak & Spell.");
        } else {
        _StdOut.string = " Type \'help\' for, well... help." + _StdOut.string!;
        //_StdOut.putText("Type 'help' for, well... help.");
        }
        }
        
        func shellCurse(args:[String]) {
            _StdOut.string =  "\r\n" + _StdOut.string!;
            _StdOut.string = "Oh, so that's how it's going to be, eh? Fine." + _StdOut.string!;
            _StdOut.string = "\r\n" + _StdOut.string! ;
            _StdOut.string =  "Bitch." + _StdOut.string!;
        //_StdOut.putText("Oh, so that's how it's going to be, eh? Fine.");
        //_StdOut.advanceLine();
        //_StdOut.putText("Bitch.");
        _SarcasticMode = true;
        }
        
        func shellApology(args:[String]) {
        if (_SarcasticMode) {
        _StdOut.string = "\r\n" + _StdOut.string! ;
        //_StdOut.putText("Okay. I forgive you. This time.");
            _StdOut.string = "Okay. I forgive you. This time." + _StdOut.string! ;
        _SarcasticMode = false;
        } else {
        //_StdOut.putText("For what?");
            _StdOut.string = "For what?" + _StdOut.string! ;
        }
        }
        
        func shellVer(args: [String]) -> String {
        _StdOut.string = "\r\n" + _StdOut.string! ;
        _StdOut.string = APP_NAME + " version " + APP_VERSION + _StdOut.string! ;
        return (APP_NAME + " version " + APP_VERSION);
        }
        
        func shellHelp(args:[String]) -> String
    {
        var rtnStr = "Commands:";
        //    _StdOut.putText("Commands:");
       // print (_OSShell.commandList.count);
        for i in 0..._OSShell.commandList.count - 1
        {
        //_StdOut.advanceLine();
        rtnStr = rtnStr + "\r\n"
        _StdOut.string =  "\r\n" + _StdOut.string!;
        _StdOut.string = ("  " + _OSShell.commandList[i].command + " " + _OSShell.commandList[i].description) + _StdOut.string!;
            rtnStr = rtnStr + "  " + _OSShell.commandList[i].command + " " + _OSShell.commandList[i].description
        }
        return rtnStr;
    }
        
        func shellShutdown(args:[String]) -> String {
        let rtnStr = "Shutting down...";
            _StdOut.string = "\r\n" + _StdOut.string!;
        _StdOut.string = "Shutting down..." + _StdOut.string!;
        // Call Kernel shutdown routine.
        _Kernel.krnShutdown();
        return rtnStr;
        // TODO: Stop the final prompt from being displayed.  If possible.  Not a high priority.  (Damn OCD!)
        }
        
        func shellCls(args:[String]) ->String {
        //_StdOut.clearScreen();
        //_StdOut.resetXY();
        _StdOut.string = "";
        _StdIn.stringValue = ">";
        return "";
        }
        
        func shellMan(args:[String]) -> String {
        var rtnStr = "";
        _StdOut.string = "\r\n" + _StdOut.string!;
        if (args.count > 0) {
        let topic = args[0];
        switch (topic) {
        case "help":
        rtnStr = "Help displays a list of (hopefully) valid commands.";
        _StdOut.string = "Help displays a list of (hopefully) valid commands." + _StdOut.string!;
        break;
        default:
        rtnStr = "No manual entry for " + args[0] + ".";
        _StdOut.string = "No manual entry for " + args[0] + "." + _StdOut.string!;
        }
        } else {
        rtnStr = "Usage: man <topic>  Please supply a topic.";
            _StdOut.string =  "Usage: man <topic>  Please supply a topic." + _StdOut.string!;
        }
            return rtnStr
        }
        
        func shellTrace(args:[String]) -> String{
        _StdOut.string = "\r\n" + _StdOut.string!;
            var rtnStr = ""
            if (args.count > 0)
        {
        let setting = args[0];
        switch (setting) {
        case "on":
        if (_Trace && _SarcasticMode) {
            _StdOut.string = "Trace is already on, dumbass." + _StdOut.string! ;

        rtnStr = "Trace is already on, dumbass.";
        } else {
        _Trace = true;
             _StdOut.string = "Trace ON" + _StdOut.string!;
        rtnStr = "Trace ON";
        }
        
        break;
        case "off":
        _Trace = false;
         _StdOut.string =  "Trace OFF" + _StdOut.string!;
        rtnStr = "Trace OFF";
        break;
        default:
        _StdOut.string = "Invalid arguement.  Usage: trace <on | off>." + _StdOut.string!;
        rtnStr = "Invalid arguement.  Usage: trace <on | off>.";
            }
        } else {
        rtnStr = "Usage: trace <on | off>";
        _StdOut.string = "Usage: trace <on | off>." + _StdOut.string!;
        }
            return rtnStr;
        }
        
        func shellRot13(args: [String]) ->String
        {
        _StdOut.string = "\r\n" + _StdOut.string!;
        var rtnStr = "";
        if (args.count > 0) {
        // Requires Utils.ts for rot13() function.
        var tempString = "";
            for a in args
            {
                rtnStr = rtnStr + a + " ";
                tempString = tempString + a + " ";
            }
            rtnStr = rtnStr + "'";
            tempString = tempString + "'";
            rtnStr = rtnStr + " = ";
            let utils = Utils();
            let rot13s = utils.rot13(tempString).characters.map{String($0)}
            for u in rot13s
            {
                rtnStr = rtnStr + u + " ";
            }
        
        } else {
        rtnStr = ("Usage: rot13 <string>  Please supply a string.");
        }
            _StdOut.string = rtnStr + _StdOut.string!;
            return rtnStr;
        }
        
        func shellPrompt(args:[String]) -> String {
       _StdOut.string = "\r\n" + _StdOut.string!;
            if (args.count > 0) {
          _OSShell.promptStr = args[0];
                _StdOut.string = "Done" + _StdOut.string!;
            return "Done";
                
        } else {
                _StdOut.string = "Usage: prompt <string>  Please supply a string." + _StdOut.string!;
        return ("Usage: prompt <string>  Please supply a string.");
        }
        }
        //function to print the date and time
        func shellDateTime(args: [String]) -> String
        {
            _StdOut.string = "\r\n" + _StdOut.string!;
            let currentDate = NSDate();
            let formatter = NSDateFormatter();
            formatter.dateStyle = .FullStyle;
            formatter.dateFormat = "EEE, dd/MM/yyyy hh:mm:ss zzz"
            let timeString = formatter.stringFromDate(currentDate);
            _StdOut.string = timeString + _StdOut.string!;
            return timeString;

//        var d = new Date();
//        d.setTime(Date.now());
//        var day = d.getDay();
//        var mins = d.getMinutes();
//        var minString = ""
//        var stringDay = "";
//        switch(day){
//        case 0:
//        stringDay = "Sun";
//        break;
//        case 1:
//        stringDay = "Mon";
//        break;
//        case 2:
//        stringDay = "Tues";
//        break;
//        case 3:
//        stringDay = "Wed";
//        break;
//        case 4:
//        stringDay = "Thurs";
//        break;
//        case 5:
//        stringDay = "Fri";
//        break;
//        case 6:
//        stringDay = "Sat";
//        break;
//        default:
//        "GARBAGE DAY!"
//        break;
//        }
//        if(mins < 10)
//        {
//        minString = "0" + mins;
//        }
//        else
//        {
//        minString = "" + mins;
//        }
//        _StdOut.putText("The date is: " + stringDay + ", " + (d.getMonth() + 1) + "/" + d.getDate() + "/" + d.getFullYear());
//        _StdOut.advanceLine();
//        var hours = d.getHours();
//        if(hours >= 12) {
//        hours = hours - 12;
//        _StdOut.putText("The time is: " + hours + ":" + minString + ":" + d.getSeconds() + " P.M.");
//        }
//        else
//        {
//        _StdOut.putText("The time is: " + hours + ":" + d.getMinutes() + ":" + d.getSeconds() + " A.M.");
//        }
        }
        // function to change the users location
        func shellTravel(args:[String]) -> String
        {
        _StdOut.string = "\r\n" + _StdOut.string!;
        STAGE =  Int(arc4random_uniform(9) + 1)
         _StdOut.string = "Now traveling to new stage!" + _StdOut.string!;
        return ("Now traveling to new stage!");
        }
        //function to tell the user their current location
        func shellLocation(args:[String]) -> String
        {
        _StdOut.string = "\r\n" + _StdOut.string!;
        let s = STAGE;
        switch(s){
        case 0:
        _StdOut.string = "Current Location: USA." + _StdOut.string!;
        return ("Current Location: USA.");
        case 1:
        _StdOut.string = "Current Location: Canada." + _StdOut.string!;
        return ("Current Location: Canada.");
        case 2:
        _StdOut.string = "Current Location: Brazil." + _StdOut.string!;
        return ("Current Location: Brazil.");
        case 3:
        _StdOut.string =  "Current Location: Japan." + _StdOut.string!;
        return ("Current Location: Japan.");
        case 4:
        _StdOut.string = "Current Location: Soviet Union." + _StdOut.string!;
        return ("Current Location: Soviet Union.");
        case 5:
        _StdOut.string = "Current Location: China." + _StdOut.string!;
        return ("Current Location: China.");
        case 6:
        _StdOut.string = "Current Location: India." + _StdOut.string!;
        return ("Current Location: India.");
        case 7:
        _StdOut.string = "Unknown Laboratory!" + _StdOut.string!;
        return ("Current Location: Unknown Laboratory!");
        case 8:
        _StdOut.string = "Ancient temple!!!!" + _StdOut.string!;
        return ("Current Location: Ancient temple!!!!")
        default:
        _StdOut.string = "SHIT BE FUCKED UP BRA!" + _StdOut.string!;
        return ("SHIT BE FUCKED UP BRA!");
        }
       // _StdOut.advanceLine();
       // _StdOut.putText(s);
        }
        //function to update the status
        func shellStatusUpdate(args:[String]) -> String
        {
        _StdOut.string = "\r\n" + _StdOut.string!;
        if (args.count > 0) {
        let newStatus = args[0];
        _StatusHandler.updateStatus(newStatus);
            _StdOut.string = "Status Updated" + _StdOut.string! ;
        return ("Status Updated");
        } else {
        _StdOut.string =  "Usage: status <string>  Please supply a string." + _StdOut.string!;
        return ("Usage: status <string>  Please supply a string.");
        }
        }
        //function to cause a blue screen of death
        func shellBSOD(args:[String]) -> String {
        // Call Kernel trap
        _Kernel.krnTrapError("Forced Bsod. Rage quit.");
        _StdOut.string = "Forced Bsod. Rage Quit." + _StdOut.string!;
            return "Forced Bsod. Rage Quit.";
        
        }
        
        //function to load the data from the program input into memory
        //the loading actually doesn't work, as of right now it only validates the code
        func shellLoad(arg: [String]) -> String
        {
            
            var priorityNum: Int = 0;
            var testP = PCB();
            if(arg.count > 0)
            {
            let priority = arg[0]
            let priorityO : Int? = Int(priority)
  
        if(priorityO != nil)
        {
            priorityNum = priorityO!;
        }
            }
        var errorFlag = 0;
            let program =  _RootController.getProgramInputView().stringValue.componentsSeparatedByString(" "); // _ProgramInput.value.toString().split(" ");
        var isValid = true;
            
        
        for(var j = 0; j < program.count; j++) {
        let text = program[j];
        for (var i = 0; i < text.characters.count; i++) {
            let char = text.substringWithRange(Range<String.Index>(start: text.startIndex.advancedBy(i),end: text.startIndex.advancedBy(i).successor()));
            let charcode = char.unicodeScalars[char.unicodeScalars.startIndex];
        //print(String(char) + ": " + String(charcode));
        if ((charcode >= UnicodeScalar(48) && charcode <= UnicodeScalar(57)) //|| (charcode == 36) || (charcode == 28) || (charcode == 29) //numbers
        || ((charcode == UnicodeScalar(65) || charcode == UnicodeScalar(66) || charcode == UnicodeScalar(67) || charcode == UnicodeScalar(68) || charcode == UnicodeScalar(69) || charcode == UnicodeScalar(70)) && String(char) == String(char).uppercaseString))
        {
        isValid = isValid && true;
        }
        else {
        isValid = false;
        }
     }
        if(text.characters.count > 2 || text.characters.count == 0)
        {
            isValid = false;
        }
        }
        if(isValid) {
        //check the ready queue
        var readyFlag = false;
        if(!_ReadyQueue.isEmpty()) {
        for (var k = 0; k < _ReadyQueue.getSize(); k++) {
        let targetProcess = _ReadyQueue.dequeue()!;
        let targetPID = targetProcess.getPID();
        if (_pidsave == targetPID) {
        readyFlag = true;
        }
        _ReadyQueue.enqueue(targetProcess);
        }
        }
        //check if it is running in the CPU
        if (_pidsave == _currentProcess || readyFlag == true) {
        errorFlag = 2;
        }
        else {
        testP = PCB();
        testP.setPID(_pidsave);
        var thing = _pidsave;
        if(_pidsave > 3)
        {
        thing = 1;
        }
        testP.setPCval(256 * (thing - 1));
        testP.setBase(256 * (thing - 1));
        testP.setLimit(testP.base + 255);
        testP.setPriority(priorityNum);
        //alert("Test.PID = " + test.PID);
        _pidsave = _pidsave + 1;
        //Handle multiple Processes
        if (_Processes.count < 3) {
        
            _Processes.append(testP);
        let offset = 256 * (_Processes.count - 1);
        for (var h = 0; h < program.count; h++) {
        _MemoryHandler.load(program[h], index: h + offset);
//       _CPUElement.focus();
//        _Canvas.focus();
         //   print("HERE" + program[h]);
            
//        
        }
        _MemoryHandler.updateMem();
        }
        else
        {
        _Processes.append(testP);
        let filename = "Process" + String(testP.PID);
        var buffer = "";
        for(var h = 0; h < program.count; h++)
        {
        buffer = buffer + program[h];
        }
        let t = _HardDriveDriver.createFile(filename);
        _HardDriveDriver.writeToFile(filename, data: buffer);
        testP.setHardDriveLoc(t);
        _MemoryHandler.updateMem();
        }
        
        }
        }
        else
        {
        errorFlag = 1;
        
        }
        //make sure we didnt have error
        switch(errorFlag)
        {
        case 0:
//        _StdOut.putText("Program validated and loaded successfully. PID = " + test.PID);
        _StdOut.string = "Program validated and loaded successfully. PID = " + String(testP.PID) + _StdOut.string!
        _StdOut.string = "\r\n" + _StdOut.string!;
//        break;
        case 1:
        
       // _StdOut.putText("Program not validated. Accepted characters: spaces, 0-9, and A-F only.");
            _StdOut.string = "Program not validated. Accepted characters: spaces, 0-9, and A-F only." + _StdOut.string!
        _StdOut.string = "\r\n" + _StdOut.string!;
        
       case 2:
//        _StdOut.putText("Loading target is either on ready queue or currently in CPU, to prevent errors in execution, program not loaded");
        _StdOut.string = "Loading target is either on ready queue or currently in CPU, to prevent errors in execution, program not loaded" + _StdOut.string!;
        _StdOut.string = "\r\n" + _StdOut.string!;
        default:
            break;

        }
        return "";
        
        }
        func shellRun(args: [String]) ->String
        {
            var pid = 0;
            if(args.count > 0)
            {
            pid = Int(args[0])!
            }
        if(_Processes.count >= pid)
        {
        if(_CPU.isExecuting)
        {
        _ReadyQueue.enqueue(_Processes[pid - 1]);
        if(_CPU.scheduling == "priority")
        {
        _ReadyQueue.sortQueue();
        }
//        //alert("ON THE READY QUEUE");
        
        }
            
        else
        {
        _Processes[pid - 1].loadToCPU();
        _currentProcess = pid;
        _CPU.isExecuting = true;
        }
        }
        
        else
        {
//        _StdOut.putText("Error: no programs loaded into memory.");
            _StdOut.string = "Error: no programs loaded into memory." + _StdOut.string!;
        }
            return "derp";
        }
        
        func shellStep(args:[String]) -> String
        {
        _StdOut.string = "\r\n" + _StdOut.string!;
        let pid = Int(args[0])!;
        if(_Processes.count >= pid)
        {
        _Processes[pid - 1].loadToCPU();
       _CPU.isExecuting = true;
        _SteppingMode = true;
//        document.getElementById("btnStep").disabled = false;
            _RootController.getStepButton().enabled = true;
        _currentProcess = pid;
            return "derp";
        }
        else
        {
        _StdOut.string = "Error: no programs loaded into memory." + _StdOut.string!;
        return ("Error: no programs loaded into memory.");
        }
        }
        
        func shellClearMem(args:[String]) -> String
        {
        _StdOut.string = "\r\n" + _StdOut.string!;
       for i in  0..._Memory.count
        {
       _MemoryHandler.load("00",index: i);
       }
        _currentProcess = 0;
        _Processes = [PCB()];
        _MemoryHandler.updateMem();
        _StdOut.string = "Memory Cleared" + _StdOut.string!;
        return("Memory Cleared");
        }
        
        //set the quantum
        func shellQuantum(args:[String]) -> String
        {
            _StdOut.string = "\r\n" + _StdOut.string!;
        let q = Int(args[0])!
        if(q > 0)
        {
           
        if(!_CPU.isExecuting)
        {
        _quantum = q;
//        _StdOut.putText("Quantum now set to: " + _quantum);
        _StdOut.string =  "Quantum now set to: " + String(_quantum) + _StdOut.string!;
        }
        else
        {
         _StdOut.string = "Please wait until the CPU has completed execution before changing the quantum." + _StdOut.string!;
      //  _StdOut.putText("Please wait until the CPU has completed execution before changing the quantum.");
        
        }
        }
        else
        {
        _StdOut.string =  "Invalid value for Quantum. Please use a number greater than 0" + _StdOut.string!;
        return("Invalid value for Quantum. Please use a number greater than 0");
        }
             return "derp";
        }
        
        //kill a process
        func shellKillProcess(args:[String]) -> String
        {
            _StdOut.string = "\r\n" + _StdOut.string!;
        let pid = Int(args[0])!
        var foundPID = false;
        if(_currentProcess == pid)
        {
        //alert("TRYING TO KILL");
        //alert(_currentProcess);
        //alert(_CPU.PC);
        _CPU.storeToPCB(_currentProcess);
        _currentProcess = 0;
        foundPID = true;
        }
        else
        {
        // alert("TRYING TO REMOVE FROM QUEUE");
        //check readyQueue
        var flag = false;
            let resultQueue = Queue(q2:[PCB]());
        while (flag == false)  {
        let testProcess = _ReadyQueue.dequeue()!;
        if (testProcess.PID != pid) {
        //alert(testProcess.PID);
        resultQueue.enqueue(testProcess);
        //alert(resultQueue.getSize());
        }
        else
        {
        //alert(testProcess.PID);
        foundPID = true;
        //testProcess.storeToPCB(testProcess.getPID());
        }
        flag = _ReadyQueue.getSize() <= 0;
        }
        _ReadyQueue = resultQueue;
        }
        if(foundPID)
        {
        //_StdOut.putText("Successfully killed process " + pid);
            _StdOut.string =  "Successfully killed process" + String(pid) + _StdOut.string!;
            return ("Successfully killed process" + String(pid));
        }
        else
        {
        //_StdOut.putText("Process not found. No processes killed.")
            _StdOut.string = "Process not found. No processes killed." + _StdOut.string!;
        }
        //_StdOut.advanceLine();
        _MemoryHandler.updateMem();
            return "\n\r";
        //_Canvas.focus();
        
        }
        
        //run all programs
        func shellRunAll(args:[String]) -> String
        {
        _StdOut.string = "\r\n" + _StdOut.string!;
        for i  in 0 ... _Processes.count - 1
        {
        _ReadyQueue.enqueue(_Processes[i]);
        }
        if(_CPU.scheduling == "priority")
        {
        _ReadyQueue.sortQueue();
        }
        _CPU.isExecuting = true;
        _currentProcess = 0;
        //alert(_currentProcess);
        //_StdOut.putText("Running all processes");
        _StdOut.string = "Running all processes" + _StdOut.string!;
        return "Running all processes";
        }
        
        //show running proesses
        func shellPS(args:[String]) -> String
        {
            _StdOut.string = "\r\n" + _StdOut.string!;
        if(_CPU.isExecuting)
        {
//        _StdOut.putText("Process " + _currentProcess + " in the CPU");
        _StdOut.string = "Process " + String(_currentProcess) + " in the CPU" + _StdOut.string!;
//        _StdOut.advanceLine();
        _StdOut.string = "\r\n" + _StdOut.string!;
        let resultQueue = Queue(q2:[PCB]());
        while(_ReadyQueue.getSize() > 0)
        {
        let pros = _ReadyQueue.dequeue()!;
//        _StdOut.putText("Process " + pros.PID + " is running but waiting on the ready queue");
_StdOut.string = "Process " + String(pros.PID) + " is running but waiting on the ready queue" + _StdOut.string!;
//        _StdOut.advanceLine();
            _StdOut.string = "\r\n" + _StdOut.string!;
            resultQueue.enqueue(pros);
        }
        _ReadyQueue = resultQueue;
        }
        else
        {
        _StdOut.string =  "There are no running processes." + _StdOut.string!;

       //_StdOut.putText("There are no running processes.");
        }
            return "derp";
        }
        //create a file in memory
        func shellCreateFile(args:[String]) -> String
        {
            _StdOut.string = "\r\n" + _StdOut.string!;
        let fileName = args[0]
        let t = _HardDriveDriver.createFile(fileName);
        _StdOut.string = "Successfully created file at location: " + String(t) + _StdOut.string!;
       // _StdOut.putText("Successfully created file at location: " + t);
        return ("Successfully created file at location: " + t);
        }
        func shellListDirectory(args:[String]) -> String
        {
        _HardDriveDriver.listHardDrive();
            return "derp";
        }
        func shellDeleteFile(args:[String]) ->String
        {
            _StdOut.string = "\r\n" + _StdOut.string!;
        let fileName = args[0]
        let success = _HardDriveDriver.deleteFile(fileName);
        if(success)
        {
            
        _StdOut.string = "Successfully removed file" + _StdOut.string!;
        //_StdOut.putText("Successfully removed file");
            return "Successfully removed file";
        }
        else
        {
        _StdOut.string = "Error: file not found." + _StdOut.string!;
        //_StdOut.putText("Error: file not found.")
        return "Error: file not found.";
            }
        }
        func shellReadFile(args:[String]) -> String
        {
        let fileName = args[0];
        let out = _HardDriveDriver.readFromFile(fileName);
        _StdOut.string =  out + _StdOut.string!;
            
        return out + "\n\r";
        //_StdOut.putText(out);
        //_StdOut.advanceLine();
        }
        func shellWriteFile(args:[String]) -> String
        {
        _StdOut.string = "\r\n" + _StdOut.string!;
        if(args.count == 2)
        {
        let fileName = args[0];
        let data = args[1];
        if(data.substringWithRange(Range<String.Index>(start: data.startIndex, end: data.startIndex.successor())) == "\"" && "\""  == data.substringFromIndex(data.endIndex.predecessor()))
        {
        _HardDriveDriver.writeToFile(fileName, data: data.substringWithRange(Range<String.Index>(start: data.startIndex.successor(), end: data.endIndex.predecessor())));
        
        }
        else
        {
//        _StdOut.putText("Please surround the data with quotes");
        _StdOut.string =  "Please surround the data with quotes" + _StdOut.string!;
        }
        }
        else
        {
//        _StdOut.putText("Please provide 2 arguements, the file name and the data to be written");
        _StdOut.string =  "Please provide 2 arguements, the file name and the data to be written" + _StdOut.string!;
        }
            return "derp";
        }
        func shellFormat(args:[String]) -> String
        {
            _StdOut.string = "\r\n" + _StdOut.string!;

        _HardDriveDriver.formatHardDrive();
            _StdOut.string =  "Hard drive formatted" + _StdOut.string!;

        return "Hard drive formatted";
        }
        
        func shellSetSchedule(args:[String]) -> String
        {
            _StdOut.string =  "\r\n" + _StdOut.string!;
            let scheduling = args[0];
         
        if(!_CPU.isExecuting) {
        if (scheduling == "priority" || scheduling == "fcfs" || scheduling == "rr") {
        _CPU.scheduling = scheduling;
      //  _StdOut.putText("Scheduling set");
        _StdOut.string = "Scheduling set" + _StdOut.string!;
        _CPU.updateUI();
        }
        else {
        _StdOut.string =  "Error: Invalid scheduling chosen. Please choose either rr, priority, or fcfs" + _StdOut.string!;
       // _StdOut.putText("Error: Invalid scheduling chosen. Please choose either rr, priority, or fcfs");
        }
//        
        }
        else
        {
            _StdOut.string = "Please wait for CPU to finish executing before changing the scheduling" + _StdOut.string!;
//        _StdOut.putText("Please wait for CPU to finish executing before changing the scheduling")
        }
           return scheduling;
        }
    }
 
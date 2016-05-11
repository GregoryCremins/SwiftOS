//
//  control.swift
//  XcodeOS
//
//  Created by Marist User on 4/28/16.
//  Copyright © 2016 Marist User. All rights reserved.
//

import Foundation
import Cocoa

///<reference path="../globals.ts" />
///<reference path="../os/canvastext.ts" />

/* ------------
Control.ts

Requires globals.ts.

Routines for the hardware simulation, NOT for our client OS itself.
These are static because we are never going to instantiate them, because they represent the hardware.
In this manner, it's A LITTLE BIT like a hypervisor, in that the Document environment inside a browser
is the "bare metal" (so to speak) for which we write code that hosts our client OS.
But that analogy only goes so far, and the lines are blurred, because we are using TypeScript/JavaScript
in both the host and client environments.

This (and other host/simulation scripts) is the only place that we should see "web" code, such as
DOM manipulation and event handling, and so on.  (Index.html is -- obviously -- the only place for markup.)

This code references page numbers in the text book:
Operating System Concepts 8th edition by Silberschatz, Galvin, and Gagne.  ISBN 978-0-470-12872-5
------------ */

//
// Control Services
//

    
     class Control {
        
        func hostInit(view: RootViewController) {
            _RootController = view;
            // Get a global reference to the canvas.  TODO: Move this stuff into a Display Device Driver, maybe?
            //_Canvas = <HTMLCanvasElement>document.getElementById('display');
            
            // Get a global reference to the drawing context.
            //_DrawingContext = _Canvas.getContext('2d');
            
            // Enable the added-in canvas text functions (see canvastext.ts for provenance and details).
            // CanvasTextFunctions.enable(_DrawingContext);   // Text functionality is now built in to the HTML5 canvas. But this is old-school, and fun.
            
            //enable text functions for status bar
            
            // _StatusCanvas = <HTMLCanvasElement>document.getElementById("statusCanvas");
            _StatusCanvas = view.getUIField();
            // _StatusContext = _StatusCanvas.getContext("2d");
            // _StatusHandler = new TSOS.statusBarHander();
            
            
            //initialize hard drive
            _HardDriveDriver = deviceDriverHardDrive();
            
            
            //create memory
            _MemoryHandler =  memory();
            _CPUElement = view.getCPUView();
            //_CPUElement = (<HTMLInputElement>document.getElementById("CPU"));
            _MemoryElement2 = view.getMemoryView();
            // _MemoryElement2 = (<HTMLTableElement>document.getElementById("memory2.0"));
            // _PCBElement = (<HTMLTableElement> document.getElementById("pcbs"));
            
            // Clear the log text box.
            // Use the TypeScript cast to HTMLInputElement
            // (<HTMLInputElement> document.getElementById("taHostLog")).value="";
            
            //Get the program input button
            //   _ProgramInput = <HTMLTextAreaElement>document.getElementById("taProgramInput");
            
            // Set focus on the start button.
            // Use the TypeScript cast to HTMLInputElement
            //  (<HTMLInputElement> document.getElementById("btnStartOS")).focus();
            
            // Check for our testing and enrichment core.
            //     if (Glados.subjectType === "function") {
            //    _GLaDOS = Glados();
            //    _GLaDOS.init();
            //   }
        }
    
    func hostLog(msg: String, source: String = "?") {
        // Note the OS CLOCK.
        let clock: Int = _OSclock;
        
        // Note the REAL clock in milliseconds since January 1, 1970.
        let now: Int = Int(NSDate().timeIntervalSince1970 * 1000);
        
        // Build the log string.
        var str: String = "({ clock:" + String(clock) ;
        str = str + ", source:" + source;
        str = str + ", msg:" + msg;
        str = str + ", now:" + String(now)  + " })";
        str = str + "\n";
        
        // Update the log console.
        //var taLog = <HTMLInputElement> document.getElementById("taHostLog");
      //  var taLog = RootViewController.getHostLogOutput();
        let taLog = _RootController.getHostLogOutput();
       taLog.string =  str + taLog.string!;
        // Optionally update a log database or some streaming service.
        
        
        
        _StatusHandler.updateStatus(STATUS);
    }
    
    
    //
    // Host Events
    //
        func hostBtnStartOS_click() {
        // Disable the (passed-in) start button...
//      btn.disabled = true;
//        
//        // .. enable the Halt and Reset buttons ...
//        document.getElementById("btnHaltOS").disabled = false;
        
//        document.getElementById("btnReset").disabled = false;
//        
//        // .. set focus on the OS console display ...
//        document.getElementById("display").focus();
//        
//        // ... Create and initialize the CPU (because it's part of the hardware)  ...
        _CPU = Cpu();
        _CPU.initCPU();
        _OSStarted = true;
//        
//        // ... then set the host clock pulse ...
       // _hardwareClockID = setInterval(Devices.hostClockPulse, CPU_CLOCK_INTERVAL);
//        // .. and call the OS Kernel Bootstrap routine.
        _Kernel = Kernel();
        _Kernel.krnBootstrap();
//        //update memory
            _ReadyQueue = Queue(q2:[PCB]());
        _MemoryHandler.updateMem();
//        
//        
    }
    
//    public static hostBtnHaltOS_click(btn): void {
//        Control.hostLog("Emergency halt", "host");
//        Control.hostLog("Attempting Kernel shutdown.", "host");
//        // Call the OS shutdown routine.
//        _Kernel.krnShutdown();
//        // Stop the interval that's simulating our clock pulse.
//        clearInterval(_hardwareClockID);
//        // TODO: Is there anything else we need to do here?
//        //update the status to killed
//        _StatusHandler.updateStatus("Halted");
//    }
//    
//    public static hostBtnReset_click(btn): void {
//        // The easiest and most thorough way to do this is to reload (not refresh) the document.
//        location.reload(true);
//        // That boolean parameter is the 'forceget' flag. When it is true it causes the page to always
//        // be reloaded from the server. If it is false or not specified the browser may reload the
//        // page from its cache, which is not what we want.
//    }
//    public static hostBtnStep_click(btn): void
//    {
//        //for single step execution of processes
//        if(_CPU.isExecuting && _SteppingMode == true)
//        {
//            _CPU.cycle();
//        }
//        
//    }
}

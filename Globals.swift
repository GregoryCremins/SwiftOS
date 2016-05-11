//
//  Globals.swift
//  MenuBar
//
//  Created by Marist User on 1/28/16.
//  Copyright © 2016 Marist User. All rights reserved.
//

import Foundation
import Cocoa

/* ------------
   Globals.ts

   Global CONSTANTS and _Variables.
   (Global over both the OS and Hardware Simulation / Host.)

   This code references page numbers in the text book:
   Operating System Concepts 8th edition by Silberschatz, Galvin, and Gagne.  ISBN 978-0-470-12872-5
   ------------ */

//
// Global "CONSTANTS" (There is currently no const or final or readonly type annotation in TypeScript.)
// TODO: Make a global object and use that instead of the "_" naming convention in the global namespace.
//
var _Control = Control();
var _Devices = Devices();
var _RootController = RootViewController();
var _OSStarted = false;
var APP_NAME: String    = "XOS"   // Xcode os
var APP_VERSION: String = ".1" //Its still in beta
//The current location for whereami
var STAGE: Int = 0
//the status
var STATUS: String = "Type command: status <string> to change your status";

//Status bar variables
//var _StatusCanvas: HTMLCanvasElement = null; //Initialized in statusBar2.0;
var _StatusCanvas = NSTextField();
//var _StatusContext = null; //Initialized in statusBar2.0;
var _StatusHandler = statusBarHander(); //Initialized in statusBar2.0;
var _MemoryHandler = memory(); //Creates a memory handlerS
var _MemoryElement2 = NSTableView();
//var _MemoryElement2 = null; // The memory element 2
var _PCBElement = NSTextView();
var _Memory = [String](count: 768, repeatedValue: "00");
var _DisplayedMem = [String](count:256,repeatedValue: "00");
//Array.apply(null, new Aaprray(768)).map(String.prototype.valueOf,"00");                       // Memory for Assembly commands
var _CPUElement = NSTextField();                // Memory HTML element
var _currentProcess = 0;                 //the current running process
var _Processes = [PCB]();                      // Array of processes
var _pidsave = 1
var CPU_CLOCK_INTERVAL: Int = 100;   // This is in ms, or milliseconds, so 1000 = 1 second.
var _SteppingMode = false;             //For single step debugging of program input
var TIMER_IRQ: Int = 0;  // Pages 23 (timer), 9 (interrupts), and 561 (interrupt priority).
                            // NOTE: The timer is different from hardware/host clock pulses. Don't confuse these.
//var KEYBOARD_IRQ: number = 1;

//program input
var _ProgramInput = ""; // Initialized in hostinit

//hard drive
 var _HardDrive = HardDrive()
 var _HardDriveDriver = deviceDriverHardDrive();
var _localStorage = [String: String]();
//
// Global Variables
//
var _CPU = Cpu();  // Utilize TypeScript's type annotation system to ensure that _CPU is an instance of the Cpu class.

var _OSclock: Int = 0  // Page 23.

var _Mode: Int = 0     // (currently unused)  0 = Kernel Mode, 1 = User Mode.  See page 21.

//var _Canvas: HTMLCanvasElement = null;  // Initialized in hostInit().
//var _DrawingContext = null;             // Initialized in hostInit().
//var _DefaultFontFamily = "sans";        // Ignored, I think. The was just a place-holder in 2008, but the HTML canvas may have use for it.
//var _DefaultFontSize = 13;
//var _FontHeightMargin = 4;              // Additional space added to font size when advancing a line.



var _Trace = true;  // Default the OS trace to be on.

// The OS Kernel and its queues.
var _Kernel = Kernel();
var _KernelInterruptQueue = InterruptQueue(q2:[Interrupt]());  // A (currently) non-priority queue for interrupt requests (IRQs).
var _KernelBuffers = [Interrupt]();
var _KernelInputQueue = StringQueue(q2:[String]());

//OS Processes queue
var _ReadyQueue = Queue(q2:[PCB]());
var _quantum = 6;

// Standard input and output
var _StdIn  = NSTextField();
var _StdOut = NSTextView();
// UI
var _Console = Console();
var _OSShell = Shell();

// At least this OS is not trying to kill you. (Yet.)
var _SarcasticMode = false;

// Global Device Driver Objects - page 12
var  _krnKeyboardDriver = DeviceDriverKeyboard();

var _hardwareClockID=0;

// For testing...
//var _GLaDOS: any = null;
//var Glados: any = null;

///var onDocumentLoad = function() {
//	Control.hostInit();

//};
//
//  Kernal.swift
//  XcodeOS
//
//  Created by Marist User on 3/3/16.
//  Copyright © 2016 Marist User. All rights reserved.
//

import Foundation
/* ------------
Kernel.ts

Requires globals.ts

Routines for the Operating System, NOT the host.

This code references page numbers in the text book:
Operating System Concepts 8th edition by Silberschatz, Galvin, and Gagne.  ISBN 978-0-470-12872-5
------------ */

    
class Kernel : NSObject {
        //
        // OS Startup and Shutdown Routines
        //
        func krnBootstrap() {      // Page 8. {
        _Control.hostLog("bootstrap", source: "host");  // Use hostLog because we ALWAYS want this, even if _Trace is off.
        
        // Initialize our global queues.
            _KernelInterruptQueue = InterruptQueue(q2: [Interrupt]());  // A (currently) non-priority queue for interrupt requests (IRQs).
        _KernelBuffers =  Array();         // Buffers... for the kernel.
            _KernelInputQueue = StringQueue(q2: [String]());      // Where device input lands before being  out somewhere.
        _Console = Console();          // The command line interface / console I/O device.
        
        // Initialize the console.
            _Console.initConsole();
      
        // Initialize standard input and output to the _Console.
        _StdIn  = _RootController.getUIField();
        _StdOut = _RootController.getUserOutput();
        
        // Load the Keyboard Device Driver
        krnTrace("Loading the keyboard device driver.");
        _krnKeyboardDriver =  DeviceDriverKeyboard();     // Construct it.
      // _krnKeyboardDriver.driverEntry();                    // Call the driverEntry() initialization routine.
            krnTrace(_krnKeyboardDriver.status);
        
        //
        // ... more?
        //
        
        // Enable the OS Interrupts.  (Not the CPU clock interrupt, as that is done in the hardware sim.)
        krnTrace("Enabling the interrupts.");
        krnEnableInterrupts();
        
        // Launch the shell.
        krnTrace("Creating and Launching the shell.");
        _OSShell = Shell();
        _OSShell.initShell();
        
        // Finally, initiate testing.
      //  if (_GLaDOS) {
      //  _GLaDOS.afterStartup();
      //  }
        }
        
        func krnShutdown() {
        self.krnTrace("begin shutdown OS");
        // TODO: Check for running processes.  Alert if there are some, alert and stop.  Else...
        // ... Disable the Interrupts.
        self.krnTrace("Disabling the interrupts.");
        self.krnDisableInterrupts();
        //update status
        _StatusHandler.updateStatus("Halted");
        //
        // Unload the Device Drivers?
        // More?
        //
        self.krnTrace("end shutdown OS");
        }
        
        
        func krnOnCPUClockPulse() {
        /* This gets called from the host hardware sim every time there is a hardware clock pulse.
        This is NOT the same as a TIMER, which causes an interrupt and is handled like other interrupts.
        This, on the other hand, is the clock pulse from the hardware (or host) that tells the kernel
        that it has to look for interrupts and process them if it finds any.                           */
        
        // Check for an interrupt, are any. Page 560
        if (_KernelInterruptQueue.getSize() > 0)
        {
        // Process the first interrupt on the interrupt queue.
        // TODO: Implement a priority queue based on the IRQ number/id to enforce interrupt priority.
        let interrupt = _KernelInterruptQueue.dequeue()!;
        self.krnInterruptHandler(interrupt.irq, params: interrupt.params);
        } else if (_CPU.isExecuting && !_SteppingMode) { // If there are no interrupts then run one CPU cycle if there is anything being processed.
        _CPU.cycle();
        } else {                      // If there are no interrupts and there is nothing being executed then just be idle. {
        self.krnTrace("Idle");
        }
        }
        
        
        //
        // Interrupt Handling
        //
        func krnEnableInterrupts() {
        // Keyboard
        _Devices.hostEnableKeyboardInterrupt();
        // Put more here.
        }
        
        func krnDisableInterrupts() {
        // Keyboard
        //_Devices.hostDisableKeyboardInterrupt();
        // Put more here.
        }
        
        func krnInterruptHandler(irq:String, params:[String]) {
        // This is the Interrupt Handler Routine.  Pages 8 and 560. {
        // Trace our entrance here so we can compute Interrupt Latency by analyzing the log file later on.  Page 766.
        krnTrace("Handling IRQ~" + irq);
        
        // Invoke the requested Interrupt Service Routine via Switch/Case rather than an Interrupt Vector.
        // TODO: Consider using an Interrupt Vector in the future.
        // Note: There is no need to "dismiss" or acknowledge the interrupts in our design here.
        //       Maybe the hardware simulation will grow to support/require that in the future.
       // switch (irq) {
      //  case TIMER_IRQ:
      //  this.krnTimerISR();              // Kernel built-in routine for timers (not the clock).
      //  break;
      //  case KEYBOARD_IRQ:
     //   _krnKeyboardDriver.isr(params);   // Kernel mode device driver
    //    _StdIn.handleInput();
    //    break;
    //    default:
    //    this.krnTrapError("Invalid Interrupt Request. irq=" + irq + " params=[" + params + "]");
     //   }
        }
        
        func krnTimerISR() {
        // The built-in TIMER (not clock) Interrupt Service Routine (as opposed to an ISR coming from a device driver). {
        // Check multiprogramming parameters and enforce quanta here. Call the scheduler / context switch here if necessary.
        }
        
        //
        // System Calls... that generate software interrupts via tha Application Programming Interface library routines.
        //
        // Some ideas:
        // - ReadConsole
        // - WriteConsole
        // - CreateProcess
        // - ExitProcess
        // - WaitForProcessToExit
        // - CreateFile
        // - OpenFile
        // - ReadFile
        // - WriteFile
        // - CloseFile
        
        
        //
        // OS Utility Routines
        //
        func krnTrace(msg2: String) {
        // Check globals to see if trace is set ON.  If so, then (maybe) log the message.
        if (_Trace) {
        if (msg2 == "Idle") {
        // We can't log every idle clock pulse because it would lag the browser very quickly.
        if (_OSclock % 10 == 0) {
        // Check the CPU_CLOCK_INTERVAL in globals.ts for an
        // idea of the tick rate and adjust this line accordingly.
            _Control.hostLog(msg2, source: "OS");
        }
        } else {
            _Control.hostLog(msg2, source: "OS");
      }
       }
        }
        
        func krnTrapError(msg:String) {
     //   Control.hostLog("OS ERROR - TRAP: " + msg);
        // TODO: Display error on console, perhaps in some sort of colored screen. (Perhaps blue?)
     //   krnShutdown();
        //make that blue screen son!
     //   var c = document.getElementById("bsod");
    //    _DrawingContext.drawImage(c, 0,0,500,500);
        }
    }
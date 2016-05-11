//
//  DeviceDriver.swift
//  XcodeOS
//
//  Created by Marist User on 3/3/16.
//  Copyright © 2016 Marist User. All rights reserved.
//

/* ------------------------------
DeviceDriver.ts
The "base class" for all Device Drivers.
------------------------------ */

    class DeviceDriver {
        var version = "0.07";
        var status = "unloaded";
        var preemptable = false;
        var driverEntry = "";
        var isr = "";
        
        init(driverEntry:String = "", isr:String = "")
        {
            self.driverEntry = driverEntry;
            self.isr = isr;
        
        }
    }

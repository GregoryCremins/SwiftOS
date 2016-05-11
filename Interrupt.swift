//
//  Interrupt.swift
//  XcodeOS
//
//  Created by Marist User on 4/14/16.
//  Copyright © 2016 Marist User. All rights reserved.
//

import Foundation

/* ------------
Interrupt.ts
------------ */

    class Interrupt {
        var irq: String;
        var params: [String];
        init(irq:String, params:[String]) {
            self.irq = irq;
            self.params = params;
        
        }
}

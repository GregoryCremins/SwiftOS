//
//  shellCommand.swift
//  XcodeOS
//
//  Created by Marist User on 4/24/16.
//  Copyright © 2016 Marist User. All rights reserved.
//

import Foundation


class ShellCommand {
    var command: String;
    var function: ([String])->String;
    var description: String;
        init (function: ([String]) -> String,command: String,description: String) {
            self.command = command;
            self.function = function;
            self.description = description;
        
        }
    }

//
//  userCommand.swift
//  XcodeOS
//
//  Created by Marist User on 4/26/16.
//  Copyright © 2016 Marist User. All rights reserved.
//

import Foundation


    class UserCommand {
        var command:String;
        var args: [String]
        init(command2:String = "", args2:[String] = []) {
            command = command2;
            args = args2;
        
        }
    }

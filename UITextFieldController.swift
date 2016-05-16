//
//  UITextFieldController.swift
//  XCodeOS3
//
//  Created by Marist User on 5/16/16.
//  Copyright © 2016 Marist User. All rights reserved.
//

import Foundation
import Cocoa

class UITextFieldController: NSTextField
{
    var isShifted = false;
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect);
        self.stringValue = "AHSD";
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder);
        self.stringValue = ">";
    }
    
    override func textDidBeginEditing(notification: NSNotification) {
        super.textDidBeginEditing(notification);
        _RootController.editUIField = true;
    }
    
    override func textDidEndEditing(notification: NSNotification) {
        super.textDidEndEditing(notification);
        _RootController.editUIField = false;
    }

}
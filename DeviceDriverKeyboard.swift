//
//  DeviceDriverKeyboard.swift
//  XCodeOS3
//
//  Created by Marist User on 5/7/16.
//  Copyright © 2016 Marist User. All rights reserved.
//

import Foundation

///<reference path="deviceDriver.ts" />

/* ----------------------------------
DeviceDriverKeyboard.ts

Requires deviceDriver.ts

The Kernel Keyboard Device Driver.
---------------------------------- */

    
    // Extends DeviceDriver
class DeviceDriverKeyboard : DeviceDriver {
        
        init() {
            // Override the base method pointers.
            super.init(driverEntry: "keyboard", isr: "KeyboardEvent");
        }
        
        func krnKbdDriverEntry() {
            // Initialization routine for this, the kernel-mode Keyboard Device Driver.
            self.status = "loaded";
            // More?
        }
    
    func krnKbdDispatchKeyPress(params:[String]) {
            // Parse the params.    TODO: Check that they are valid and osTrapError if not.
            let keyCodeStr = params[0];
        let keyCode = Int(keyCodeStr)!;
            let isShiftedStr  = params[1];
        let isShifted = isShiftedStr == "true";
            _Kernel.krnTrace("Key code:" + keyCodeStr + " shifted:" + isShiftedStr);
            var chr = "";
            // Check to see if we even want to deal with the key that was pressed.
            //first check if it was backspace or tab
            if(keyCode == 126)
            {
                _KernelInputQueue.enqueue("upArrow");
            }
            if(keyCode == 125)
            {
                _KernelInputQueue.enqueue("downArrow");
            }
        //backspace
            if(keyCode == 51)
            {
                //chr = String.fromCharCode(keyCode);
                chr = String(UnicodeScalar(8))
                _KernelInputQueue.enqueue(chr);
        
            }
             //tab
                if(keyCode == 48)
            {
                //chr = String.fromCharCode(keyCode);
                chr = String(UnicodeScalar(9))
                _KernelInputQueue.enqueue(chr);
            }
           // if (((keyCode >= 65) && (keyCode <= 90)) ||   // A..Z
            //    ((keyCode >= 97) && (keyCode <= 123))){  // a..z
        if(((keyCode >= 0) && (keyCode <= 9)) || ((keyCode >= 11) && (keyCode <= 17)) ||  ((keyCode >= 31) && (keyCode <= 32)) || ((keyCode >= 34) && (keyCode <= 35)) || ((keyCode >= 37) && (keyCode <= 38)) || (keyCode == 40) || keyCode == 46 || keyCode == 45)
        {
            var correctCode = 0;
            switch(keyCode)
            {
                //a
            case 0:
                correctCode = 65;
            case 11:
                correctCode = 66;
            case 8:
                correctCode = 67;
            case 2:
                correctCode = 68;
            case 14:
                correctCode = 69;
            case 3:
                correctCode = 70;
            case 5:
                correctCode = 71;
            case 4:
                correctCode = 72;
            case 34:
                correctCode = 73;
            case 38:
                correctCode = 74;
            case 40:
                correctCode = 75;
            case 37:
                correctCode = 76;
            case 46:
                correctCode = 77;
            case 45:
                correctCode = 78;
            case 31:
                correctCode = 79;
            case 35:
                correctCode = 80;
            case 12:
                correctCode = 81;
            case 15:
                correctCode = 82;
            case 1:
                correctCode = 83;
            case 17:
                correctCode = 84;
            case 32:
                correctCode = 85;
            case 9:
                correctCode = 86;
            case 13:
                correctCode = 87;
            case 7:
                correctCode = 88;
            case 16:
                correctCode = 89;
            case 6:
                correctCode = 90;
            default:
                //return nothing
                break;
            }
                    // Determine the character we want to display.
                    // Assume it's lowercase...
            correctCode = correctCode + 32;
                   // chr = String.fromCharCode(keyCode + 32);
                    //chr = String(UnicodeScalar(keyCode + 32));
                    // ... then check the shift key and re-adjust if necessary.
                   // if (isShifted) {
                        //chr = String.fromCharCode(keyCode);
                     //   chr = String(UnicodeScalar(keyCode));
           // print(chr);
           // print(keyCode);
                  //  }
                    // TODO: Check for caps-lock and handle as shifted if so.
            if(_RootController.isShifted)
            {
                correctCode = correctCode - 32;
            }
                    _KernelInputQueue.enqueue(String(UnicodeScalar(correctCode)));
            } else
            if (((keyCode >= 18) && (keyCode <= 29)) ||   // digits
                (keyCode == 49)                     ||   // space
                (keyCode == 36)) {                       // enter
                    var correctCode = 0;
                    if(isShifted && ((keyCode >= 48) && (keyCode <= 57)))
                    {
                        
                       switch(keyCode)
                        {
                      
                        case 29:
                            // close parenthesis
                            correctCode = 41;
                            break;
                        case 18:
                            // exclamation point
                            correctCode = 33;
                            break;
                        case 19:
                            // at symbol
                            correctCode = 64;
                            break;
                        case 20:
                            //hashtag
                            correctCode = 35;
                            break;
                        case 21:
                            //dolla dolla bill yall
                            correctCode = 36;
                            break;
                        case 23:
                            //percent
                            correctCode = 37;
                            break;
                        case 22:
                            //hat
                            correctCode = 94;
                            break;
                        case 26:
                            //and symbol
                            correctCode = 38;
                            break;
                        case 28:
                            //star
                            correctCode = 42;
                            break;
                        case 25:
                            //open parenthesis
                            correctCode = 40;
                            break;
                        default:
                            //keyCode = keyCode;
                            break
                            
                        }
                    }
                    else
                    {
                        switch(keyCode)
                        {
                        case 29:
                            // 0
                            correctCode = 48;
                            break;
                        case 18:
                            // 1
                            correctCode = 49;
                            break;
                        case 19:
                            // 2
                            correctCode = 50;
                            break;
                        case 20:
                            //3
                            correctCode = 51;
                            break;
                        case 21:
                            //4
                            correctCode = 52;
                            break;
                        case 23:
                            //5
                            correctCode = 53;
                            break;
                        case 22:
                            //6
                            correctCode = 54;
                            break;
                        case 26:
                            //7
                            correctCode = 55;
                            break;
                        case 28:
                            //8
                            correctCode = 56;
                            break;
                        case 25:
                            //9
                            correctCode = 57;
                            break;
                        default:
                            //keyCode = keyCode;
                            break
                        }
                    }
                    if(keyCode == 49)
                    {
                        correctCode = 32;
                    }
                    if(keyCode == 36)
                    {
                        correctCode = 13;
                    }
                    //chr = String.fromCharCode(keyCode);
                    chr = String(UnicodeScalar(correctCode));
                    _KernelInputQueue.enqueue(chr);
            }
            else
            {
                var correctCode = 0;
                //handle all punctuation marks
                var foundPunctMark = false;
                if(keyCode == 47 && !foundPunctMark) //period
                {
                    correctCode = 46;
                    if(isShifted)
                    {
                        correctCode = 62;
                    }
                    foundPunctMark = true;
                    //chr = String.fromCharCode(keyCode);
                    chr = String(UnicodeScalar(correctCode));
                    _KernelInputQueue.enqueue(chr);
                }
                if(keyCode == 43 && !foundPunctMark) //comma
                {
                    correctCode = 44;
                    if(isShifted)
                    {
                        correctCode = 60;
                    }
                    foundPunctMark = true;
                   // chr = String.fromCharCode(keyCode);
                    chr = String(UnicodeScalar(correctCode));
                    _KernelInputQueue.enqueue(chr);
                }
                if(keyCode == 44 && !foundPunctMark) //forward slash
                {
                    correctCode = 191;
                    if(isShifted)
                    {
                        correctCode = 63;
                    }
                    foundPunctMark = true;
                    //chr = String.fromCharCode(keyCode);
                    chr = String(UnicodeScalar(correctCode));
                    _KernelInputQueue.enqueue(chr);
                }
                if(keyCode == 41 && !foundPunctMark) //semicolon
                {
                    correctCode = 59;
                    if(isShifted)
                    {
                        correctCode = 58;
                    }
                    foundPunctMark = true;
                    //chr = String.fromCharCode(keyCode);
                    chr = String(UnicodeScalar(correctCode));
                    _KernelInputQueue.enqueue(chr);
                }
                if(keyCode == 39 && !foundPunctMark) //apostrophe
                {
                    correctCode = 39;
                    if(isShifted)
                    {
                        correctCode = 34;
                    }
                    foundPunctMark = true;
                   //chr = String.fromCharCode(keyCode);
                    chr = String(UnicodeScalar(correctCode));
                    _KernelInputQueue.enqueue(chr);
                }
                if(keyCode == 33 && !foundPunctMark) //open bracket
                {
                    correctCode = 91;
                    if(isShifted)
                    {
                        correctCode = 123;
                    }
                    foundPunctMark = true;
                    //chr = String.fromCharCode(keyCode);
                    chr = String(UnicodeScalar(correctCode));
                    _KernelInputQueue.enqueue(chr);
                }
                if(keyCode == 30 && !foundPunctMark) //close bracket
                {
                    correctCode = 93;
                    if(isShifted)
                    {
                        correctCode = 125;
                    }
                    foundPunctMark = true;
                    //chr = String.fromCharCode(keyCode);
                    chr = String(UnicodeScalar(correctCode));
                    _KernelInputQueue.enqueue(chr);
                }
                if(keyCode == 42 && !foundPunctMark) //backslash
                {
                    correctCode = 92;
                    if(isShifted)
                    {
                        correctCode = 124;
                    }
                    foundPunctMark = true;
                    //chr = String.fromCharCode(keyCode);
                    chr = String(UnicodeScalar(correctCode));
                    _KernelInputQueue.enqueue(chr);
                }
                if(keyCode == 27 && !foundPunctMark) //dash
                {
                    correctCode = 45;
                    if(isShifted)
                    {
                        correctCode = 95;
                    }
                    foundPunctMark = true;
                   // chr = String.fromCharCode(keyCode);
                   chr = String(UnicodeScalar(correctCode));
                    _KernelInputQueue.enqueue(chr);
                }
                if(keyCode == 24 && !foundPunctMark) //equals sign
                {
                    correctCode = 61;
                    if(isShifted)
                    {
                        correctCode = 43;
                    }
                    foundPunctMark = true;
                   // chr = String.fromCharCode(keyCode);
                    chr = String(UnicodeScalar(correctCode));
                    _KernelInputQueue.enqueue(chr);
                }
                if(keyCode == 50 && !foundPunctMark) //tilda a.k.a. tildashmerde
                {
                    correctCode = 96;
                    if(isShifted)
                    {
                        correctCode = 126;
                    }
                    foundPunctMark = true;
                    //chr = String.fromCharCode(keyCode);
                    chr = String(UnicodeScalar(correctCode));
                    _KernelInputQueue.enqueue(chr) ;
                }
                
                
            }
        }
    }

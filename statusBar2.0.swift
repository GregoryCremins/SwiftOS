//
//  statusBar2.0.swift
//  XcodeOS
//
//  Created by Marist User on 4/24/16.
//  Copyright © 2016 Marist User. All rights reserved.
//

import Foundation


        //status bar class
        class statusBarHander {
            //the current date and time
            
            var currentDate = NSDate();
            //the line which will be printed
            var line = "";
            //the current time as a string
            var curTime = "";
            init()
            {
            //CanvasTextFunctions.enable(_StatusContext);
            }
            
            //function to return the day and time as a string
            func showDate() -> String
            {
                
                let formatter = NSDateFormatter();
                formatter.dateStyle = .FullStyle;
                formatter.dateFormat = "EEE, dd/MM/yyyy hh:mm:ss zzz"
                let timeString = formatter.stringFromDate(currentDate);
                //print(timeString);
                return timeString;
                
            }
            //function to render the new status and date on the canvas
            func renderStatus()
            {
            self.line = self.showDate() + ". Status: " + STATUS;
            //_StatusContext.drawText( _DefaultFontFamily, _DefaultFontSize, 0, _FontHeightMargin + _DefaultFontSize , this.line);
            _RootController.getStatusView().string = self.line
            }
            
            //function to update the status and render it
            func updateStatus(newStatus:String)
            {
            
            currentDate = NSDate();
            let testTime = showDate();
            //set the time
            curTime = testTime;
           // currentDate = curDate;
            
            //if the status has changed, update it
            if(STATUS != newStatus)
            {
            STATUS = newStatus;
            
            }
            //clear and render status
            self.clearStatusBar();
            self.renderStatus();
            
            }
            //function to clear the status bar
            func clearStatusBar(){
            //_StatusContext.clearRect(0,0,1000, 500);
                _RootController.getStatusView().string = "";
            }
            
        }

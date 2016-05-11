//
//  console.swift
//  XCodeOS3
//
//  Created by Marist User on 5/4/16.
//  Copyright © 2016 Marist User. All rights reserved.
//

import Foundation

///<reference path="../globals.ts" />

/* ------------
Console.ts

Requires globals.ts

The OS Console - stdIn and stdOut by default.
Note: This is not the Shell.  The Shell is the "command line interface" (CLI) or interpreter for this console.
------------ */


    
    class Console {
        
        var buffer :String;
        var history = ["help"];
        var historyIndex: Int;
        //init(public currentFont = _DefaultFontFamily,
        //var currentFontSize = _DefaultFontSize,
        //var currentXPosition = 0,
        //var currentYPosition = _DefaultFontSize,
       // var buffer = "",
       // func history = [shellCommand](),
     //   public historyIndex = history.length) {
        
      //  }
        
        init(buffer:String = "", history:[String] = [String](), historyIndex: Int = 0)
        {
            self.buffer = buffer;
            self.history = history;
            self.historyIndex = historyIndex;
        }
        
       func initConsole(){
        self.clearScreen();
        //self.resetXY();
        }
        
       func  clearScreen(){
       // _DrawingContext.clearRect(0, 0, _Canvas.width, _Canvas.height);
       
        
//        func resetXY() {
//        self.currentXPosition = 0;
//        self.currentYPosition = this.currentFontSize;
        }
        
        func handleInput(){
        while (_KernelInputQueue.getSize() > 0) {
            
//        // Get the next character from the kernel input queue.
        let chr = _KernelInputQueue.dequeue()!;
//        // Check to see if it's "special" (enter or ctrl-c) or "normal" (anything else that the keyboard device driver gave us).
       // if (chr === String.fromCharCode(36))
           // print(chr);
            if(chr == String(UnicodeScalar(13)))
            {
        //     Enter key
//        // The enter key marks the end of a console command, so ...
//        // ... tell the shell ...
        self.history.append(self.buffer);
        self.historyIndex = self.history.count;
        
        _OSShell.handleInput(self.buffer);
        // ... and reset our buffer.
         self.buffer = "";
        }
        
            
            else {
                if (chr == String(UnicodeScalar(8)) )
            { //backspace
        if(self.buffer.characters.count > 0)
        {
        //var removeChar = self.buffer.charAt(self.buffer.length - 1);
        let removeChar = self.buffer[self.buffer.endIndex.predecessor()]
                print("Backspace");
        self.backSpace(String(removeChar));
        self.buffer = self.buffer.substringWithRange(Range<String.Index>(start: self.buffer.startIndex, end: self.buffer.endIndex.predecessor()));
//        
//        //this.buffer += "J";
                }
        }
        else {
//        //tab command to autocomplete a line
        if(chr == String(UnicodeScalar(9))){ //
        let currentBuffer = self.buffer;
        var returnBuffer = "";
        var foundMatch = false;
        var currentCommands = ["ver","help","shutdown","cls","man","trace","load","rot13","prompt","status","datetime","whereami","travel","lose","clearmem","kill","quantum","runall","ps", "setSchedule"];
//        //there is no contains function. ARRRGH!
//        //check list of current commands
        for  k  in 0 ... currentCommands.count {
        if ((self.inOrderContains(currentBuffer, largeText: currentCommands[k]))) {
        returnBuffer += currentCommands[k];
        returnBuffer += " ";
        foundMatch = true;
            }
        }
        
        if(foundMatch)
        {
        self.replaceBuffer(returnBuffer);
        }
        }
        else {
        if(chr == "upArrow"){//upArrow
        if(self.historyIndex >  0)
        {
            let historyCommand = self.history[self.historyIndex - 1];
        self.replaceBuffer(historyCommand);
        self.historyIndex = self.historyIndex - 1;
        }
        }
        else {
        if(chr == "downArrow")
        {
        if(self.historyIndex < self.history.count - 1)
        {
        let historyCommand = self.history[self.historyIndex + 1]
        self.replaceBuffer(historyCommand);
        self.historyIndex = self.historyIndex + 1;
        }
        }
        else {
//        
//        
//        // This is a "normal" character, so ...
//        // ... draw it on the screen...
        self.putText(chr);
//        // ... and add it to our buffer.
        self.buffer += chr;
        }
        }
        }
        }
        }
//        // TODO: Write a case for Ctrl-C.
        }
        }
        
            func putText(text: String){
//        // My first inclination here was to write two functions: putChar() and putString().
//        // Then I remembered that JavaScript is (sadly) untyped and it won't differentiate
//        // between the two.  So rather than be like PHP and write two (or more) functions that
//        // do the same thing, thereby encouraging confusion and decreasing readability, I
//        // decided to w;rite one function and use the term "text" to connote string or char.
//        // UPDATE: Even though we are now working in TypeScript, char and string remain undistinguished.
//        //THIS IS THE AMAZING LINE WRAPPING
//        if(text.length > 1)
//        {
//        for(var i = 0; i < text.length; i++)
//        {
//        this.putText(text.charAt(i));
//        }
//        }
//        else {
//        if (text !== "") {
//        // Draw the text at the current X and Y coordinates.
//        var offset = _DrawingContext.measureText(this.currentFont, this.currentFontSize, text);
//        if((this.currentXPosition + offset) > _DrawingContext.canvas.width)
//        {
//        this.advanceLine();
//        }
//        _DrawingContext.drawText(this.currentFont, this.currentFontSize, this.currentXPosition, this.currentYPosition, text);
//        // Move the current X position.
//        this.currentXPosition = this.currentXPosition + offset;
//        }
//        }
//        }
//        public advanceLine(): void {
//        this.currentXPosition = 0;
//        //the scrolling of destiny
//        if((this.currentYPosition + _DefaultFontSize + _FontHeightMargin) < _DrawingContext.canvas.height) {
//        this.currentYPosition += _DefaultFontSize + _FontHeightMargin;
//        }
//        else
//        {
//        this.scrollUp();
//        }
//        // TODO: Handle scrolling. (Project 1)
//        //size of buffer is 29
        }
                func backSpace(text:String){
//        var charLength = _DrawingContext.measureText(this.currentFont, this.currentFontSize, text);
//        var yHeight = _DefaultFontSize + _FontHeightMargin;
//        _DrawingContext.clearRect(this.currentXPosition - charLength - 1, ((this.currentYPosition - yHeight) + 2), charLength + 2, yHeight + 5);
//        if(this.currentXPosition > 0)
//        {
//        this.currentXPosition = this.currentXPosition - charLength;
//        }
//        else {
//        this.currentXPosition = 0;
//        //check if there is more input
//        if (this.buffer.length > 0) {
//        this.currentYPosition = this.currentYPosition - (_DefaultFontSize + _FontHeightMargin);
//        var testCharLength = _DrawingContext.measureText(this.buffer);
//        alert(testCharLength);
//        this.currentXPosition = testCharLength % 500;
//        this.backSpace(text);
//        }
        }
//        
      
        //function to check if a smaller sting is contained within the larger string
        //because javascript no has contains method
        //stating at char 0
        func inOrderContains(smallText: String, largeText:String) -> Bool{
        var isStillMatching = true;
        if(smallText.characters.count >= largeText.characters.count)
        {
        return false;
        }
        else {
        for (var i = 0; i < smallText.characters.count; i++) {
        if (smallText[smallText.startIndex.advancedBy(i)] != largeText[largeText.startIndex.advancedBy(i)]) {
        isStillMatching = false;
        }
        }
        }
        return isStillMatching;
        }
        //function to replace the buffer on the screen and behind the scenes
        func replaceBuffer(text:String)
        {
        //first clear all characters
            var j = self.buffer.characters.count;
        while j > 0
        {
        let removeChar = self.buffer[self.buffer.startIndex.advancedBy(buffer.characters.count - 1)];
            let endIndex = self.buffer.endIndex.predecessor();
        self.buffer = self.buffer.substringWithRange(Range(start: self.buffer.startIndex, end:endIndex));
        self.backSpace(String(removeChar));
            j--;
        }
        //then add the new characters
        self.buffer = text;
        for(var j = 0; j < self.buffer.characters.count; j++)
        {
        self.putText(String(self.buffer[self.buffer.startIndex.advancedBy(j)]));
        }
        }
        //method to just scroll the screen
      //  func scrollUp()
//        {
//        var yOffset = _DefaultFontSize + _FontHeightMargin;
//        var image = _DrawingContext.getImageData(0, yOffset, _DrawingContext.canvas.width, _DrawingContext.canvas.height);
//        _DrawingContext.putImageData(image,0, 0);
//        _DrawingContext.clearRect(0, _DrawingContext.canvas.height - yOffset,_DrawingContext.canvas.width, _DrawingContext.canvas.height);
//        }
    }

//
//  RootViewController.swift
//  XCodeOS3
//
//  Created by Marist User on 5/4/16.
//  Copyright © 2016 Marist User. All rights reserved.
//

import Cocoa

class RootViewController: NSViewController {

    @IBOutlet weak var HostLogOutput: NSScrollView!
    @IBOutlet weak var StepButton: NSButton!
    @IBOutlet weak var ResetButton: NSButton!
    @IBOutlet weak var HaltButton: NSButton!
    @IBOutlet weak var StartButton: NSButton!
    @IBOutlet weak var GlobalView: NSView!
    //@IBOutlet weak var userInputField: NSTextFieldCell!
    @IBOutlet var HostLogOutputText: NSTextView!
    @IBOutlet weak var CPUField: NSTextField!
    @IBOutlet weak var memoryView: NSTableView!
    var isShifted = false;
    @IBOutlet weak var UserInputField: NSTextField!
    @IBOutlet var UserOutputField: NSTextView!
    @IBOutlet var StatusBarField: NSTextView!
    
    @IBOutlet var ReadyQueueView: NSTextView!
    @IBOutlet var PCBView: NSTextView!
    
    @IBOutlet weak var ProgramInput: NSTextField!
    
    var CPUClock = NSTimer()
    override func viewDidLoad() {
        
        NSEvent.addLocalMonitorForEventsMatchingMask(.KeyDownMask) { (aEvent) -> NSEvent! in
            self.keyDown(aEvent)
            return aEvent
        }
        NSEvent.addLocalMonitorForEventsMatchingMask(.FlagsChangedMask) { (theEvent) -> NSEvent! in
            self.flagsChanged(theEvent)
            return theEvent
        }
        
       
        memoryView.setDelegate(self);
        memoryView.setDataSource(self);
        
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func keyDown(theEvent:NSEvent) {
       // UserInputField.stringValue = "key = " + (theEvent.charactersIgnoringModifiers
       //     ?? "")
        //UserInputField.stringValue += "\ncharacter = " + (theEvent.characters ?? "")
       // UserInputField.stringValue += "\nmodifier = " + theEvent.modifierFlags.rawValue.description
        if(_OSStarted)
        {
        let targetString = String(theEvent.keyCode)
        //let targetString = String(theEvent.characters).utf8
        _krnKeyboardDriver.krnKbdDispatchKeyPress([targetString,String(isShifted).lowercaseString]);
            _Console.handleInput();
            isShifted = false;
         //   print(targetString);
        }
        
    }
    
    
    override func flagsChanged(theEvent: NSEvent) {
        switch theEvent.modifierFlags.intersect(.DeviceIndependentModifierFlagsMask) {
        case NSEventModifierFlags.ShiftKeyMask :
            isShifted = true;
        default: break
        }
    }
    override func awakeFromNib() {
       // print("View controller instance with view: \(self.view)")
        UserInputField.stringValue = ">";
        //HostLogOutputText.string = "HASDOOO";
        //HostLogOutput.setAccessibilityEdited(false);
         _Control = Control();
        _Control.hostInit(self);
    }
    
        
    
    func getUserOutput() -> NSTextView
    {
        return UserOutputField;
    }
    func getHostLogOutput() -> NSTextView
    {
        return HostLogOutputText;
    }
    func getUIField() -> NSTextField
    {
        return UserInputField;
    }
    func getMemoryView() -> NSTableView
    {
        return memoryView;
    }
    func getCPUView() -> NSTextField
    {
        return CPUField;
    }
    func getStepButton() ->NSButton{
        return StepButton;
    }
    func getResetButton() ->NSButton{
        return ResetButton;
    }
    func getHaltButton() ->NSButton{
        return HaltButton;
    }
    func getStartButton() ->NSButton{
        
        return StartButton;
    }
    func getStatusView()-> NSTextView
    {
    return StatusBarField;
    }
    func getPCBView() -> NSTextView
    {
        return PCBView;
    }
    func getReadyQueueView() ->NSTextView
    {
        return ReadyQueueView;
    }
    func getProgramInputView() ->NSTextField
    {
        return ProgramInput;
    }
    
  
    @IBAction func StepButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func ResetButtonPressed(sender: AnyObject) {
        HaltButton.enabled = true;
        ResetButton.enabled = true;
        StartButton.enabled = true;
        
    }
    
    @IBAction func HaltButtonPressed(sender: AnyObject) {
        HaltButton.enabled = false;
        ResetButton.enabled = true;
        StartButton.enabled = false;
        
    }
    
    @IBAction func StartButtonPress(sender: AnyObject)
    {
        CPUClock = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "hostClockPulse", userInfo: nil, repeats: true)
        _Control.hostBtnStartOS_click();
        HaltButton.enabled = true;
        ResetButton.enabled = true;
        StartButton.enabled = false;
    }
    
    func hostClockPulse()
    {
        _Devices.hostClockPulse();
    }
    
    
    func textField(textField: NSTextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.stringValue.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 25
    }
    
    
}
extension RootViewController : NSTableViewDataSource {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return _DisplayedMem.count / 16
    }
}
extension RootViewController : NSTableViewDelegate {
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        //print("DOING IT");
        var text:String = ""
        var cellIdentifier: String = ""
        
        // 1 get memory
       // let item = _DisplayedMem;
        
        // 2 if it is the first row, then its the label
        if tableColumn == tableView.tableColumns[0] {
            cellIdentifier = "cell0"
            switch(row)
            {
            case 10:
                text = "0x" + "A" + "0";
            case 11:
                text = "0x" + "B" + "0";
            case 12:
                text = "0x" + "C" + "0";
            case 13:
                text = "0x" + "D" + "0";
            case 14:
                text = "0x" + "E" + "0";
            case 15:
                text = "0x" + "F" + "0";

            default:
                text = "0x" + String(row) + "0";
                
            }
            
        } //otherwise fill in data
        else if tableColumn == tableView.tableColumns[1] {
            text = _DisplayedMem[(row * 16)];
            cellIdentifier = "cell1";
        }
        else if tableColumn == tableView.tableColumns[2] {
            text = _DisplayedMem[(row * 16) + 1];
            cellIdentifier = "cell2";
        }
        else if tableColumn == tableView.tableColumns[3] {
            text = _DisplayedMem[(row * 16) + 2];
            cellIdentifier = "cell3";
        }
        else if tableColumn == tableView.tableColumns[4] {
            text = _DisplayedMem[(row * 16) + 3];
            cellIdentifier = "cell4";
        }
        else if tableColumn == tableView.tableColumns[5] {
            text = _DisplayedMem[(row * 16) + 4];
            cellIdentifier = "cell5";
        }
        else if tableColumn == tableView.tableColumns[6] {
            text = _DisplayedMem[(row * 16) + 5];
            cellIdentifier = "cell6";
        }
        else if tableColumn == tableView.tableColumns[7] {
            text = _DisplayedMem[(row * 16) + 6];
            cellIdentifier = "cell7";
        }
        else if tableColumn == tableView.tableColumns[8] {
            text = _DisplayedMem[(row * 16) + 7];
            cellIdentifier = "cell8";
        }
        else if tableColumn == tableView.tableColumns[9] {
            text = _DisplayedMem[(row * 16) + 8];
            cellIdentifier = "cell9";
        }
        else if tableColumn == tableView.tableColumns[10] {
            text = _DisplayedMem[(row * 16) + 9];
            cellIdentifier = "cell10";
        }
        else if tableColumn == tableView.tableColumns[11] {
            text = _DisplayedMem[(row * 16) + 10];
            cellIdentifier = "cell11";
        }
        else if tableColumn == tableView.tableColumns[12] {
            text = _DisplayedMem[(row * 16) + 11];
            cellIdentifier = "cell12";
        }
        else if tableColumn == tableView.tableColumns[13] {
            text = _DisplayedMem[(row * 16) + 12];
            cellIdentifier = "cell13";
        }
        else if tableColumn == tableView.tableColumns[14] {
            text = _DisplayedMem[(row * 16) + 13];
            cellIdentifier = "cell14";
        }
        else if tableColumn == tableView.tableColumns[15] {
            text = _DisplayedMem[(row * 16) + 14];
            cellIdentifier = "cell15";
        }
        else if tableColumn == tableView.tableColumns[16] {
            text = _DisplayedMem[(row * 16) + 15];
            cellIdentifier = "cell16";
        }
        
        // 3
        if let cell = tableView.makeViewWithIdentifier(cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
}

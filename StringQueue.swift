//
//  StringQueue.swift
//  XCodeOS3
//
//  Created by Marist User on 5/10/16.
//  Copyright © 2016 Marist User. All rights reserved.
//

import Foundation


//
//  queue.swift
//  XcodeOS
//
//  Created by Marist User on 4/14/16.
//  Copyright © 2016 Marist User. All rights reserved.
//

import Foundation

/* ------------
Queue.ts

A simple Queue, which is really just a dressed-up JavaScript Array.
See the Javascript Array documentation at
https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array
Look at the push and shift methods, as they are the least obvious here.

------------ */


class StringQueue {
    var q = [String]();
    //typealias Element =PCB;
    init(q2: [String])
        
    {
        q = q2;
        
    }
    
    func getSize() -> Int
    {
        return q.count;
    }
    
    func isEmpty() -> Bool{
        return (q.count == 0);
    }
    
    func enqueue(element:String)
    {
        q.append(element);
    }
    
    func dequeue() -> String? {
        //var retVal = Element();
        if (q.count > 0) {
            let retVal =  q.first!;
            q.removeFirst();
            return retVal;
        }
        else
        {
            return nil;
        }
    }
    
    func toString() ->String {
        var retVal = "";
        for i in q
        {
            retVal += "[" + String(i) + "] ";
        }
        return retVal;
    }
    
//    func sortQueue()
//    {
//        //first store all of the pcb's to an array
//        var temp = [String]();
//        while(q.count > 0)
//        {
//            var target = dequeue()!;
//            temp.append(target);
//        }
//        
//        // alert(temp.length);
//        // then put them back in order
//        while(temp.count > 0)
//        {
//            var maxIndex = -1;
//            var maxVal = -1;
//            for j in 0 ... temp.count
//            {
//                if(temp[j].getPriority() > maxVal)
//                {
//                    maxIndex = j;
//                    maxVal = temp[j].getPriority();
//                }
//            }
//            // q.append(temp[j])
//            //temp.removeAtIndex(j);
//            self.enqueue(temp[maxIndex])
//            //temp.splice(maxIndex, 1);
//            // temp.insert(, atIndex: maxIndex)
//            temp.removeAtIndex(maxIndex);
//        }
//    }
}
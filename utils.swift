
import Foundation;
    class Utils {
        
        func trim(str:String) -> String {
        // Use a regular expression to remove leading and trailing spaces.
        //return str.replace(/^\s+ | \s+$/g, "");
            let returnStr = str.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet());
            return returnStr;
        /*
        Huh? WTF? Okay... take a breath. Here we go:
        - The "|" separates this into two expressions, as in A or B.
        - "^\s+" matches a sequence of one or more whitespace characters at the beginning of a string.
        - "\s+$" is the same thing, but at the end of the string.
        - "g" makes is global, so we get all the whitespace.
        - "" is nothing, which is what we replace the whitespace with.
        */
        }
    
        func rot13(str: String) -> String {
        /*
        This is an easy-to understand implementation of the famous and common Rot13 obfuscator.
        You can do this in three lines with a complex regular expression, but I'd have
        trouble explaining it in the future.  There's a lot to be said for obvious code.
        */
        var retVal = "";
        var charArray = str.characters.map{String($0)}
            for i in 0...charArray.count {    // We need to cast the string to any for use in the for...in construct.
            let ch = String(charArray[i]);
        var code = 0;
            let validCharacters1 = "abcedfghijklmABCDEFGHIJKLM";
            let validCharacters2 = "nopqrstuvwxyzNOPQRSTUVWXYZ";
        if (validCharacters1.startIndex.distanceTo(validCharacters1.characters.indexOf(Character(ch))!) >= 0) {
        code = stringToCharCode(charArray[i]) + 13;  // It's okay to use 13.  It's not a magic number, it's called rot13.
         retVal = retVal + String(UnicodeScalar(code));
        } else if (validCharacters2.startIndex.distanceTo(validCharacters2.characters.indexOf(Character(ch))!) >= 0) {
    //    code = str.charCodeAt(i) - 13;  // It's okay to use 13.  See above.
            code = stringToCharCode(charArray[i]) - 13;
       retVal = retVal + String(UnicodeScalar(code));
        } else {
        retVal = retVal + ch;
        }
        }
        return retVal;
       }
        
        
        func stringToCharCode(str:String) -> Int
        {
            let characterString: String = str;
            var numbers: [Int] = Array<Int>()
            for character in characterString.utf8 {
                let stringSegment: String = "\(character)"
                let anInt: Int = Int(stringSegment)!
                numbers.append(anInt)
            }
            return numbers[0];
            
        }
    }

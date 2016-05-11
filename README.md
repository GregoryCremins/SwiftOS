# SwiftOS
The TSOS-2014 Project converted to Swift

The conversion process from Javascript to Swift took some time because Swift does not like null values. Nil is available but did not work in most cases.

Additionally keycodes in OSX make no sense, see here: http://macbiblioblog.blogspot.com/2014/12/key-codes-for-function-and-special-keys.html

So conversion had to be done to handle those in the keyboard driver.

But other than that is was a pretty fun project. Most of the functionality had an equivalent in Swift. 

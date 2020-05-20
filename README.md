# FlapLabel
Airport style display board components for Delphi Firemonkey. 
Simulates old mechanical flight information displays
(the ones with rolls of plates that change in sequence) 

FlapLabel was actually developed in 2002 for screens of 
São Paulo Airport (Congonhas)  flight information displays, 
in substitution to old mechanical displays from Solari.
It is still in use in that airport.

The original components were for VCL. This is port if for FMX

![screenshot](/Images/FlapLabelTestShot.png)

## Installation

* Compile and install FlapLabelPkg.dpk
* Components TFlapCharSet, TFlapChar and TFlapLabel will be installed

## Usage

* Add a TFlapCharSet to your form ( ex: FlapCharSet1 ) - Charset contains an image with the character set to be used by FlapLabels. Plates are not rendered as text. They are extracted from the charset image
* Set FlapCharSet properties
  * AirportCharset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.! :'  - These are the chars in the bitmap, for look up
  * CharsetBMP = a PNG image of the charset used by the display ( in this case a 240x250 image, shown below)
 
![Letters and numbers charset](/Images/LettersNumbersCharset.png)
  
  * RowCount = 5
  * ColCount = 8
  * FrameWidth = 30
  * FrameHeight = 50
  * FrameCount = 40
 
Other charsets:

![sample charset](/Images/ArrowsCharset.png)
![Numbers charset](/Images/NumbersCharset.png)
 
* Add a TFlapLabel component to the Form (ex: FlapLabel1) 
* Set FlapLabel1.CharSet property to FlapCharSet1
* Set FlapLabel1.Caption to 'TEST'  (case sensitive)

Text should flap until final state is reached. 

To change FlapLabel text at run time, just change the FlapLabel1.Caption

Have fun..


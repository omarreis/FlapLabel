# FlapLabel
Airport style display board components for Delphi Firemonkey. 
Simulates old mechanical flight information displays
(the ones with rolls of plates that change in sequence) 

FlapLabel was actually developed in 2002 for screens of 
São Paulo Airport (Congonhas)  flight information displays, 
in substitution to old mechanical displays from Solari.
It is still in use in that airport.

The original components where for VCL. This is a port to FMX.

![FlapLabel screen shot][https://github.com/omarreis/FlapLabel/blob/master/Images/FlapLabelTestShot.png?raw=true]

## Installation

* Compile and install FlapLabelPkg.dpk
* Components TFlapCharSet, TFlapChar and TFlapLabel will be installed

## Usage

* Add a TFlapCharSet to your form ( ex: FlapCharSet1 ) 
* Set FlapCharSet properties
  * AirportCharset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.! :'
  * CharsetBMP = a png image of the charset used by the display ( in this case a 240x250 image, shown below)
 
![Letters and numbers charset][Images/LettersNumbersCharset.png]
  
  * RowCount = 5
  * ColCount = 8
  * FrameWidth = 30
  * FrameHeight = 50
  * FrameCount = 40
* Add a TFlapLabel component to the Form (ex: FlapLabel1) 
* Set FlapLabel1.CharSet property to FlapCharSet1
* Set FlapLabel1.Caption to 'TEST'  (case sensitive)


![sample charset][https://github.com/omarreis/FlapLabel/blob/master/Images/ArrowsCharset.png]
![Numbers charset][https://github.com/omarreis/FlapLabel/blob/master/Images/NumbersCharset.png]

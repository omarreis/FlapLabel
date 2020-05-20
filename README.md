# FlapLabel
Airport style display components for Delphi Firemonkey. 
Simulates old mechanical flight information displays
(the ones with rolls of plates that change in sequence) 

FlapLabel was originaly developed in 2002 for actual 
flight screens for São Paulo Airport (Congonhas). 
We used plasma displays, expensive at the time, 
in substitution to even more expensive 
mechanical boards from Solari.
It is still in use in that airport.
The original components were for VCL. 

This is a port to Firemonkey and is tested
on Windows, iOS and Android w/ D10.3.3

![screenshot](/Images/FlapLabelTestShot.png)

## Installation

* Compile and install FlapLabelPkg.dpk
* Components TFlapCharSet, TFlapChar and TFlapLabel will be installed

## Usage

To use FlapLabels you need two components on your form: TFlapCharset and TFlapLabels.
The TFlapCharset contain the art to be used by FlapLabels. 
Depending on the application, you may use more than one charset: one with letters and one with just numbers.

Each FlapLabel uses one charset. One charset can be used by 
multiple FlapLabels. 

The default behaviour for a FlapLabel characters is to change
in sequence until the target character is reached.
But you can set the display to Go Direct, without showing all characters ( see example)

* Add a TFlapCharSet to your form ( ex: FlapCharSet1 ) - Charset contains an image with the character set to be used by FlapLabels. Plates are not rendered as text. They are extracted from the charset image, so you can add
symbols or icons to your charset (see below)

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

To change FlapLabel text at run time, just change FlapLabel1.Caption
Note that you can only use characters that are in your charset

## Example
Compile and run TesFlapLabel.dpr ( see screen shot )

Have fun..


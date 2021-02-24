# FlapLabel
Airport style display components for Delphi Firemonkey. 
Simulates old mechanical flight information boards
(the ones with rolls of plates that change in sequence,
making a satisfying flap-flap noise) 

FlapLabel was originaly developed in 2002 for actual 
flight information screens for São Paulo Airport (Congonhas). 
We used plasma displays, expensive at the time, 
in substitution to even more expensive 
mechanical boards from Solari, Italy.
The sw is still in use in that airport.
The original components were for VCL. 

This is a port to Firemonkey and is tested
on Windows, iOS and Android w/ D10.4.1

![screenshot](/Images/FlapLabelTestShot.png)

## Installation

* Compile and install FlapLabelPkg.dpk (design time package) 
* Components TFlapCharSet, TFlapChar and TFlapLabel will be installed 

## Usage

To use FlapLabels you need at least two components on your form: TFlapCharset and TFlapLabel.

The *TFlapCharset* contains the art to be used in FlapLabel plates. 
Depending on the application, you may use more than one charset: one with letters and one with just numbers.
Remember that all characters cycle until the desired is reached, 
so using long charsets is not recommended. 

Each *FlapLabel* uses one charset. One charset can be used by 
multiple FlapLabels. 

The default behaviour for FlapLabel characters is to change
in sequence until the target character is reached.
But you can set it to Go Direct (cheat), without going trhu all the characters (see example)

* Add a *TFlapCharSet* to your form ( ex: FlapCharSet1 ) - Charset contains an image with the character set to be used by FlapLabels. Plates are not rendered as text. They are extracted from the charset image, so you can add
symbols or icons to your charset (see below)

* Set FlapCharSet properties
  * AirportCharset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.! :'  - These are the chars in the bitmap, for look up
  * CharsetBMP = Load a PNG image with charset art (in this case a 240x250 image, shown below)
 
![Letters and numbers charset](/Images/LettersNumbersCharset.png).

Set charset layout.
  * RowCount = 5              
  * ColCount = 8

Set frame size in pixels.
  * FrameWidth = 30
  * FrameHeight = 50
  
Number of frames
  * FrameCount = 40
 
 
* Add a TFlapLabel component to the Form (ex: FlapLabel1) 
* Set FlapLabel1.CharSet property to FlapCharSet1
* Set FlapLabel1.CountFlaps  number of digits in the label
* Set FlapLabel1.Caption to 'TEST'  (case sensitive)

Label should flap from current state to 'TEST'. 

Sample charsets:

![sample charset](/Images/ArrowsCharset.png).
![Numbers charset](/Images/NumbersCharset.png).
![Airline logos](/Images/Airlines.png).


To change FlapLabel text at run time, just change FlapLabel1.Caption
Note that you can only use characters that are in your charset

## Example
Compile and run TestFlapLabel.dpr ( see screen shot )

## tiktok videos

* demo screen: https://www.tiktok.com/@omar_reis/video/6829300494842793222
* worst day on the Stock Market (app NassauSt): https://www.tiktok.com/@omar_reis/video/6802287150411877638
* AirlinerAttitude w/ FiremonkeySensorFusion and TFlapLabel: https://www.tiktok.com/@omar_reis/video/6846360497550380294  

Have fun..


# mcSchem-for-redstone
A program that generates towers of Redstone componants to encode numbers in Minecraft

## Functions
* three ways to encode data (in binary):
  * barrels
  * repeaters
  * levers
* for other bases (between 2 and 16) only barrels are available.
* you can choose how many numbers you want to encode at once, evvery towers will be separated by one block.
* you can encode numbers one by one or use the in-built function tool, see below for more details on it.
* the program supports only fixe point numbers, you can choose the format, or give a maximal size, and the program will compute the format in function of the maximal integer size.
* it only work for minecraft 1.21, the schems may not work for other versions.
* you need world edit for loading the schems and rotating them.

## Download
download the "mc schem generator" directory, and run launcher.bat, if you don't have a java 21 on your computer, it will download it for you and run the program.

## How to use :
* run launcher.bat
* a window will open
* answer the questions it will ask you in this window
* a file .schem has been created, copy paste this file in /config/worldedit/schematics
* run the command //schem load FILE_NAME.schem in minecraft and then //paste

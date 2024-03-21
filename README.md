# Josephson Junction IV Curve Tracer System


This is a system for measuring current-voltage(IV) curves of low critical current(10's of nanoamps) Josephson junctions in a dilution refrigerator.  This work is being carried out in the Superconductive electronics group in the Radio Frequency Division of the Communications Technology Laboratory at the National Institute of Standards and Technology, in Boulder, Colorado.  



The initial system is built for use on a Bluefors dilution refrigerator using the built in twisted pair wiring that ships with those instruments.  

The system consists of a programmable voltage source, a pair of volt meters, a pair of low noise voltage preamplifiers, coaxial cables, a room temperature box which switches the signals between different samples, a connecting that box to the dilution fridge, a bias board with a cold voltage divider and bias resistors, and a cold sample assembly with built in filtering.      

This documentation is intended to allow other researchers to replicate the entire set of components to make a turnkey system for taking IV curves of low critical current Josephson Junctions at dilution refrigerator temperatures.  We will be releasing python code in the form of Jupyter notebooks which will allow researchers to copy exactly our measurement protocol, increasing replicability in JJ IV curve measurements.

# Rack Mount Setup

![](https://raw.githubusercontent.com/lafefspietz/jjiv/main/images/rackmount-configuration.png)

Off the shelf components include:

  - Two [Stanford Research Systems SR560 low voltage pre amplifiers](https://www.thinksrs.com/products/sr560.htm)
  - One [Yokogawa GS200 DC Voltage / Current Source](https://tmi.yokogawa.com/us/solutions/products/generators-sources/source-measure-units/gs200/)
  - Two [Keithley 2010 digital multimeters](https://www.tek.com/en/products/keithley/digital-multimeter/2010-series)

The room temperature box which connects the BNC cables to the twisted pair wiring in the dilution refrigerator has DIN rail clips on the back of it so that it can be mounted on either  a DIN rail on the frame of the firdge or a DIN rail mounted in a rack mount as shown below:

![](https://raw.githubusercontent.com/lafefspietz/jjiv/main/images/rackmount-warm-box.png)   

The DIN rail to rack mount adapter is a product from 
   
# Punch-vest
A kevlar-vest simulation, that gives punches to Arma player's body according to the bullet hit area in the game. The vest is for immersion and orientation of attack.
simulation of the vest functions:  https://youtu.be/IvCtKeRD_oM

Codes run a punch-vest and/or produce ingame text info of bullet hits. Arma sqf code is in the form of init.sqf, it can also be pasted in console. The script is possibly being converted to a separate mod also. The Arduino sketch needs to be loaded in Arduino for the vest. Sqf script detects bullet hits to your body. Signal lasting 0.1 second is sent to a relay to open valve/trigger solenoid/produce electric shock or whatever you can imagine giving you punch. Depending on a caliber of the enemy weapon fired the signal is given 1 to 4 times in a row. Shooting with your own rifle produces light punch resembling recoil on your right shoulder. ARMA COM module by Fat_Lurch and GoogleBen is the engine needed behind this connection. Get it from Steam Arma workshop.

Here's the product: https://youtu.be/u1dDI9aU8OU?list=PLysuWIfOOnr6Smt1bUuGRWYQ9NM-PoumB


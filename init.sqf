//this can be inside a mod, run in debug console or be added in init/initPlayerLocal.sqf
 _activate = [player] spawn
 {
 
/*
	Peacebob - 2022-03-10
	
	This is a script for punchvest. 


*/

addMissionEventHandler ["ExtensionCallback", {
    params ["_name", "_function", "_data"];
    if ((_name isEqualTo "ArmaCOM") && (_function isEqualTo "data_read")) then 
    {
        _currentTime = systemTime;
        _formattedTime = format["%1:%2:%3.%4", _currentTime select 3, _currentTime select 4, _currentTime select 5, _currentTime select 6];
        systemChat (format ["Received message from serial port: %1 - %2", _data, _formattedTime]);
    };
}];

com = "COM4";	//##### change this to your appropriate com port #####

private _relX = 0; //laptop relative x on table
private _relY = 0; //laptop relative y on table
private _tablePos = player getRelPos [3, 0];
private _table = "Land_CampingTable_F" createVehicle [0,0,0];
laptop = "Land_Laptop_unfolded_F" createVehicle [0,0,0];
_table setPos _tablePos;
laptop setVehiclePosition [_tablePos vectorAdd [_relX, _relY, 1000], [], 0, "CAN_COLLIDE"];
laptop attachTo [_table];

laptop addAction ["List Ports", {systemChat str("Armacom" callExtension "listPorts")}];
laptop addAction ["Connect", {systemChat str("Armacom" callExtension ["connect", [com]])}];
laptop addAction ["LED On", {systemChat str("Armacom" callExtension ["write", [com, "On"]])}];
laptop addAction ["LED Off", {systemChat str("Armacom" callExtension ["write", [com, "Off"]])}];
laptop addAction ["Disconnect", {systemChat str("Armacom" callExtension ["disconnect", [com]])}];


isItBack = 0; 
publicVariable "isItBack"; 
caliber = "5.56";   
publicVariable "caliber";  
dummyStain = "Land_Decal_roads_oil_stain_01_F" createVehicle [0,0,0]; 
publicVariable "dummyStain";  
dummyStainPlayer = "Land_Decal_roads_oil_stain_01_F" createVehicle [0,100,0]; 
publicVariable "dummyStainPlayer"; 
// 
//adding Armacom variables 
headACPort = "1";//send number 1
publicVariable "headACPort";
chestACPort = "2";//send number 2 
publicVariable "chestACPort";
stomachACPort = "3";//send number 3 
publicVariable "stomachACPort";
backACPort = "4";//send number 4 
publicVariable "backACPort";
armLeftACPort = "5";//send number 5 
publicVariable "armLeftACPort";
armRightACPort = "6";//send number 6 
publicVariable "armRightACPort";
legLeftACPort = "7";//send number 7 
publicVariable "legLeftACPort";
legRightACPort = "8";//send number 8 
publicVariable "legRightACPort";
// 
//Punch function  
Pb_fnc_punch = 
{ 
params["_hit","_unit"]; 
if (1>0) then 
{ 
//defining connection between Arma hitpoints and Punch-vest punch points 
//converting Arma hit points to the vest's 8 punch points 
private _headAC = ["head", "neck"]; 
private _chestAC = ["spine3","spine2"]; 
private _stomachAC = ["spine1", "spine", "pelvis"]; 
private _armLeftAC = ["leftshoulder","lefttarm", "leftarmroll", "leftforearmroll", "leftforearm"]; 
private _armRightAC = ["rightshoulder","righttarm", "rightarmroll", "rightforearmroll", "rightforearm"]; 
private _legLeftAC = ["leftupleg", "leftleg", "leftuplegroll", "leftfoot"]; 
private _legRightAC = ["rightupleg", "rightleg", "rightuplegroll", "rightfoot"]; 
// 
//adding caliber groups chart(4 first letters of a caliber definition) 
//number in the array name correlates to the punch produced 
//here is all vanilla, RHS and CUP calibers presented 
//of course could use the Arma damage value but what's the fun? 
private _4heavy =[".50 ", "M33 ", "Mk21"]; 
private _4sniperMG =["7.92", "30-0", "9.3x", "9.3 ", ".338", ".408", ".303", ".300", "30-0", "12.7", "CZ-55", "CZ-75", "KSVK"]; 
private _3shotgun =["shot", "300 ", "12G ", "Shot", "00 B", "slug"]; 
private _3battleRifleLMG =["batt", "7.62", "6.5m", "6x5 ", "6.5x", "6.8 ", "7.5x","Batt"];//this one needs to be divided in battle rifle and sniper rifle classes according to the damage value, >10 = sniper rifle class 
private _2assaultRifle =["5.8m", "5.56", "5.45", "5.60", "5.7m"]; 
private _1handgunSMG =["SMG ", "14.5", "Hand", "Rail", "9mm ", "9x39", "9x21",".45 ", "0.40", "45 A", "9x19", "9x18", "0.38", "Well","5.60", "10mm",".357", ".40 ", "9x17"]; 
// 
punchVal = 1;//basic value of punch magnitude (1-4)
// 
//checking the caliber of the bullet, defining punch magnitude multiplier's value 
msgCal =  str caliber; 
publicVariable "msgCal"; 
_caliber =  caliber; 
_damageValue = damageValue; 
{if(_caliber == _x) then {punchVal = 4; 
msgGun = " heavy mg bullet hit" 
}}forEach _4heavy; 
{if(_caliber == _x) then {punchVal = 4; 
msgGun = " sniper rifle bullet hit" 
}}forEach _4sniperMG; 
{if(_caliber == _x) then {punchVal = 3; 
msgGun = " shotgun slug hit" 
}}forEach _3shotgun; 
{if((_caliber == _x)&&(_damageValue > 12)) then {punchVal = 4; 
msgGun = " sniper rifle bullet hit" 
}}forEach _3battleRifleLMG; 
{if((_caliber == _x)&&(_damageValue <= 12)) then {punchVal = 3; 
msgGun = " battle rifle or light mg bullet hit" 
}}forEach _3battleRifleLMG; 
{if(_caliber == _x) then {punchVal = 2; 
msgGun = " assault rifle bullet hit" 
}}forEach _2assaultRifle; 
{if(_caliber == _x) then {punchVal = 1; 
msgGun = " handgun or smg bullet hit" 
}}forEach _1handgunSMG;
publicVariable "msgGun"; 
// 
//writing hits to Arduino and info to display 
_counter = 0; 
while {_counter < punchVal} do 
{ 
_counter = _counter + 1; 
if (((isItBack) < 1) && ((_this select 0) in _armLeftAC)) exitWith { 
systemChat str("Armacom" callExtension ["write", [com, armLeftACPort]]);  
msgHit = " in left arm";isItBack = 0 
}; 
if (((isItBack) < 1) && ((_this select 0) in _armRightAC)) exitWith { 
systemChat str("Armacom" callExtension ["write", [com, armRightACPort]]); 
msgHit = " in right arm";isItBack = 0 
}; 
if (((isItBack) < 1) && ((_this select 0) in _legLeftAC)) exitWith { 
systemChat str("Armacom" callExtension ["write", [com, legLeftACPort]]);
msgHit = " in left leg";isItBack = 0 
}; 
if (((isItBack) < 1) && ((_this select 0) in _legRightAC)) exitWith { 
systemChat str("Armacom" callExtension ["write", [com, legRightACPort]]);
msgHit = " in right leg";isItBack = 0 
}; 
if (((isItBack) < 1) && ((_this select 0) in _headAC)) exitWith { 
systemChat str("Armacom" callExtension ["write", [com, "3"]]);
msgHit = " in neck";isItBack = 0 
}; 
if ((isItBack) > 0) exitWith { 
systemChat str("Armacom" callExtension ["write", [com, backACPort]]);
msgHit = " in back";isItBack = 0 
}; 
if (((isItBack) < 1) && ((_this select 0) in _chestAC)) exitWith { 
systemChat str("Armacom" callExtension ["write", [com, "2"]]);
msgHit = " in chest";isItBack = 0 
}; 
if (((isItBack) < 1)&&((_this select 0) in _stomachAC)) exitWith { 
systemChat str("Armacom" callExtension ["write", [com, stomachACPort]]);
msgHit = " in stomach";isItBack = 0 
}; 
if (((isItBack) < 1)&&((_this select 0) == "final")) exitWith { 
systemChat str("Armacom" callExtension ["write", [com, chestACPort]]);
msgHit = " final punch in front"; 
}; 
if (((isItBack) > 0)&&((_this select 0) == "final")) exitWith {
systemChat str("Armacom" callExtension ["write", [com, backACPort]]); 
msgHit = " final punch in back"; 
};
publicVariable msgHit; 
};   
msg = [msgCal, msgGun, msgHit] joinString ""; 
[[msg, 2, 1, 1], ["", 0, 0, 0]] spawn BIS_fnc_EXP_camp_SITREP;
[100] call BIS_fnc_bloodEffect; // Adds the //blood effect for 100 milliseconds 
};
}; 
//end of Punch function 
// 
//adding event handlers 
// 
//when player fires a weapon there is a hit to the right shoulder to resemble weapon recoil
player addEventHandler ["Fired", {
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
systemChat str("Armacom" callExtension ["write", [com, armLeftACPort]]); 
}];
// 
//the main event handler 'hitPart' has a lot of info, here used _target, _shooter and from _selection select 5, which tells the hit point 
// 
player addEventHandler ["HitPart", {params ["_unit", "_shooter", "_projectile", "_position", "_velocity", "_selection", "_ammo", "_vector", "_radius", "_surfaceType", "_isDirect"]; 
//the caliber of the bullet is ripped from the magazine's config 
currentMagazine (_this select 0 select 1) call  
{ 
 _str = getText (configFile >> "CfgMagazines" >> _this >> "descriptionShort"); 
 _arr = toArray _str; 
 _arr deleteRange [0,(_str find "Caliber: ") +9]; 
 _arr deleteRange [4,count _arr];//getting 4 characters which tell the caliber 
 _caliber = toString _arr; 
 caliber = _caliber; 
};   
//define 3 points for calculation, point behind player is closer to the shooter if shooter is behind player's line of advance 
_positionPlayer = getPos player; 
dummyStain setPos (_this select 1 modelToWorld [0,0,0]); 
_positionShooter = position dummyStain; 
publicVariable "dummyStain";
dummyStainPlayer setPos (player modelToWorld [0,-1,0]);
publicVariable "dummyStainPlayer";  
_behindPlayer = position dummyStainPlayer; 
//way to check whether the shooter is behind player 
if ((_positionPlayer distance _positionShooter) > (_behindPlayer distance _positionShooter)) then 
{isItBack = 1} else {isItBack = 0;};publicVariable "isItBack"; 
//calling punch function 
[(_this select 0 select 5 select 0), player] call Pb_fnc_punch;
}];//end of event handler 'Hitpart'
//
};
true;
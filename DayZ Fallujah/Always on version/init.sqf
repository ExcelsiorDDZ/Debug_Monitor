/*
	INITILIZATION
*/
startLoadingScreen ["","RscDisplayLoadCustom"];
cutText ["","BLACK OUT"];
enableSaving [false, false];

//REALLY IMPORTANT VALUES
dayZ_instance =	1;					//The instance
hiveInUse = true;
dayzHiveRequest = [];
initialized = false;
dayz_previousID = 0;

//disable greeting menu
player setVariable ["BIS_noCoreConversations", true];

//disable radio messages to be heard and shown in the left lower corner of the screen
enableRadio false;

//Load in compiled functions
//call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\variables.sqf";				//Initilize the Variables (IMPORTANT: Must happen very early)
call compile preprocessFileLineNumbers "debug\variables.sqf";				//Initilize the Variables (IMPORTANT: Must happen very early)
progressLoadingScreen 0.1;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\publicEH.sqf";
progressLoadingScreen 0.2;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\medical\setup_functions_med.sqf";
progressLoadingScreen 0.4;
//call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\compiles.sqf";				//Compile regular functions
call compile preprocessFileLineNumbers "debug\compiles.sqf";				//Compile regular functions
progressLoadingScreen 1.0;

// Set Tonemapping
"Filmic" setToneMappingParams [0.153, 0.357, 0.231, 0.1573, 0.011, 3.750, 6, 4];
setToneMapping "Filmic";

player_spawn_2 = compile preprocessFileLineNumbers "debug\player_spawn_2.sqf";

// Run the server monitor
if ((!isServer) && (isNull player) ) then
{
waitUntil {!isNull player};
waitUntil {time > 3};
};

if ((!isServer) && (player != player)) then
{
  waitUntil {player == player};
  waitUntil {time > 3};
};

if (isServer) then {
	_serverMonitor = 	[] execVM "\z\addons\dayz_code\system\server_monitor.sqf";
};

// Run the player monitor
if (!isDedicated) then {
	0 fadeSound 0;
	0 cutText [(localize "STR_AUTHENTICATING"), "BLACK FADED", 60];

	_id = player addEventHandler ["Respawn", { _id = [] spawn player_death; }];
	_playerMonitor = [] execVM "\z\addons\dayz_code\system\player_monitor.sqf";
};

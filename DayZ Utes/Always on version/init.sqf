// Mission Initialization
startLoadingScreen ["", "RscDisplayLoadCustom"];
cutText ["", "BLACK OUT"];
enableSaving [false, false];

// Variable Initialization
dayZ_instance = 1;
hiveInUse = true;
dayzHiveRequest = [];
initialized = false;
dayz_previousID = 0;

// Settings
player setVariable ["BIS_noCoreConversations", true]; 	// Disable greeting menu
//enableRadio false; 									// Disable global chat radio messages

// Compile and call important functions
//call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\variables.sqf";				//Initilize the Variables (IMPORTANT: Must happen very early)
call compile preprocessFileLineNumbers "debug\variables.sqf";				//Initilize the Variables (IMPORTANT: Must happen very early)
progressLoadingScreen 0.1;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\publicEH.sqf";				//Initilize the publicVariable event handlers
progressLoadingScreen 0.2;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\medical\setup_functions_med.sqf";	//Functions used by CLIENT for medical
progressLoadingScreen 0.4;
//call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\compiles.sqf";				//Compile regular functions
call compile preprocessFileLineNumbers "debug\compiles.sqf";				//Compile regular functions
progressLoadingScreen 1.0;

// Set Tonemapping
"Filmic" setToneMappingParams [0.153, 0.357, 0.231, 0.1573, 0.011, 3.750, 6, 4];
setToneMapping "Filmic";

player_spawn_2 = compile preprocessFileLineNumbers "debug\player_spawn_2.sqf";

// Run the server monitor
if (isServer) then {
	_serverMonitor = [] execVM "\z\addons\dayz_server\system\server_monitor.sqf";
};

if (!isServer && isNull player) then {
	waitUntil { !isNull player };
	waitUntil { time > 3 };
};

if (!isServer && player != player) then {
	waitUntil { player == player };
	waitUntil { time > 3 };
};

// Run the player monitor
if (!isDedicated) then {
	0 fadeSound 0;
	waitUntil { !isNil "dayz_loadScreenMsg" };
	dayz_loadScreenMsg = (localize "STR_AUTHENTICATING");

	_id = player addEventHandler ["Respawn", { _id = [] spawn player_death; }];
	_playerMonitor = [] execVM "\z\addons\dayz_code\system\player_monitor.sqf";
};

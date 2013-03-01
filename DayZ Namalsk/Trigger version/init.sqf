// Mission Initialization
startLoadingScreen ["", "DayZ_loadingScreen"];
cutText ["", "BLACK OUT"];
enableSaving [false, false];

// Variable Initialization
dayZ_instance = 1;
hiveInUse = true;
dayzHiveRequest = [];
initialized = false;
dayz_previousID = 0;

// Settings
dzn_ns_bloodsucker = true;								// Spawn bloodsuckers
dzn_ns_bloodsucker_den = 40;							// Spawn chance of bloodsuckers
ns_blowout = true;										// Spawn random EVR discharges
ns_blowout_dayz = true;
dayzNam_buildingLoot = "CfgBuildingLootNamalsk"; 		// CfgBuildingLootNamalskNOER7, CfgBuildingLootNamalskNOSniper, CfgBuildingLootNamalsk
player setVariable ["BIS_noCoreConversations", true]; 	// Disable greeting menu
//enableRadio false; 									// Disable global chat radio messages

call compile preprocessFileLineNumbers "\nst\ns_dayz\code\init\variables.sqf";
progressLoadingScreen 0.1;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\publicEH.sqf";
progressLoadingScreen 0.2;
call compile preprocessFileLineNumbers "\z\addons\dayz_code\medical\setup_functions_med.sqf";
progressLoadingScreen 0.4;
call compile preprocessFileLineNumbers "\nst\ns_dayz\code\init\compiles.sqf";
progressLoadingScreen 1.0;

// Set Tonemapping
"Filmic" setToneMappingParams [0.153, 0.357, 0.231, 0.1573, 0.011, 3.750, 6, 4];
setToneMapping "Filmic";

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
	if (isClass (configFile >> "CfgBuildingLootNamalsk")) then {
		0 fadeSound 0;
		0 cutText [(localize "STR_AUTHENTICATING"), "BLACK FADED", 60];

		_id = player addEventHandler ["Respawn", { _id = [] spawn player_death; }];
		_playerMonitor = [] execVM "\nst\ns_dayz\code\system\player_monitor.sqf";
};

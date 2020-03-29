
--[[
This lua is based on:
weapon.LUA by N!trox*
Website: www.etmods.net
eMail: admin@etmods.net
IRC: #nitmod @ freenode

Thanks for that!
Edited by Micha!
Edited by Bystry 30.03.2020 - ETL compatibility and added chat message.

Contact:
--------------------
http://www.teammuppet.eu
--]]


--[[---------------------------------------------------------------------------------
---------------------------------CONFIG START----------------------------------------
-------------------------------------------------------------------------------------

true means on
false means off

changeable values:
--]]

countspectators = false		--include spectators on the player counter		


unlockvalue = 20		--player amount needed to unlock the following weapon values (must be greater then 13)

panzer 		= 1		--weapon amount which will be unlocked if playeramount greater then unlockvalue
mines	 	= 6
flamer 		= 0
mortar 		= 0
mg42 		= 1
riflegnade 	= 2

message		= "^5There are 10 or more players on the server, heavy weapons, 1 rifle granade and 4 landmines are now ^1enabled^5!"
message2	= "^5There are less than 10 players on the server, heavy weapons, rifle grenades and landmines are now ^1disabled^5!"
message3	= "^5There are 16 or more players on the server, 2 rifle grenades and 5 landmines are now enabled!"
message4	= "^5There are 20 or more players on the server, 2 rifle grenades and 6 landmines are now enabled!"
location 	= "chat"

-------------------------------------------------------------------------------------
-------------------------------CONFIG END--------------------------------------------
-------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------
----------DO NOT CHANGE THE FOLLOWING IF YOU DO NOT KNOW WHAT YOU ARE DOING----------
-------------------------------------------------------------------------------------

-------//-----------------DO NOT CHANGE THESE VARS-----------------------------------
Version = "0.2"
Modname = "heavyweapon"

et.CS_PLAYERS = 689

function et_InitGame(levelTime,randomSeed,restart)
    et.G_Print("["..Modname.."] Version: "..Version.." Loaded")
    et.RegisterModname(Modname .. " " .. Version)
	maxClients = tonumber(et.trap_Cvar_Get("sv_maxclients")) - 1;
	numPlayingClientsBackup = 0;
end

function et_RunFrame(leveltime)
	local numPlayingClients = 0;
	for i=0, maxClients do
		if countspectators then
			if (tonumber(et.gentity_get(i, "sess.sessionTeam")) >= 1) and (tonumber(et.gentity_get(i, "sess.sessionTeam")) <= 3) then
				numPlayingClients = numPlayingClients + 1;
			end
		else
			if (tonumber(et.gentity_get(i, "sess.sessionTeam")) == 1) or (tonumber(et.gentity_get(i, "sess.sessionTeam")) == 2) then
				numPlayingClients = numPlayingClients + 1;
			end
		end
	end
	
	AdjustCvarsValues( numPlayingClients );
end


function AdjustCvarsValues( numclients )
	
	if(numPlayingClientsBackup == 0 and numclients == 0) then
		return;
	elseif (numPlayingClientsBackup == numclients) then
		return;
	end
	
	numPlayingClientsBackup = numclients;

	if (numclients < 8) and unlockvalue > 13 then
		for j = 0, maxClients do
			if (tonumber(et.gentity_get(j, "sess.sessionTeam")) == 1) and checkclass(j) == 0 then --Axis Soldier
				et.gentity_set(j,"sess.latchPlayerWeapon", 3)	--MP40
			elseif (tonumber(et.gentity_get(j, "sess.sessionTeam")) == 2) and checkclass(j) == 0 then --Allies Soldier
				et.gentity_set(j,"sess.latchPlayerWeapon", 8)	--Thompson
			end
			et.gentity_set(j, "ps.ammoclip", 5, 0) 		--WP_PANZERFAUST
			et.gentity_set(j, "ps.ammoclip", 6, 0) 		--WP_FLAMETHROWER
			et.gentity_set(j, "ps.ammo", 9, 0)		--WP_GRENADE_PINEAPPLE
			et.gentity_set(j, "ps.ammoclip", 9, 0)		--WP_GRENADE_PINEAPPLE
			et.gentity_set(j, "ps.ammoclip", 26, 0)		--WP_LANDMINE
			et.gentity_set(j, "ps.ammo", 31, 0) 		--WP_MOBILE_MG42
			et.gentity_set(j, "ps.ammoclip", 31, 0) 	--WP_MOBILE_MG42
			et.gentity_set(j, "ps.ammo", 35, 0)		--WP_MORTAR
			et.gentity_set(j, "ps.ammoclip", 35, 0)		--WP_MORTAR
		end
		et.trap_Cvar_Set("team_maxMachineguns", "0")
		et.trap_Cvar_Set("team_maxMortars", "0")
		et.trap_Cvar_Set("team_maxRifleGrenades", "0")
		et.trap_Cvar_Set("team_maxRockets", "0")
		et.trap_Cvar_Set("team_maxLandmines", "0")
		et.trap_Cvar_Set("g_maxTeamLandmines", "0")
		et.trap_Cvar_Set("team_maxFlamers", "0")
		et.trap_SendServerCommand(-1 , string.format('%s \"%s\"',location,message2 ))
	elseif (numclients >= 10 and numclients < 16) and unlockvalue > 13 then
		et.trap_Cvar_Set("team_maxMortars", "0")
		et.trap_Cvar_Set("team_maxMachineguns", "1")
		et.trap_Cvar_Set("team_maxRockets", "1")
		et.trap_Cvar_Set("team_maxRifleGrenades", "1")
		et.trap_Cvar_Set("team_maxLandmines", "4")
		et.trap_Cvar_Set("g_maxTeamLandmines", "4")
		et.trap_Cvar_Set("team_maxFlamers", "0")
		et.trap_SendServerCommand(-1 , string.format('%s \"%s\"',location,message ))
	elseif (numclients >= 16 and numclients < unlockvalue) and unlockvalue > 13 then
		et.trap_Cvar_Set("team_maxMortars", "0")
		et.trap_Cvar_Set("team_maxMachineguns", "1")
		et.trap_Cvar_Set("team_maxRockets", "1")
		et.trap_Cvar_Set("team_maxRifleGrenades", "2")
		et.trap_Cvar_Set("team_maxLandmines", "5")
		et.trap_Cvar_Set("g_maxTeamLandmines", "5")
		et.trap_Cvar_Set("team_maxFlamers", "0")
		et.trap_SendServerCommand(-1 , string.format('%s \"%s\"',location,message3 ))
	elseif (numclients >= unlockvalue) and unlockvalue > 13 then
		et.trap_Cvar_Set("team_maxMachineguns", mg42)
		et.trap_Cvar_Set("team_maxMortars", mortar)
		et.trap_Cvar_Set("team_maxRifleGrenades", riflegnade)
		et.trap_Cvar_Set("team_maxRockets", panzer)
		et.trap_Cvar_Set("team_maxLandmines", mines)
		et.trap_Cvar_Set("g_maxTeamLandmines", mines)
		et.trap_Cvar_Set("team_maxFlamers", flamer)
		et.trap_SendServerCommand(-1 , string.format('%s \"%s\"',location,message4 ))
	end

end

--0=Soldier, 1=Medic, 2=Engineer, 3=FieldOps, 4=CovertOps
function checkclass(client)
   local cs = et.trap_GetConfigstring(et.CS_PLAYERS + client)
    return tonumber(et.Info_ValueForKey(cs, "c"))
end

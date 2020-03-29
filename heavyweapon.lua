
--[[
This lua is based on:
weapon.LUA by N!trox*
Website: www.etmods.net
eMail: admin@etmods.net
IRC: #nitmod @ freenode

Thanks for that!
Edited by Micha!

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

panzer 		  = 1			--weapon amount which will be unlocked if playeramount greater then unlockvalue
mines	 	    = 8
flamer 		  = 1
mortar 		  = 2
mg42 		    = 1
riflegnade 	= 2

-------------------------------------------------------------------------------------
-------------------------------CONFIG END--------------------------------------------
-------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------
----------DO NOT CHANGE THE FOLLOWING IF YOU DO NOT KNOW WHAT YOU ARE DOING----------
-------------------------------------------------------------------------------------

-------//-----------------DO NOT CHANGE THESE VARS-----------------------------------
Version = "0.1"
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
			et.gentity_set(j, "ps.ammo", 9, 0)			  --WP_GRENADE_PINEAPPLE
			et.gentity_set(j, "ps.ammoclip", 9, 0)		--WP_GRENADE_PINEAPPLE
			et.gentity_set(j, "ps.ammoclip", 26, 0)		--WP_LANDMINE
			et.gentity_set(j, "ps.ammo", 31, 0) 		  --WP_MOBILE_MG42
			et.gentity_set(j, "ps.ammoclip", 31, 0) 	--WP_MOBILE_MG42
			et.gentity_set(j, "ps.ammo", 35, 0)			  --WP_MORTAR
			et.gentity_set(j, "ps.ammoclip", 35, 0)		--WP_MORTAR
		end
		et.trap_Cvar_Set("team_maxMG42s", "0")
		et.trap_Cvar_Set("team_maxMortars", "0")
		et.trap_Cvar_Set("team_maxRifleGrenades", "0")
		et.trap_Cvar_Set("team_maxPanzers", "0")
		et.trap_Cvar_Set("team_maxLandmines", "0")
		et.trap_Cvar_Set("g_maxTeamLandmines", "0")
		et.trap_Cvar_Set("team_maxFlamers", "0")
	elseif (numclients >= 10 and numclients < 12) and unlockvalue > 13 then
		et.trap_Cvar_Set("team_maxMortars", "0")
		et.trap_Cvar_Set("team_maxMG42s", "1")
		et.trap_Cvar_Set("team_maxPanzers", "1")
		et.trap_Cvar_Set("team_maxRifleGrenades", "1")
		et.trap_Cvar_Set("team_maxLandmines", "5")
		et.trap_Cvar_Set("g_maxTeamLandmines", "5")
		et.trap_Cvar_Set("team_maxFlamers", "0")
	elseif (numclients >= 12 and numclients < unlockvalue) and unlockvalue > 13 then
		et.trap_Cvar_Set("team_maxMortars", "1")
		et.trap_Cvar_Set("team_maxMG42s", "1")
		et.trap_Cvar_Set("team_maxPanzers", "1")
		et.trap_Cvar_Set("team_maxRifleGrenades", "1")
		et.trap_Cvar_Set("team_maxLandmines", "5")
		et.trap_Cvar_Set("g_maxTeamLandmines", "5")
		et.trap_Cvar_Set("team_maxFlamers", "1")
	elseif (numclients >= unlockvalue) and unlockvalue > 13 then
		et.trap_Cvar_Set("team_maxMG42s", mg42)
		et.trap_Cvar_Set("team_maxMortars", mortar)
		et.trap_Cvar_Set("team_maxRifleGrenades", riflegnade)
		et.trap_Cvar_Set("team_maxPanzers", panzer)
		et.trap_Cvar_Set("team_maxLandmines", mines)
		et.trap_Cvar_Set("g_maxTeamLandmines", mines)
		et.trap_Cvar_Set("team_maxFlamers", flamer)
	end

end

--0=Soldier, 1=Medic, 2=Engineer, 3=FieldOps, 4=CovertOps
function checkclass(client)
   local cs = et.trap_GetConfigstring(et.CS_PLAYERS + client)
    return tonumber(et.Info_ValueForKey(cs, "c"))
end

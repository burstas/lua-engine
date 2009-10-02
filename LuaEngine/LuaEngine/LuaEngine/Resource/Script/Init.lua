--function luaDoFiles()
--	for i in pairs(luaFileTable) do
--		local iret = luastate.DoFile(luaFileTable[i]);
--		if iret ~= 0 then
--			return false;
--		end
--	end
--	return true;
--end

function SystemInitial()
--	if luaDoFiles() == false then
--		return false;
--	end
	
	if hge.System_GetState(HGE_LOGFILE) == "" then
		hge.System_SetState(HGE_LOGFILE, LOG_STR_FILENAME);
	end
	hge.System_SetState(HGE_FPS, 60);
	hge.System_SetState(HGE_HIDEMOUSE, false);
	hge.System_SetState(HGE_DONTSUSPEND, true);
	hge.System_SetState(HGE_SHOWSPLASH, false);
	hge.System_SetState(HGE_INIFILE, CONFIG_STR_FILENAME);
	hge.System_SetState(HGE_TITLE, TITLE_STR);
	hge.System_SetState(HGE_SCREENWIDTH, M_CLIENT_WIDTH);
	hge.System_SetState(HGE_SCREENHEIGHT, M_CLIENT_HEIGHT);

	if hge.Ini_GetInt(RESCONFIGS_SYSTEM, RESCONFIGN_USE3DMODE, RESCONFIGDEFAULT_USE3DMODE) == 0 then
		export:ClientSet2DMode();
	end
	
	time = 0;
	return true;
end
function Process:_UpdateStage5()
	
	local timer = d.timer;
	
	local w = spgames.spstage5_square.hscale;
	
	local alarm = false;
	if w + M_ALARMTIME * d.stage5_increacespeed > d.stage5_w or w - M_ALARMTIME * d.stage5_decreacespeed < 0 then
		alarm = true;
		if w > d.stage5_w or w < 0 then
			return true;
		end
	end
		
	if alarm and time % 8 < 4 then
		spgames.spstage5.color = global.ARGB(M_STAGE_FLASHALPHA, M_STAGECOLOR_5);
	else
		spgames.spstage5.color = global.ARGB(M_STAGE_NORMALALPHA, M_STAGECOLOR_5);
	end
	
	if debug_cheat_5 then
		if not alarm then
			hge.Input_SetDIKey(self.keySpace);
		end
	end
	
	if hge.Input_GetDIKey(self.keySpace) then
		w = w + d.stage5_increacespeed;
	else
		w = w - d.stage5_decreacespeed;
	end
	
	spgames.spstage5_square.hscale = w;
	spgames.spstage5_square.vscale = w * d.stage5_hperw;
	
	local bAddScore = false;
	if hge.Input_GetDIKey(self.keySpace, DIKEY_UP) then
		d.stage5_decreacespeed = hge.Random_Float(d.stage5_decreacespeedmin, d.stage5_decreacespeedmax);
		bAddScore = true;
	end
	
	if bAddScore then
		data:UpdateScore(4);
	end
	
	return false;
end

function Process:_InitStage5()
	d.stage5_increacespeed = 1;
	d.stage5_decreacespeedmin = 0.4;
	d.stage5_decreacespeedmax = 1.2;
	d.stage5_decreacespeed = hge.Random_Float(d.stage5_decreacespeedmin, d.stage5_decreacespeedmax);
	local startw = d.stage5_w / 2;
	d.stage5_hperw = d.stage5_h / d.stage5_w;
	spgames.spstage5_square = spim:Push(true, SI_BLANK_POINT,
		d.stage5_cx, d.stage5_cy, 0, startw, startw * d.stage5_hperw, global.ARGB(0xC0, 0xffffff));
end

function Process:_RenderStart_Stage5()
	local arrange = HGETEXT_CENTER;
	local tx = d.stage5_cx;
	local ty = d.stage5_y + d.stage5_h / 4;
	hgeFont.printf(self.gamefont, tx, ty, arrange, "Space Bar");
	
	if spgames == nil then
		return;
	end
	spim:RenderItem(spgames.spstage5_square);
end
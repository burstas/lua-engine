function Process:_ResetStage3()
	local randval = hge.Random_Int(1, 3);
	d.stage3_rand = randval;
	se:Stop(SE_GAME_DOWN);
	se:Stop(SE_GAME_FLAT);
	se:Stop(SE_GAME_UP);
	if randval == 1 then
		se:Push(SE_GAME_DOWN);
	elseif randval == 2 then
		se:Push(SE_GAME_FLAT);
	elseif randval == 3 then
		se:Push(SE_GAME_UP);
	end
	d.stage3_npop = d.stage3_npop + d.stage3_npopadd;
	if d.stage3_npop > d.stage3_npopmax then
		d.stage3_npop = d.stage3_npopmax;
	end
	
	if debug_cheat_3 then
		d.debug_cheat_3_wait = true;
	end
end

function Process:_UpdateStage3()
	
	local timer = d.timer;
	
	if timer == 1 then
		self:_ResetStage3();
	end
	
	local bLoose = false;
	local bReset = false;
	
	if debug_cheat_3 then
		if not d.debug_cheat_3_wait then
			if d.stage3_rand == 1 then
				if not hge.Input_GetDIKey(self.keyZ) then
					hge.Input_SetDIKey(self.keyZ, true);
				end
				hge.Input_SetDIKey(self.keyX, false);
				hge.Input_SetDIKey(self.keyC, false);
			elseif d.stage3_rand == 2 then
				if not hge.Input_GetDIKey(self.keyX) then
					hge.Input_SetDIKey(self.keyX, true);
				end
				hge.Input_SetDIKey(self.keyZ, false);
				hge.Input_SetDIKey(self.keyC, false);
			elseif d.stage3_rand == 3 then
				if not hge.Input_GetDIKey(self.keyC) then
					hge.Input_SetDIKey(self.keyC, true);
				end
				hge.Input_SetDIKey(self.keyZ, false);
				hge.Input_SetDIKey(self.keyX, false);
			end
		else
			d.debug_cheat_3_wait = false;
		end
	end
	
	if hge.Input_GetDIKey(self.keyZ, DIKEY_DOWN) then
		if d.stage3_rand ~= 1 then
			bLoose = true;
		else
			bReset = true;
		end
	end
	if hge.Input_GetDIKey(self.keyX, DIKEY_DOWN) then
		if d.stage3_rand ~= 2 then
			bLoose = true;
		else
			bReset = true;
		end
	end
	if hge.Input_GetDIKey(self.keyC, DIKEY_DOWN) then
		if d.stage3_rand ~= 3 then
			bLoose = true;
		else
			bReset = true;
		end
	end
	if bLoose then
		return true;
	end
	if bReset then
		self:_ResetStage3();
	end
	
	d.stage3_npop = d.stage3_npop - d.stage3_npopminus;
	if d.stage3_npop < 0 then
		return true;
	end
	if d.stage3_npop < M_ALARMTIME * d.stage3_npopminus and timer % 8 < 4 then
		spgames.spstage3_slot.color = global.ARGB(0xff, 0xffff00);
		spgames.spstage3.color = global.ARGB(M_STAGE_FLASHALPHA, M_STAGECOLOR_3);
	else
		spgames.spstage3_slot.color = global.ARGB(0xff, 0x7fffff);
		spgames.spstage3.color = global.ARGB(M_STAGE_NORMALALPHA, M_STAGECOLOR_3);
	end
	spgames.spstage3_slot.vscale = d.stage3_npop;
	
	if bReset then
		data:UpdateScore(d.stage3_npoplast / 2);
	end
	
	return false;
end

function Process:_InitStage3()
	d.stage3_npopmax = d.stage3_y + d.stage3_h - (d.stage5_y + d.stage5_h) - 8;
	d.stage3_npop = d.stage3_npopmax;
	d.stage3_npoplast = 300;
	d.stage3_npopminus = d.stage3_npopmax / d.stage3_npoplast;
	d.stage3_npopadd = d.stage3_npopmax / 3 * 2;
	spgames.spstage3_slot = spim:Push(true, SI_BLANK_POINT, 
		d.stage3_w + d.stage3_x - 5, d.stage5_y + d.stage5_h + 4, 0, 8, d.stage3_npop);
	hgeSprite.SetHotSpot(spgames.spstage3_slot.sprite, 0.5, 0);
end

function Process:_RenderStart_Stage3()
	if spgames == nil then
		return;
	end
	spim:RenderItem(spgames.spstage3_slot);
	
	local arrange = HGETEXT_CENTER;
	local tx = d.stage3_cx;
	local ty = d.stage3_cy;
	local txoffset = 90;
	local tyoffset = 30;
	hgeFont.printf(self.gamefont, tx, ty - tyoffset, arrange, "Listen...")
	hgeFont.printf(self.gamefont, tx - txoffset, ty, arrange, "Z");
	hgeFont.printf(self.gamefont, tx, ty, arrange, "X");
	hgeFont.printf(self.gamefont, tx + txoffset, ty, arrange, "C");
	hgeFont.printf(self.gamefont, tx - txoffset, ty + tyoffset, arrange, "Down");
	hgeFont.printf(self.gamefont, tx, ty + tyoffset, arrange, "Flat");
	hgeFont.printf(self.gamefont, tx + txoffset, ty + tyoffset, arrange, "Up");
end
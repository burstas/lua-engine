function Process:_ResetStage1()
	local randval = hge.Random_Int(1, 3);
	
	spgames.spstage1_V.able = false;
	spgames.spstage1_O.able = false;
	spgames.spstage1_W.able = false;
	d.stage1_rand = randval;
	local tox = d.stage1_cx;
	local toy = d.stage1_cy;
	
	if randval == 1 then
		spgames.spstage1_V.able = true;
	elseif randval == 2 then
		spgames.spstage1_O.able = true;
	elseif randval == 3 then
		spgames.spstage1_W.able = true;
	end
	d.stage1_npop = d.stage1_npop + d.stage1_npopadd;
	if d.stage1_npop > d.stage1_npopmax then
		d.stage1_npop = d.stage1_npopmax;
	end
	
	if debug_cheat_1 then
		d.debug_cheat_1_wait = true;
	end
end

function Process:_UpdateStage1()
	local timer = d.timer;
	
	if timer == 1 then
		self:_ResetStage1();
	end
	
	local bLoose = false;
	local bReset = false;
	
	if debug_cheat_1 then
		if not d.debug_cheat_1_wait then
			if d.stage1_rand == 3 then
				if not hge.Input_GetDIKey(self.keyA) then
					hge.Input_SetDIKey(self.keyA, true);
				end
				hge.Input_SetDIKey(self.keyS, false);
				hge.Input_SetDIKey(self.keyD, false);
			elseif d.stage1_rand == 1 then
				if not hge.Input_GetDIKey(self.keyS) then
					hge.Input_SetDIKey(self.keyS, true);
				end
				hge.Input_SetDIKey(self.keyA, false);
				hge.Input_SetDIKey(self.keyD, false);
			elseif d.stage1_rand == 2 then
				if not hge.Input_GetDIKey(self.keyD) then
					hge.Input_SetDIKey(self.keyD, true);
				end
				hge.Input_SetDIKey(self.keyA, false);
				hge.Input_SetDIKey(self.keyS, false);
			end
		else
			d.debug_cheat_1_wait = false;
		end
	end
	if hge.Input_GetDIKey(self.keyA, DIKEY_DOWN) then
		if d.stage1_rand ~= 3 then
			bLoose = true;
		else
			bReset = true;
		end
	end
	if hge.Input_GetDIKey(self.keyS, DIKEY_DOWN) then
		if d.stage1_rand ~= 1 then
			bLoose = true;
		else
			bReset = true;
		end
	end
	if hge.Input_GetDIKey(self.keyD, DIKEY_DOWN) then
		if d.stage1_rand ~= 2 then
			bLoose = true;
		else
			bReset = true;
		end
	end
	if bLoose then
		return true;
	end
	if bReset then
		self:_ResetStage1();
	end
	
	d.stage1_npop = d.stage1_npop - d.stage1_npopminus;
	if d.stage1_npop < 0 then
		return true;
	end
	if d.stage1_npop < M_ALARMTIME * d.stage1_npopminus and timer % 8 < 4 then
		spgames.spstage1_slot.color = global.ARGB(0xff, 0xffff00);
		spgames.spstage1.color = global.ARGB(M_STAGE_FLASHALPHA, M_STAGECOLOR_1);
	else
		spgames.spstage1_slot.color = global.ARGB(0xff, 0x7fffff);
		spgames.spstage1.color = global.ARGB(M_STAGE_NORMALALPHA, M_STAGECOLOR_1);
	end
	spgames.spstage1_slot.vscale = d.stage1_npop;
	
	if bReset then
		data:UpdateScore(d.stage1_npoplast / 2);
	end
	
	return false;
end

function Process:_InitStage1()
	spgames.spstage1_V = spim:Push(false, SI_OBJ_V, 
		d.stage1_cx, d.stage1_cy, 0, 3);
	spgames.spstage1_O = spim:Push(false, SI_OBJ_O, 
		d.stage1_cx, d.stage1_cy, 0, 3);
	spgames.spstage1_W = spim:Push(false, SI_OBJ_W, 
		d.stage1_cx, d.stage1_cy, 0, 3);
		
	d.stage1_npopmax = d.stage5_y - d.stage1_y - 8;
	d.stage1_npop = d.stage1_npopmax;
	d.stage1_npoplast = 400;
	d.stage1_npopminus = d.stage1_npopmax / d.stage1_npoplast;
	d.stage1_npopadd = d.stage1_npopmax / 3 * 2;
	spgames.spstage1_slot = spim:Push(true, SI_BLANK_POINT, 
		d.stage1_w + d.stage1_x - 5, d.stage1_y + 4, 0, 8, d.stage1_npop);
	hgeSprite.SetHotSpot(spgames.spstage1_slot.sprite, 0.5, 0);
	
end

function Process:_RenderStart_Stage1()
	if spgames == nil then
		return;
	end
	spim:RenderItem(spgames.spstage1_V);
	spim:RenderItem(spgames.spstage1_O);
	spim:RenderItem(spgames.spstage1_W);
	local tx = d.stage1_w / 4 + d.stage1_x;
	local ty = d.stage1_h / 5 + d.stage1_y;
	local txoffset = d.stage1_w / 4;
	spim:RenderItemAs(spgames.spstage1_V, tx, ty, 0, 1);
	tx = tx + txoffset;
	spim:RenderItemAs(spgames.spstage1_O, tx, ty, 0, 1);
	tx = tx + txoffset;
	spim:RenderItemAs(spgames.spstage1_W, tx, ty, 0, 1);
	
	spim:RenderItem(spgames.spstage1_slot);
	
	local arrange = HGETEXT_CENTER;
	ty = d.stage1_y;
	hgeFont.printf(self.gamefont, tx - txoffset * 2, ty, arrange, "A");
	hgeFont.printf(self.gamefont, tx - txoffset, ty, arrange, "S");
	hgeFont.printf(self.gamefont, tx, ty, arrange, "D");
end
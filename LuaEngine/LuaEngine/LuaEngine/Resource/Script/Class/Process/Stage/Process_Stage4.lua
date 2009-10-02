function Process:_UpdateStage4()
	
	local timer = d.timer;
	
	spgames.spstage4_player.y = self:_GetStage4Y(d.stage4_playerypos);
	
	d.stage4_alarm = false;
	d.stage4_ballx1, d.stage4_ballypos1, failed = self:_MoveStage4Ball(d.stage4_ballx1, d.stage4_ballypos1, effm.effects.games.effstage4_ball1);
	if failed then
		return true;
	end
	d.stage4_ballx2, d.stage4_ballypos2, failed = self:_MoveStage4Ball(d.stage4_ballx2, d.stage4_ballypos2, effm.effects.games.effstage4_ball2);
	if failed then
		return true;
	end
	d.stage4_ballx3, d.stage4_ballypos3, failed = self:_MoveStage4Ball(d.stage4_ballx3, d.stage4_ballypos3, effm.effects.games.effstage4_ball3);
	if failed then
		return true;
	end
	d.stage4_ballx4, d.stage4_ballypos4, failed = self:_MoveStage4Ball(d.stage4_ballx4, d.stage4_ballypos4, effm.effects.games.effstage4_ball4);
	if failed then
		return true;
	end
	d.stage4_ballx5, d.stage4_ballypos5, failed = self:_MoveStage4Ball(d.stage4_ballx5, d.stage4_ballypos5, effm.effects.games.effstage4_ball5);
	if failed then
		return true;
	end
	d.stage4_ballx6, d.stage4_ballypos6, failed = self:_MoveStage4Ball(d.stage4_ballx6, d.stage4_ballypos6, effm.effects.games.effstage4_ball6);
	if failed then
		return true;
	end	
	
	if d.stage4_alarm and timer % 8 < 4 then
		spgames.spstage4.color = global.ARGB(M_STAGE_FLASHALPHA, M_STAGECOLOR_4);
	else
		spgames.spstage4.color = global.ARGB(M_STAGE_NORMALALPHA, M_STAGECOLOR_4);
	end
	
	if debug_cheat_4 then
		if d.stage4_alarm then
			if d.stage4_playerypos ~= 0 then
				if not hge.Input_GetDIKey(self.keyUp) then
					hge.Input_SetDIKey(self.keyUp);
				end
			elseif not hge.Input_GetDIKey(self.keyDown) then
				hge.Input_SetDIKey(self.keyDown);
			end
		end
	end
	if hge.Input_GetDIKey(self.keyUp, DIKEY_DOWN) then
		if d.stage4_playerypos > 0 then
			d.stage4_playerypos = d.stage4_playerypos - 1;
		end
	end
	if hge.Input_GetDIKey(self.keyDown, DIKEY_DOWN) then
		if d.stage4_playerypos < 4 then
			d.stage4_playerypos = d.stage4_playerypos + 1;
		end
	end
		
	if failed then
		return true;
	end
	
	data:UpdateScore(1);
	
	return false;
end

function Process:_MoveStage4Ball(x, ypos, effectitem)
	x = x - d.stage4_ballspeed;
	local able;
	if x < d.stage4_x + d.stage4_edge then
		x = d.stage4_newballx;
		ypos = hge.Random_Int(0, 4);
		able = false;
	end
	if not effectitem.able and x < d.stage4_x + d.stage4_w - d.stage4_edge then
		able = true;
	end
	local failed = false;
	if ypos == d.stage4_playerypos then
		local xdiff = x - d.stage4_stringx;
		if xdiff > 0 then
			if xdiff < d.stage4_ballspeed * M_ALARMTIME then
				d.stage4_alarm = true;
				if xdiff < d.stage4_ballr then
					failed = true;
				end
			end
		end
	end
	effm:Update(effectitem, able, x, self:_GetStage4Y(ypos));
	return x, ypos, failed;
end

function Process:_GetStage4Y(ypos)
	return d.stage4_yfirst + ypos * d.stage4_yoffset
end

function Process:_InitStage4()
	d.stage4_edge = 16;
	d.stage4_alarm = false;
	d.stage4_topedge = d.stage5_y + d.stage5_h - d.stage4_y;
	d.stage4_ballspeed = 1.5;
	local racetime = (d.stage4_w - d.stage4_edge * 2) / d.stage4_ballspeed;
	
	d.stage4_stringx = d.stage4_w / 3 + d.stage4_x;
	local updownedge = 4;
	local lineyfirst = d.stage4_y + d.stage4_topedge + updownedge;
	local yoffset = (d.stage4_h - d.stage4_topedge - updownedge * 2) / 5;
	d.stage4_yoffset = yoffset;
	d.stage4_yfirst = lineyfirst + d.stage4_yoffset / 2;
	d.stage4_playerypos = 2;
	local ycenter = self:_GetStage4Y(d.stage4_playerypos)
	
	spgames.spstage4_string = spim:Push(true, SI_BLANK_POINT,
		d.stage4_stringx, ycenter, 0, 4, d.stage4_h - d.stage4_topedge);
	spgames.spstage4_player = spim:Push(true, SI_BLANK_SQUARE,
		d.stage4_stringx, ycenter, 0, 1, 1, global.ARGB(0xFF, 0x00FFFF));
		
	spgames.spstage4_line1 = spim:Push(true, SI_BLANK_POINT,
		d.stage4_cx, lineyfirst, 0, d.stage4_w - d.stage4_edge * 2, 1);
	spgames.spstage4_line2 = spim:Push(true, SI_BLANK_POINT,
		d.stage4_cx, lineyfirst + yoffset, 0, d.stage4_w - d.stage4_edge * 2, 1);
	spgames.spstage4_line3 = spim:Push(true, SI_BLANK_POINT,
		d.stage4_cx, lineyfirst + yoffset * 2, 0, d.stage4_w - d.stage4_edge * 2, 1);
	spgames.spstage4_line4 = spim:Push(true, SI_BLANK_POINT,
		d.stage4_cx, lineyfirst + yoffset * 3, 0, d.stage4_w - d.stage4_edge * 2, 1);
	spgames.spstage4_line5 = spim:Push(true, SI_BLANK_POINT,
		d.stage4_cx, lineyfirst + yoffset * 4, 0, d.stage4_w - d.stage4_edge * 2, 1);
	spgames.spstage4_line6 = spim:Push(true, SI_BLANK_POINT,
		d.stage4_cx, lineyfirst + yoffset * 5, 0, d.stage4_w - d.stage4_edge * 2, 1);
	
	if effm.effects.games == nil then
		effm.effects.games = {};
	end
	d.stage4_ballr = 4;
	local xoffset = d.stage4_ballspeed * racetime / 3;
	local firstballx = d.stage4_x + d.stage4_w + xoffset;
	d.stage4_newballx = firstballx + xoffset * 2;
	d.stage4_ballx1 = firstballx;
	d.stage4_ballx2 = firstballx + xoffset;
	d.stage4_ballx3 = firstballx + xoffset * 2;
	d.stage4_ballx4 = firstballx + xoffset * 3;
	d.stage4_ballx5 = firstballx + xoffset * 4;
	d.stage4_ballx6 = firstballx + xoffset * 5;
	d.stage4_ballypos1 = hge.Random_Int(0, 4);
	d.stage4_bally1 = self:_GetStage4Y(d.stage4_ballypos1);
	d.stage4_ballypos2 = hge.Random_Int(0, 4);
	d.stage4_bally2 = self:_GetStage4Y(d.stage4_ballypos2);
	d.stage4_ballypos3 = hge.Random_Int(0, 4);
	d.stage4_bally3 = self:_GetStage4Y(d.stage4_ballypos3);
	d.stage4_ballypos4 = hge.Random_Int(0, 4);
	d.stage4_bally4 = self:_GetStage4Y(d.stage4_ballypos4);
	d.stage4_ballypos5 = hge.Random_Int(0, 4);
	d.stage4_bally5 = self:_GetStage4Y(d.stage4_ballypos5);
	d.stage4_ballypos6 = hge.Random_Int(0, 4);
	d.stage4_bally6 = self:_GetStage4Y(d.stage4_ballypos6);
	effm.effects.games.effstage4_ball1 = effm:Push(false, EFF_BALL,
		d.stage4_ballx1, d.stage4_bally1);
	effm.effects.games.effstage4_ball2 = effm:Push(false, EFF_BALL,
		d.stage4_ballx2, d.stage4_bally2);
	effm.effects.games.effstage4_ball3 = effm:Push(false, EFF_BALL,
		d.stage4_ballx3, d.stage4_bally3);
	effm.effects.games.effstage4_ball4 = effm:Push(false, EFF_BALL,
		d.stage4_ballx4, d.stage4_bally4);
	effm.effects.games.effstage4_ball5 = effm:Push(false, EFF_BALL,
		d.stage4_ballx5, d.stage4_bally5);
	effm.effects.games.effstage4_ball6 = effm:Push(false, EFF_BALL,
		d.stage4_ballx6, d.stage4_bally6);
end

function Process:_RenderStart_Stage4()
	
	local arrange = HGETEXT_CENTER;
	local tx = d.stage4_w * 2 / 3 + d.stage4_x;
	local ty = d.stage4_yfirst + d.stage4_yoffset * 0.5;
	local tyoffset = d.stage4_yoffset * 2;
	hgeFont.printf(self.gamefont, tx, ty, arrange, "Up");
	hgeFont.printf(self.gamefont, tx, ty + tyoffset, arrange, "Down");
	
	if spgames == nil then
		return;
	end
	spim:RenderItem(spgames.spstage4_string);
	spim:RenderItem(spgames.spstage4_player);
	spim:RenderItem(spgames.spstage4_line1);
	spim:RenderItem(spgames.spstage4_line2);
	spim:RenderItem(spgames.spstage4_line3);
	spim:RenderItem(spgames.spstage4_line4);
	spim:RenderItem(spgames.spstage4_line5);
	spim:RenderItem(spgames.spstage4_line6);
	
	games = effm.effects.games;
	if games == nil then
		return;
	end
	
	effm:RenderItem(games.effstage4_ball1);
	effm:RenderItem(games.effstage4_ball2);
	effm:RenderItem(games.effstage4_ball3);
	effm:RenderItem(games.effstage4_ball4);
	effm:RenderItem(games.effstage4_ball5);
	effm:RenderItem(games.effstage4_ball6);
end
function Process:_UpdateStage2()
	local timer = d.timer;
	
	if timer == 1 then
		self:_UpdateStage2BallAcc();
	end
	
	if debug_cheat_2 then
		if d.stage2_barx > d.stage2_ballx then
			hge.Input_SetDIKey(self.keyLeft);
		else
			hge.Input_SetDIKey(self.keyRight);
		end
	end
		
	local movebarx = 0;
	if hge.Input_GetDIKey(self.keyLeft) then
		movebarx = movebarx - d.stage2_barspeed;
	end
	if hge.Input_GetDIKey(self.keyRight) then
		movebarx = movebarx + d.stage2_barspeed;
	end
	d.stage2_barx = d.stage2_barx + movebarx;
	local halfbarlength = d.stage2_barlength / 2;
	if d.stage2_barx > d.stage2_x + d.stage2_w - halfbarlength then
		d.stage2_barx = d.stage2_x + d.stage2_w - halfbarlength;
	elseif d.stage2_barx < d.stage2_x + d.stage2_leftedge + halfbarlength then
		d.stage2_barx = d.stage2_x + d.stage2_leftedge + halfbarlength;
	end
	spgames.spstage2_bartop.x = d.stage2_barx;
	spgames.spstage2_barbottom.x = d.stage2_barx;
	
	local lastangle = d.stage2_ballangle;
	local nowangle = lastangle;
	lastangle = self:_RegularStage2Angle(lastangle);
	local bounceedge = d.stage2_edge + d.stage2_ballr;
	local xdiff = d.stage2_ballx - d.stage2_barx;
	local absxdiff = math.abs(xdiff);
	local trange = halfbarlength + d.stage2_ballr;
		
	if d.stage2_ballx < d.stage2_x + d.stage2_leftedge + trange or d.stage2_ballx > d.stage2_x + d.stage2_w - trange then
		nowangle = 180 - nowangle;
		nowangle = self:_RegularStage2Angle(nowangle);
		if nowangle <= 0 and nowangle > -45 then
			nowangle = -45;
		elseif nowangle > 0 and nowangle < 45 then
			nowangle = 45;
		elseif nowangle > 135 then
			nowangle = 135;
		elseif nowangle < -135 then
			nowangle = -135;
		end
	end
	
	nowangle = self:_RegularStage2Angle(nowangle);
	
	local bAddScore = false;
	if absxdiff < trange then
		if (d.stage2_bally < d.stage2_y + bounceedge and d.stage2_bally >= d.stage2_barytop and nowangle < 0) or
			(d.stage2_bally > d.stage2_y + d.stage2_h - bounceedge and d.stage2_bally <= d.stage2_barybottom and nowangle > 0) then
			bAddScore = true;
			if nowangle > 0 then
				nowangle = hge.Random_Int(-135, -45);
			else
				nowangle = hge.Random_Int(45, 135);
			end
		end
	end
	
	if lastangle ~= nowangle then
		d.stage2_ballangle = nowangle;
		self:_UpdateStage2BallAcc();
	end
		
	
	d.stage2_ballx = d.stage2_ballx + d.stage2_ballxacc;
	d.stage2_bally = d.stage2_bally + d.stage2_ballyacc;
	effm:Update(effm.effects.games.effstage2_ball, nil, d.stage2_ballx, d.stage2_bally);
			
	if d.stage2_bally < d.stage2_y or d.stage2_bally > d.stage2_y + d.stage2_h then
		return true;
	end
	
	local alarmpredict = d.stage2_bally + M_ALARMTIME * d.stage2_ballyacc;
	if timer > 60 and
		(alarmpredict < d.stage2_edge + d.stage2_y or
		alarmpredict > d.stage2_y + d.stage2_h - d.stage2_edge) and
		timer % 8 < 4 then
		spgames.spstage2.color = global.ARGB(M_STAGE_FLASHALPHA, M_STAGECOLOR_2);
	else
		spgames.spstage2.color = global.ARGB(M_STAGE_NORMALALPHA, M_STAGECOLOR_2);
	end
	
	if bAddScore then
		data:UpdateScore(d.stage2_averagelast);
	end
		
	return false;
end

function Process:_RegularStage2Angle(angle)
	while angle > 180 do
		angle = angle - 360;
	end
	while angle <= -180 do
		angle = angle + 360;
	end
	return angle;
end

function Process:_UpdateStage2BallAcc()
	local trad = math.rad(d.stage2_ballangle);
	d.stage2_ballxacc = math.cos(trad) * d.stage2_ballspeed;
	d.stage2_ballyacc = math.sin(trad) * d.stage2_ballspeed;
end

function Process:_InitStage2()
	d.stage2_ballangle = hge.Random_Int(-135, -45);
	d.stage2_ballspeed = 1;
	d.stage2_barspeed = 5;
	d.stage2_edge = 16;
	d.stage2_leftedge = d.stage5_x + d.stage5_w - d.stage2_x;
	d.stage2_barx = d.stage2_cx + d.stage2_leftedge / 2;
	d.stage2_barytop = d.stage2_y + d.stage2_edge;
	d.stage2_barybottom = d.stage2_y + d.stage2_h - d.stage2_edge;
	d.stage2_barlength = 45;
	d.stage2_averagelast = (d.stage2_barybottom - d.stage2_barytop) / d.stage2_ballspeed * 1.1222;
	spgames.spstage2_bartop = spim:Push(true, SI_BLANK_POINT,
		d.stage2_barx, d.stage2_barytop, 0, d.stage2_barlength, 4);
	spgames.spstage2_barbottom = spim:Push(true, SI_BLANK_POINT,
		d.stage2_barx, d.stage2_barybottom, 0, d.stage2_barlength, 4);
	spgames.spstage2_barleft = spim:Push(true, SI_BLANK_POINT,
		d.stage2_x + d.stage2_leftedge + d.stage2_edge, d.stage2_cy, 0, 4, d.stage2_h - d.stage2_edge * 2);
	spgames.spstage2_barright = spim:Push(true, SI_BLANK_POINT,
		d.stage2_x + d.stage2_w - d.stage2_edge, d.stage2_cy, 0, 4, d.stage2_h - d.stage2_edge * 2);
		
	if effm.effects.games == nil then
		effm.effects.games = {};
	end
	d.stage2_ballr = 4;
	d.stage2_ballx = d.stage2_barx;
	d.stage2_bally = d.stage2_y + d.stage2_h - d.stage2_edge - d.stage2_ballr;
	effm.effects.games.effstage2_ball = effm:Push(true, EFF_BALL,
		d.stage2_ballx, d.stage2_bally);
end

function Process:_RenderStart_Stage2()
	
	local arrange = HGETEXT_CENTER;
	local tx = d.stage2_cx + d.stage2_leftedge / 2;
	local ty = d.stage1_cy;
	local txoffset = 45;
	hgeFont.printf(self.gamefont, tx - txoffset, ty, arrange, "Left");
	hgeFont.printf(self.gamefont, tx + txoffset, ty, arrange, "Right");
	
	if spgames == nil then
		return;
	end
	spim:RenderItem(spgames.spstage2_bartop);
	spim:RenderItem(spgames.spstage2_barbottom);
	spim:RenderItem(spgames.spstage2_barleft);
	spim:RenderItem(spgames.spstage2_barright);
		
	games = effm.effects.games;
	if games == nil then
		return;
	end
	effm:RenderItem(games.effstage2_ball);
end
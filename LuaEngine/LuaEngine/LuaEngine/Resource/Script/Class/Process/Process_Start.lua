function Process:ProcessStart()

	time = time + 1;
	if time == 1 then
		music:MusicChange(MUS_STAGE);
		self:_StartPrep();
	end
	if time > 60 then
		d.timer = d.timer + 1;
		local bret;
		if d.havestage1 then
			bret = self:_UpdateStage1();
			if debug_ignore_1 then
				bret = false;
			end
			if bret then
				se:Push(SE_GAME_GAMEOVER, d.stage1_cx);
			end
		end
		if not bret and d.havestage2 then
			bret = self:_UpdateStage2();
			if debug_ignore_2 then
				bret = false;
			end
			if bret then
				se:Push(SE_GAME_GAMEOVER, d.stage2_cx);
			end
		end
		if not bret and d.havestage3 then
			bret = self:_UpdateStage3();
			if debug_ignore_3 then
				bret = false;
			end
			if bret then
				se:Push(SE_GAME_GAMEOVER, d.stage3_cx);
			end
		end
		if not bret and d.havestage4 then
			bret = self:_UpdateStage4();
			if debug_ignore_4 then
				bret = false;
			end
			if bret then
				se:Push(SE_GAME_GAMEOVER, d.stage4_cx);
			end
		end
		if not bret and d.havestage5 then
			bret = self:_UpdateStage5();
			if debug_ignore_5 then
				bret = false;
			end
			if bret then
				se:Push(SE_GAME_GAMEOVER, d.stage5_cx);
			end
		end
		
		if debug_suicidekey > 0 then
			if hge.Input_GetDIKey(debug_suicidekey, DIKEY_DOWN) then
				bret = true;
			end
		end
		
		if bret then
			self.state = STATE_OVER;
			time = 0;
			return PTURN;
		else
			data:UpdateScore(M_SCOREPERTIME, time);
		end
	end
	
	return PGO;
end

function Process:_StartPrep()
	self:SetActive(true);
	spim:Clear();
	effm:Clear();
	local active, replaying = self:CheckActive();
	local name, difficult, stage, seed;
	if replaying then
		name, difficult, stage, seed = data:GetReplayHeader();
		hge.Random_Seed(seed);
		self.nowdifflv = difficult;
	else
		seed = hge.Random_Seed();
		self.nowdifflv = sel.saved[SELSAVE_DIFFICULT];
	end
	local bit1 = hge.Random_Int(0, 4);
	local bit2;
	repeat
		bit2 = hge.Random_Int(0, 4);
	until bit2 ~= bit1;
	if self.nowdifflv == 4 then
		stage = 0x1F;
	else
		stage = luastate.LShift(1, bit1);
		if self.nowdifflv == 3 then
			stage = luastate.Xor(stage, 0x1F);
		else
			stage = stage + luastate.LShift(1, bit2);
			if self.nowdifflv == 2 then
				stage = luastate.Xor(stage, 0x1F);
			end
		end
	end
	
	if not replaying then
		data:PushReplayHeader(export:GetUsername(), self.nowdifflv, stage, seed);
	end
	data:SetDifficultScoreFactor(self.nowdifflv);
	
	d.stage1_x = M_CLIENT_LEFT;
	d.stage1_y = M_CLIENT_TOP;
	d.stage1_w = M_CLIENT_WIDTH / 2;
	d.stage1_h = M_CLIENT_HEIGHT / 2;
	d.stage1_cx = d.stage1_w / 2 + d.stage1_x;
	d.stage1_cy = d.stage1_h / 2 + d.stage1_y;
	spim.sprites.games = {};
	spgames.spstage1 = spim:Push(
		true,
		SI_BLANK_POINT,
		d.stage1_cx, d.stage1_cy, 0,
		d.stage1_w, d.stage1_h
	);
	d.stage2_x = M_CLIENT_LEFT + M_CLIENT_WIDTH / 2;
	d.stage2_y = M_CLIENT_TOP;
	d.stage2_w = M_CLIENT_WIDTH / 2;
	d.stage2_h = M_CLIENT_HEIGHT / 2;
	d.stage2_cx = d.stage2_w / 2 + d.stage2_x;
	d.stage2_cy = d.stage2_h / 2 + d.stage2_y;
	spgames.spstage2 = spim:Push(
		true,
		SI_BLANK_POINT,
		d.stage2_cx, d.stage2_cy, 0,
		d.stage2_w, d.stage2_h
	);
	d.stage3_x = M_CLIENT_LEFT;
	d.stage3_y = M_CLIENT_TOP + M_CLIENT_HEIGHT / 2;
	d.stage3_w = M_CLIENT_WIDTH / 2;
	d.stage3_h = M_CLIENT_HEIGHT / 2;
	d.stage3_cx = d.stage3_w / 2 + d.stage3_x;
	d.stage3_cy = d.stage3_h / 2 + d.stage3_y;
	spgames.spstage3 = spim:Push(
		true,
		SI_BLANK_POINT,
		d.stage3_cx, d.stage3_cy, 0,
		d.stage3_w, d.stage3_h
	);
	d.stage4_x = M_CLIENT_LEFT + M_CLIENT_WIDTH / 2;
	d.stage4_y = M_CLIENT_TOP + M_CLIENT_HEIGHT / 2;
	d.stage4_w = M_CLIENT_WIDTH / 2;
	d.stage4_h = M_CLIENT_HEIGHT / 2;
	d.stage4_cx = d.stage4_w / 2 + d.stage4_x;
	d.stage4_cy = d.stage4_h / 2 + d.stage4_y;
	spgames.spstage4 = spim:Push(
		true,
		SI_BLANK_POINT,
		d.stage4_cx, d.stage4_cy, 0,
		d.stage4_w, d.stage4_h
	);
	d.stage5_x = M_CLIENT_LEFT + M_CLIENT_WIDTH / 3;
	d.stage5_y = M_CLIENT_TOP + M_CLIENT_HEIGHT / 3;
	d.stage5_w = M_CLIENT_WIDTH / 3;
	d.stage5_h = M_CLIENT_HEIGHT / 3;
	d.stage5_cx = d.stage5_w / 2 + d.stage5_x;
	d.stage5_cy = d.stage5_h / 2 + d.stage5_y;
	spgames.spstage5 = spim:Push(
		true,
		SI_BLANK_POINT,
		d.stage5_cx, d.stage5_cy, 0,
		d.stage5_w, d.stage5_h
	);
	spgames.spstage5_bg = spim:Push(
		true,
		SI_BLANK_POINT,
		d.stage5_cx, d.stage5_cy, 0,
		d.stage5_w, d.stage5_h, global.ARGB(0xff, 0)
	);
	
	local tcol;
	d.havestage1 = luastate.And(stage, luastate.LShift(1, 4)) > 0;
	if d.havestage1 then
		tcol = global.ARGB(M_STAGE_NORMALALPHA, M_STAGECOLOR_1);
	else
		tcol = global.ARGB(M_STAGE_NONACTIVEALPHA, M_STAGECOLOR_1);
	end
	spgames.spstage1.color = tcol;
	d.havestage2 = luastate.And(stage, luastate.LShift(1, 3)) > 0;
	if d.havestage2 then
		tcol = global.ARGB(M_STAGE_NORMALALPHA, M_STAGECOLOR_2);
	else
		tcol = global.ARGB(M_STAGE_NONACTIVEALPHA, M_STAGECOLOR_2);
	end
	spgames.spstage2.color = tcol;
	d.havestage3 = luastate.And(stage, luastate.LShift(1, 2)) > 0;
	if d.havestage3 then
		tcol = global.ARGB(M_STAGE_NORMALALPHA, M_STAGECOLOR_3);
	else
		tcol = global.ARGB(M_STAGE_NONACTIVEALPHA, M_STAGECOLOR_3);
	end
	spgames.spstage3.color = tcol;
	d.havestage4 = luastate.And(stage, luastate.LShift(1, 1)) > 0;
	if d.havestage4 then
		tcol = global.ARGB(M_STAGE_NORMALALPHA, M_STAGECOLOR_4);
	else
		tcol = global.ARGB(M_STAGE_NONACTIVEALPHA, M_STAGECOLOR_4);
	end
	spgames.spstage4.color = tcol;
	d.havestage5 = luastate.And(stage, luastate.LShift(1, 0)) > 0;
	if d.havestage5 then
		tcol = global.ARGB(M_STAGE_NORMALALPHA, M_STAGECOLOR_5);
	else
		tcol = global.ARGB(M_STAGE_NONACTIVEALPHA, M_STAGECOLOR_5);
	end
	spgames.spstage5.color = tcol;
	
	d.timer = 0;
	if d.havestage1 then
		self:_InitStage1();
	end
	if d.havestage2 then
		self:_InitStage2();
	end
	if d.havestage3 then
		self:_InitStage3();
	end
	if d.havestage4 then
		self:_InitStage4();
	end
	if d.havestage5 then
		self:_InitStage5();
	end
end

function Process:_RenderStart()
	if spim.sprites.games ~= nil then
		spim:RenderItem(spgames.spstage1);
		spim:RenderItem(spgames.spstage2);
		spim:RenderItem(spgames.spstage3);
		spim:RenderItem(spgames.spstage4);
		spim:RenderItem(spgames.spstage5_bg);
		spim:RenderItem(spgames.spstage5);
	end
	if d.havestage1 then
		self:_RenderStart_Stage1();
	end
	if d.havestage2 then
		self:_RenderStart_Stage2();
	end
	if d.havestage3 then
		self:_RenderStart_Stage3();
	end
	if d.havestage4 then
		self:_RenderStart_Stage4();
	end
	if d.havestage5 then
		self:_RenderStart_Stage5();
	end
end
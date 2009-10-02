function Process:ProcessPause()
	
	d.pausetimer = d.pausetimer + 1;
	if d.pause_resume then
		spim.sprites.pauses.sppause_bg.color = global.ARGB((M_FADETIME - d.pausetimer) * 0xFF / M_FADETIME, 0);
		if d.pausetimer == M_FADETIME then
			self:SetActive(true);
			self:_SetupInputAsReplay(data:GetReplayData(time-1));
			self.state = STATE_START;
			return PTURN;
		end
		return PGO;
	end
	if d.pausetimer == 1 then
		self:_InitProcessPause();
		music:MusicPause();
	end
	
	if hge.Input_GetDIKey(self.keyCancel, DIKEY_DOWN) and not sel:IsSaved(SELSAVE_CONFIRM) or
		hge.Input_GetDIKey(self.keyPause, DIKEY_DOWN) then
		d.pause_resume = true;
		d.pausetimer = 0;
		se:Push(SE_SYSTEM_CANCEL);
		sel:CloseSelection();
		return PGO;
	end
	
	local active, replaying = self:CheckActive();
	local selret;
	selret = sel:Action();
	if selret > 0 and not sel:IsSaved(SELSAVE_CONFIRM) then
		d.pause_selection = selret;
		if selret == 1 then
			d.pause_resume = true;
			d.pausetimer = 0;
			sel:CloseSelection();
			return PGO;
		elseif selret == 2 and not replaying then
			spim.sprites.pauses.spretry.able = true;
		elseif selret == 3 or replaying and selret == 2 then
			spim.sprites.pauses.spbacktotitle.able = true;
		end
		self:_PushSelection(SELSAVE_CONFIRM);
	end
	
	if sel:IsSaved(SELSAVE_PAUSE) then
		if hge.Input_GetDIKey(mp.keyCancel, DIKEY_DOWN) then
			se:Push(SE_SYSTEM_CANCEL);
			sel:CloseSelection();
			self:_ReInitProcessPause();
		end
	end
	
	if sel:IsSaved(SELSAVE_CONFIRM) then
		if sel.saved[SELSAVE_CONFIRM] == 1 then
			time = 0;
			d.pause_resume = false;
			sel:ClearSaved(SELSAVE_CONFIRM);
			if sel.saved[SELSAVE_PAUSE] == 2 and not replaying then
				self.state = STATE_START;
				return PTURN;
			end
			if sel.saved[SELSAVE_PAUSE] == 3 or replaying and sel.saved[SELSAVE_PAUSE] == 2 then
				debugflag = 1;
				return PTITLE;
			end
		else
			self:_ReInitProcessPause();
		end
	end
	
	return PGO;
end

function Process:_InitProcessPause()
	se:Push(SE_SYSTEM_PAUSE);
	if spim.sprites.pauses ~= nil then
		spim:Clear(spim.sprites.pauses);
	end
	spim.sprites.pauses = {};
	spim.sprites.pauses.sppause_bg = spim:Push(true, SI_BLANK_POINT,
		M_CLIENT_CENTER_X, M_CLIENT_CENTER_Y,
		0, M_CLIENT_WIDTH, M_CLIENT_HEIGHT, global.ARGB(0xEF, 0));
	spim.sprites.pauses.spretry = spim:Push(false, SI_RETRY,
		M_CLIENT_CENTER_X, M_CLIENT_CENTER_Y,
		0, 1.5);
	spim.sprites.pauses.spbacktotitle = spim:Push(false, SI_BACKTOTITLE,
		M_CLIENT_CENTER_X, M_CLIENT_CENTER_Y,
		0, 1.5);
	d.pause_selection = 1;
	self:_ReInitProcessPause();
end

function Process:_ReInitProcessPause()
	spim.sprites.pauses.spretry.able = false;
	spim.sprites.pauses.spbacktotitle.able = false;
	sel:ClearSaved(SELSAVE_CONFIRM);
	sel:ClearSaved(SELSAVE_PAUSE);
	self:_PushSelection(SELSAVE_PAUSE, d.pause_selection);
	d.pause_resume = false;
end

function Process:_RenderPause()
	self:_RenderStart();
	if spim.sprites.pauses ~= nil then
		spim:RenderItem(spim.sprites.pauses.sppause_bg);
		spim:RenderItem(spim.sprites.pauses.spretry);
		spim:RenderItem(spim.sprites.pauses.spbacktotitle);
	end
	sel:Render();
end

function Process:_LeavePause()
	spim:Clear(spim.sprites.pauses);
	spim.sprites.pauses = nil;
	d.pause_resume = false;
end
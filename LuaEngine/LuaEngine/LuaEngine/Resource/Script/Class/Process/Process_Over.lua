function Process:ProcessOver()
	
	time = time + 1;
	if time == 1 then
		self:_InitProcessOver();
		self:Dead();
	end
	
	if d.rpysaved then
		local filename = global.ReceiveOpenFileName(export:GetPassword());
		hge.Input_SetDIKey(self.keyCancel);
		data:FreeReplayContent();
	end
	
	local selret;
	selret = sel:Action();
	if selret == 1 and not d.rpysaved and not sel:IsSaved(SELSAVE_CONFIRM) then
		local content, length = data:SaveReplayContent()
		global.SetOpenFileName("Replay File (*.rpy)|*.rpy", "rpy", "Save Replay", export:GetReplayFolder(), content, length);
		d.rpysaved = true;
	end
	if selret > 1 and not sel:IsSaved(SELSAVE_CONFIRM) then
		d.over_selection = selret;
		if selret == 2 then
			spim.sprites.overs.spretry.able = true;
		elseif selret == 3 then
			spim.sprites.overs.spbacktotitle.able = true;
		end
		self:_PushSelection(SELSAVE_CONFIRM);
	end
	
	if sel:IsSaved(SELSAVE_OVER) then
		if hge.Input_GetDIKey(mp.keyCancel, DIKEY_DOWN) then
			se:Push(SE_SYSTEM_CANCEL);
			sel:CloseSelection();
			self:_ReInitProcessOver();
		end
	end
	
	if sel:IsSaved(SELSAVE_CONFIRM) then
		if sel.saved[SELSAVE_CONFIRM] == 1 then
			time = 0;
			sel:ClearSaved(SELSAVE_CONFIRM);
			if sel.saved[SELSAVE_OVER] == 2 then
				self.state = STATE_START;
				return PTURN;
			end
			if sel.saved[SELSAVE_OVER] == 3 then
				debugflag = 1;
				return PTITLE;
			end
		else
			self:_ReInitProcessOver();
		end
	end
	
	return PGO;
end

function Process:_InitProcessOver()
	if spim.sprites.overs ~= nil then
		spim:Clear(spim.sprites.overs);
	end
	spim.sprites.overs = {};
	spim.sprites.overs.spgameover_bg = spim:Push(true, SI_BLANK_POINT,
		M_CLIENT_CENTER_X, M_CLIENT_CENTER_Y,
		0, M_CLIENT_WIDTH, M_CLIENT_HEIGHT, global.ARGB(0xAF, 0));
	spim.sprites.overs.spgameover = spim:Push(true, SI_GAMEOVER,
		M_CLIENT_CENTER_X, M_CLIENT_CENTER_Y - 96,
		0, 4);
	spim.sprites.overs.spretry = spim:Push(false, SI_RETRY,
		M_CLIENT_CENTER_X, M_CLIENT_CENTER_Y,
		0, 1.5);
	spim.sprites.overs.spbacktotitle = spim:Push(false, SI_BACKTOTITLE,
		M_CLIENT_CENTER_X, M_CLIENT_CENTER_Y,
		0, 1.5);
	d.over_selection = 1;
	self:_ReInitProcessOver();
end

function Process:_ReInitProcessOver()
	spim.sprites.overs.spretry.able = false;
	spim.sprites.overs.spbacktotitle.able = false;
	sel:ClearSaved(SELSAVE_CONFIRM);
	sel:ClearSaved(SELSAVE_OVER);
	self:_PushSelection(SELSAVE_OVER, d.over_selection);
	d.rpysaved = false;
end

function Process:_RenderOver()
	self:_RenderStart();
	if spim.sprites.overs ~= nil then
		spim:RenderItem(spim.sprites.overs.spgameover_bg);
		spim:RenderItem(spim.sprites.overs.spgameover);
		spim:RenderItem(spim.sprites.overs.spretry);
		spim:RenderItem(spim.sprites.overs.spbacktotitle);
	end
	sel:Render();
end
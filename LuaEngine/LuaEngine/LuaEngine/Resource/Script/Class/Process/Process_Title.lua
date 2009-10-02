function Process:ProcessTitle()
	
	time = time + 1;
	if time == 1 then
		spim:Clear();
		sel:ClearSaved();
		spim.sprites.titles = {};
		spim.sprites.titles.sptitle = spim:Push(true, SI_TITLE,
			M_CLIENT_CENTER_X, M_CLIENT_CENTER_Y - 96,
			0, 2.5);
		
		self:_PushSelection(SELSAVE_TITLE);
		
	end
	
	if d.rpyloaded then
		local filename, content, length = global.ReceiveOpenFileName(export:GetPassword());
		local failed = false;
		d.rpyloaded = false;
		if filename == nil or filename == "" or length <= 0 or luastate.DWORDToInt(content) == NULL then
			failed = true;
		else
			if data:LoadReplayContent(content, length) <= 0 then
				failed = true;
			end
			hge.Resource_Free(content);
		end
		if failed then
			return PTITLE;
		end
		self:SetActive(true, true);
		time = 0;
		self.state = STATE_START;
		return PTURN;
	end
	
	if hge.Input_GetDIKey(self.keyCancel, DIKEY_DOWN) then
		se:Push(SE_SYSTEM_CANCEL);
		if not sel:IsSaved(SELSAVE_TITLE) then
			if sel.nowindex == 3 then
				return PQUIT;
			end
			sel:MoveToSelection(3, false);
		else
			sel:CloseSelection();
			self:_PushSelection(SELSAVE_TITLE, sel.saved[SELSAVE_TITLE]);
			sel:ClearSaved(SELSAVE_TITLE);
		end
	end
	
	local selret = sel:Action();
	if not sel:IsSaved(SELSAVE_DIFFICULT) then
		if selret == 1 then
			self:_PushSelection(SELSAVE_DIFFICULT, self.nowdifflv);
		elseif selret == 2 then
			global.SetOpenFileName("Replay File (*.rpy)|*.rpy", "rpy", "Load Replay", export:GetReplayFolder());
			d.rpyloaded = true;
		elseif selret == 3 then
			return PQUIT;
		end
	end
	
	if sel:IsSaved(SELSAVE_DIFFICULT) then
		self:SetActive(true, false);
		time = 0;
		self.state = STATE_START;
		return PTURN;
	end
	
	return PGO;
end

function Process:_PreInitTitle()
	self:SetActive(false, false);
	data:ClearReplayData();
end

function Process:_RenderTitle()
	spim:RenderItem(spim.sprites.titles.sptitle);
	sel:Render();
end
function Selector:PushSelector(spriteid, x, y, scalefactor)
	local tindex = table.getn(self.selinfo) + 1;
	self.selinfo[tindex] = spim:Push(true, spriteid, x, y, 0, 1);
	if scalefactor == nil then
		scalefactor = 1.0;
	end
	self.selinfo[tindex].scalefactor = scalefactor;
	self.alpha = 0;
end

function Selector:ClearSaved(saveas)
	if saveas ~= nil then
		self.saved[saveas] = nil;
		return;
	end
	for i, it in pairs(self.saved) do
		self.saved[i] = nil;
	end
end

function Selector:IsSaved(saveas)
	return self.saved[saveas] ~= nil;
end

function Selector:NewSelection(defaultindex, saveas)
	self.selnum = table.getn(self.selinfo);
	if defaultindex == nil or defaultindex < 1 or defaultindex > self.selnum then
		defaultindex = 1;
	end
	self.nowindex = defaultindex;
	self.saveas = saveas;
	self.able = true;
	self.timer = 0;
	self.exiting = false;
end

function Selector:CloseSelection()
	self.able = false;
	spim:Clear(self.selinfo);
	self.selinfo = {};
end

function Selector:_DeleteSelection()
	if self.saveas ~= nil and self.saveas >= 1 then
		self.saved[self.saveas] = self.nowindex;
	end
	self:CloseSelection();
	return self.nowindex;
end

function Selector:MoveToSelection(selindex, bplayse)
	self:_MoveSelection(selindex-self.nowindex, bplayse);
end

function Selector:_MoveSelection(nmove, bplayse)
	self.nowindex = self.nowindex + nmove;
	if self.nowindex > self.selnum then
		self.nowindex = 1;
	elseif self.nowindex <= 0 then
		self.nowindex = self.selnum;
	end
	self.timer = M_FADETIME;
	if bplayse == nil or bplayse == true then
		se:Push(SE_SYSTEM_SELECT);
	end
end

function Selector:_UpdatePushKey(key1, key2)
	if hge.Input_GetDIKey(key1) or hge.Input_GetDIKey(key2) then
		self.pushtimer = self.pushtimer + 1;
		if self.pushtimer == M_PUSH_FIRST then
			self.pushtimer = M_PUSH_ROLLTO;
		end
		if self.pushtimer == M_PUSH_ROLLTO then
			hge.Input_SetDIKey(key1, false);
			hge.Input_SetDIKey(key2, false);
			return true;
		end
	else
		self.pushtimer = 0;
	end
	return false;
end

function Selector:Action()
	self.timer = self.timer + 1;
	if self.timer <= M_FADETIME then
		self.alpha = 0xff * self.timer / M_FADETIME;
	else
		self.alpha = 0xff;
	end
	if self.exiting then
		if self.timer >= M_FADETIME then
			return self:_DeleteSelection();
		end
		self.alpha = 0xff - self.alpha;
		return 0;
	end
	
	self:_UpdatePushKey(mp.keyDown, mp.keyUp);
	if hge.Input_GetDIKey(mp.keyDown, DIKEY_DOWN) then
		self:_MoveSelection(1);
	elseif hge.Input_GetDIKey(mp.keyUp, DIKEY_DOWN) then
		self:_MoveSelection(-1);
	end
	
	if hge.Input_GetDIKey(mp.keyEnter, DIKEY_DOWN) then
		self.exiting = true;
		self.timer = 0;
		se:Push(SE_SYSTEM_OK);
	end
	
	local tscale = global.ROLL(self.timer, M_FADETIME) / M_FADETIME / 4 + 1.0;
	for i, it in pairs(self.selinfo) do
		if self.nowindex == i then
			it.hscale = tscale * it.scalefactor;
		else
			it.hscale = it.scalefactor;
		end
	end
	return 0;
end

function Selector:Render()
	if not self.able then
		return;
	end
	for i, it in pairs(self.selinfo) do
		spim:RenderItem(it);
	end
end
function Process:Frame()
	
	if hge.Input_GetKeyState(HGEK_ALT) and hge.Input_GetKeyState(HGEK_ENTER) then
		mp.screenmode = not mp.screenmode;
		hge.System_SetState(HGE_WINDOWED, not mp.screenmode);
		hge.System_SetState(HGE_HIDEMOUSE, mp.screenmode);
	end
	
	local retval = PTITLE;
	retval = self:GetInput();
	if retval == PGO then
		if self.state == STATE_START then
			retval = self:ProcessStart();
		elseif self.state == STATE_PAUSE then
			retval = self:ProcessPause();
			if retval ~= PGO then
				self:_LeavePause();
			end
		elseif self.state == STATE_TITLE then
			retval = self:ProcessTitle();
		elseif self.state == STATE_INIT then
			retval = self:ProcessInit();
		elseif self.state == STATE_OVER then
			retval = self:ProcessOver();
		end
	else
		debugflag = 1;
	end
	
	self:_FrameEnd();
	
	if retval == PTITLE then
		self:_PreInitTitle();
		time = 0;
		self.state = STATE_TITLE;
		retval = PTURN;
	end
	
	if retval == PTURN then
		return PTURN;
	end
	
	if retval == PQUIT then
		return PQUIT;
	end
	
	return PGO;
end

function Process:_FrameEnd()
	se:Play();
end
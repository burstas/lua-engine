function Process:GetInput()
		
	if hge.Input_GetDIKey(self.keyBGMDown) then
		if self.bgmvol > 0 then
			self.bgmvol = self.bgmvol - 1;
		end
		d.displaybgmchange = M_DISPLAYTIME;
		music:SetVolume();
	end
	if hge.Input_GetDIKey(self.keyBGMUp) then
		if self.bgmvol < 100 then
			self.bgmvol = self.bgmvol + 1;
		end
		d.displaybgmchange = M_DISPLAYTIME;
		music:SetVolume();
	end
	if hge.Input_GetDIKey(self.keySEDown) then
		if self.sevol > 0 then
			self.sevol = self.sevol - 1;
		end
		d.displaysechange = M_DISPLAYTIME;
	end
	if hge.Input_GetDIKey(self.keySEUp) then
		if self.sevol < 100 then
			self.sevol = self.sevol + 1;
		end
		d.displaysechange = M_DISPLAYTIME;
	end
	
	local active, replaying = self:CheckActive();
	if hge.Input_GetDIJoy(self.joySpace) then
		hge.Input_SetDIKey(self.keySpace);
	end
	if hge.Input_GetDIJoy(self.joyPause) then
		hge.Input_SetDIKey(self.keyPause);
	end
	if hge.Input_GetDIJoy(self.joyEnter) then
		hge.Input_SetDIKey(self.keyEnter);
	end
	if hge.Input_GetDIJoy(self.joyCancel) then
		hge.Input_SetDIKey(self.keyCancel);
	end
	
	if hge.Input_GetDIKey(self.keyPause, DIKEY_DOWN) then
		if active and self.state == STATE_START then
			data:UpdateReplayHeader();
			d.pausetimer = 0;
			self.state = STATE_PAUSE;
			self:SetActive(false);
			return PTURN;
		end
	end
	if active and replaying then
			
		if hge.Input_GetDIKey(self.keySkip) or
			hge.Input_GetDIJoy(self.joySpeedUp) then
			hge.System_SetState(HGE_FRAMESKIP, M_FASTFRAMESKIP);
		else
			hge.System_SetState(HGE_FRAMESKIP, M_DEFAULT_FRAMESKIP);
		end
		
		local rpydata;
		if self.state ~= STATE_OVER then
			rpydata = data:GetReplayData();
		else
			rpydata = data:GetReplayData(-1);
		end
		if luastate.And(rpydata, M_BITTEST_12) > 0 then
			self:Dead();
			self:SetActive(false, false);
			data:ClearReplayData();
			return PTITLE;
		end
		self:_SetupInputAsReplay(rpydata);
		d.replayfps = luastate.RShift(rpydata, 12) / 200;
		return PGO;
	end
	
	if hge.Input_GetDIJoy(JOY_LEFT) then
		hge.Input_SetDIKey(self.keyLeft);
	end
	if hge.Input_GetDIJoy(JOY_RIGHT) then
		hge.Input_SetDIKey(self.keyRight);
	end
	if hge.Input_GetDIJoy(JOY_UP) then
		hge.Input_SetDIKey(self.keyUp);
	end
	if hge.Input_GetDIJoy(JOY_DOWN) then
		hge.Input_SetDIKey(self.keyDown);
	end
	
	if hge.Input_GetDIJoy(self.joyA) then
		hge.Input_SetDIKey(self.keyA);
	end
	if hge.Input_GetDIJoy(self.joyS) then
		hge.Input_SetDIKey(self.keyS);
	end
	if hge.Input_GetDIJoy(self.joyD) then
		hge.Input_SetDIKey(self.keyD);
	end
	if hge.Input_GetDIJoy(self.joyZ) then
		hge.Input_SetDIKey(self.keyZ);
	end
	if hge.Input_GetDIJoy(self.joyX) then
		hge.Input_SetDIKey(self.keyX);
	end
	if hge.Input_GetDIJoy(self.joyC) then
		hge.Input_SetDIKey(self.keyC);
	end
	
	if active then
		local nowinput = 0;
		if hge.Input_GetDIKey(self.keyLeft) then
			nowinput = luastate.Or(nowinput, luastate.LShift(1, 0));
		end
		if hge.Input_GetDIKey(self.keyRight) then
			nowinput = luastate.Or(nowinput, luastate.LShift(1, 1));
		end
		if hge.Input_GetDIKey(self.keyUp) then
			nowinput = luastate.Or(nowinput, luastate.LShift(1, 2));
		end
		if hge.Input_GetDIKey(self.keyDown) then
			nowinput = luastate.Or(nowinput, luastate.LShift(1, 3));
		end
		if hge.Input_GetDIKey(self.keyA) then
			nowinput = luastate.Or(nowinput, luastate.LShift(1, 4));
		end
		if hge.Input_GetDIKey(self.keyS) then
			nowinput = luastate.Or(nowinput, luastate.LShift(1, 5));
		end
		if hge.Input_GetDIKey(self.keyD) then
			nowinput = luastate.Or(nowinput, luastate.LShift(1, 6));
		end
		if hge.Input_GetDIKey(self.keyZ) then
			nowinput = luastate.Or(nowinput, luastate.LShift(1, 7));
		end
		if hge.Input_GetDIKey(self.keyX) then
			nowinput = luastate.Or(nowinput, luastate.LShift(1, 8));
		end
		if hge.Input_GetDIKey(self.keyC) then
			nowinput = luastate.Or(nowinput, luastate.LShift(1, 9));
		end
		if hge.Input_GetDIKey(self.keySpace) then
			nowinput = luastate.Or(nowinput, luastate.LShift(1, 10));
		end
		nowinput = luastate.Or(nowinput, luastate.LShift(hge.Timer_GetFPS() * 200, 12));
		if self.state == STATE_OVER then
			nowinput = luastate.Or(nowinput, luastate.LShift(1, 11));
			self:SetActive(false, false);
			data:PushReplayData(nowinput, -1);
		elseif time > 0 then
			data:PushReplayData(nowinput);
			data:UpdateReplayHeader(hge.Timer_GetDelta());
		end
	end
	return PGO;
end

function Process:_SetupInputAsReplay(rpydata)
	hge.Input_SetDIKey(self.keyLeft, luastate.And(rpydata, M_BITTEST_1) > 0);
	hge.Input_SetDIKey(self.keyRight, luastate.And(rpydata, M_BITTEST_2) > 0);
	hge.Input_SetDIKey(self.keyUp, luastate.And(rpydata, M_BITTEST_3) > 0);
	hge.Input_SetDIKey(self.keyDown, luastate.And(rpydata, M_BITTEST_4) > 0);
	hge.Input_SetDIKey(self.keyA, luastate.And(rpydata, M_BITTEST_5) > 0);
	hge.Input_SetDIKey(self.keyS, luastate.And(rpydata, M_BITTEST_6) > 0);
	hge.Input_SetDIKey(self.keyD, luastate.And(rpydata, M_BITTEST_7) > 0);
	hge.Input_SetDIKey(self.keyZ, luastate.And(rpydata, M_BITTEST_8) > 0);
	hge.Input_SetDIKey(self.keyX, luastate.And(rpydata, M_BITTEST_9) > 0);
	hge.Input_SetDIKey(self.keyC, luastate.And(rpydata, M_BITTEST_10) > 0);
	hge.Input_SetDIKey(self.keySpace, luastate.And(rpydata, M_BITTEST_11) > 0);
end
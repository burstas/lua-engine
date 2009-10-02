function Process:Dead()
	local name, difficult, stage, seed, lifetime, pausetime, score = data:GetReplayHeader();
	local frames = data:GetReplayLength();
	local difficultstr = "";
	if difficult == 1 then
		difficultstr = "Easy";
	elseif difficult == 2 then
		difficultstr = "Normal";
	elseif difficult == 3 then
		difficultstr = "Hard";
	elseif difficult == 4 then
		difficultstr = "h5nc";
	end
	local pausestr = "";
	if pausetime == 0 then
		pausestr = "No pause was recorded.";
	elseif pausetime == 1 then
		pausestr = "1 pause was recorded.";
	else
		pausestr = pausetime.." pauses were recorded.";
	end
	global.MessageBoxEx(name..", whose life lasted for "..(lifetime/M_INTTIMEFACTOR).." seconds ("..frames.." frames), has dead peacefully in challenging "..difficultstr.." level.\r\n\r\nTotal Score: "..score..".\r\n\r\nDuring the whole life, "..pausestr, "Congratulations!");
end

function Process:SnapShot()
	hge.System_Snapshot();
end

function Process:SetActive(bActive, bReplaying)
	self.active = bActive;
	if bReplaying ~= nil  then
		self.replaying = bReplaying;
	end
end

function Process:CheckActive()
	return self.active, self.replaying;
end

function Process:_PushSelection(selsave, defaultsel)
	if defaultsel == nil then
		defaultsel = 1;
	end
	if selsave == SELSAVE_TITLE then
		sel:PushSelector(SI_GAMESTART, M_CLIENT_CENTER_X, M_CLIENT_CENTER_Y + 48, 1.5);
		sel:PushSelector(SI_REPLAY, M_CLIENT_CENTER_X, M_CLIENT_CENTER_Y + 120, 1.5);
		sel:PushSelector(SI_EXIT, M_CLIENT_CENTER_X, M_CLIENT_CENTER_Y + 192, 1.5);
		sel:NewSelection(defaultsel, selsave);
	elseif selsave == SELSAVE_DIFFICULT then
		sel:PushSelector(SI_EASY, M_CLIENT_CENTER_X, M_CLIENT_CENTER_Y + 48, 1.5);
		sel:PushSelector(SI_NORMAL, M_CLIENT_CENTER_X, M_CLIENT_CENTER_Y + 88, 1.5);
		sel:PushSelector(SI_HARD, M_CLIENT_CENTER_X, M_CLIENT_CENTER_Y + 128, 1.5);
		sel:PushSelector(SI_h5nc, M_CLIENT_CENTER_X, M_CLIENT_CENTER_Y + 168, 1.5);
		sel:NewSelection(defaultsel, selsave);
	elseif selsave == SELSAVE_PAUSE then
		local active, replaying = self:CheckActive();
		sel:PushSelector(SI_RESUME, M_CLIENT_CENTER_X, M_CLIENT_CENTER_Y, 1.5);
		local offset = 48;
		if not replaying then
			sel:PushSelector(SI_RETRY, M_CLIENT_CENTER_X, M_CLIENT_CENTER_Y + 48, 1.5);
			offset = 96;
		end
		sel:PushSelector(SI_BACKTOTITLE, M_CLIENT_CENTER_X, M_CLIENT_CENTER_Y + offset, 1.5);
		sel:NewSelection(defaultsel, selsave);
	elseif selsave == SELSAVE_OVER then
		sel:PushSelector(SI_SAVEREPLAY, M_CLIENT_CENTER_X, M_CLIENT_CENTER_Y, 1.5);
		sel:PushSelector(SI_RETRY, M_CLIENT_CENTER_X, M_CLIENT_CENTER_Y + 48, 1.5);
		sel:PushSelector(SI_BACKTOTITLE, M_CLIENT_CENTER_X , M_CLIENT_CENTER_Y + 96, 1.5);
		sel:NewSelection(defaultsel, selsave);
	elseif selsave == SELSAVE_CONFIRM then
		sel:PushSelector(SI_YES, M_CLIENT_CENTER_X, M_CLIENT_CENTER_Y + 48, 1.5);
		sel:PushSelector(SI_NO, M_CLIENT_CENTER_X, M_CLIENT_CENTER_Y + 96, 1.5);
		sel:NewSelection(defaultsel, selsave);
	end
end
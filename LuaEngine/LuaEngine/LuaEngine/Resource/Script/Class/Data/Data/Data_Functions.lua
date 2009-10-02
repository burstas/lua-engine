function Data:_StringToDWORD(str)
	local dret1 = 0;
	local dret2 = 0;
	local dret3 = 0;
	local dret4 = 0;
	for i=1, string.len(str) do
		if i <= 3 then
			dret1 = luastate.LShift(string.byte(str, i), (i-1) * 8) + dret1;
		elseif i <= 6 then
			dret2 = luastate.LShift(string.byte(str, i), (i-4) * 8) + dret2;
		elseif i <= 9 then
			dret3 = luastate.LShift(string.byte(str, i), (i-7) * 8) + dret3;
		elseif i <= 12 then
			dret4 = luastate.LShift(string.byte(str, i), (i-10) * 8) + dret4;
		end
	end
	return dret1, dret2, dret3, dret4;
end

function Data:_DWORDToString(d1, d2, d3, d4)
	local sret = "";
	local tbyte = 0;
	local i = 0;
	repeat
		i = i + 1;
		local tshift;
		if i <= 3 then
			tshift = (i-1) * 8;
			tbyte = luastate.RShift(luastate.And(d1, luastate.LShift(0xFF, tshift)), tshift);
		elseif i <= 6 then
			tshift = (i-4) * 8;
			tbyte = luastate.RShift(luastate.And(d2, luastate.LShift(0xFF, tshift)), tshift);
		elseif i <= 9 then
			tshift = (i-7) * 8;
			tbyte = luastate.RShift(luastate.And(d3, luastate.LShift(0xFF, tshift)), tshift);
		elseif i <= 12 then
			tshift = (i-10) * 8;
			tbyte = luastate.RShift(luastate.And(d4, luastate.LShift(0xFF, tshift)), tshift);
		end
		if tbyte == 0 then
			break;
		end
		sret = sret..string.char(tbyte);
	until tbyte == 0;
	return sret;
end

function Data:PushReplayHeader(name, difficult, stage, seed)
	self.rpyheader.sign = self:_StringToDWORD(M_REPLAYSIGN);
	self.rpyheader.magicnumber = M_REPLAYMAGICNUMBER;
	self.rpyheader.name[1], self.rpyheader.name[2], self.rpyheader.name[3], self.rpyheader.name[4] = self:_StringToDWORD(name);
	self.rpyheader.diffstage = luastate.LShift(difficult, 16) + stage;
	self.rpyheader.seed = seed;
	self.rpyheader.lifetime = 0;
	self.rpyheader.pausetime = 0;
	self.rpyheader.score = 0;
end

function Data:SetDifficultScoreFactor(difficult)
	self.dt.difficultscorefactor = math.pow(1.5, difficult);
end

function Data:GetDifficultScoreFactor()
	return self.dt.difficultscorefactor;
end

function Data:UpdateReplayHeader(lifetime)
	if lifetime == nil then
		self.rpyheader.pausetime = self.rpyheader.pausetime + 1;
	else
		self.rpyheader.lifetime = self.rpyheader.lifetime + math.floor(lifetime * M_INTTIMEFACTOR);
	end
end

function Data:GetNowLifeTime()
	if self.rpyheader.lifetime == nil then
		return 0;
	end
	return self.rpyheader.lifetime;
end

function Data:UpdateScore(score, timer)
	if score ~= nil and score > 0 then
		local addscore = 0;
		if timer == nil then
			addscore = score * M_SCOREPERTIME;
		else
			addscore = score * math.floor(timer / 600);
		end
		addscore = addscore * data:GetDifficultScoreFactor();
		self.rpyheader.score = math.floor(self.rpyheader.score + addscore);
	end
end

function Data:GetNowScore(score)
	if self.rpyheader.score == nil then
		return 0;
	end
	return self.rpyheader.score;
end

function Data:PushReplayData(data, index)
	if index == nil then
		index = time;
	end
	if index < 0 then
		index = table.getn(self.rpydata) + 1;
	end
	if index > 0 then
		self.rpydata[index] = data;
	end
end

function Data:GetReplayHeader()
	local name = self:_DWORDToString(self.rpyheader.name[1], self.rpyheader.name[2], self.rpyheader.name[3], self.rpyheader.name[4]);
	local difficult = luastate.RShift(self.rpyheader.diffstage, 16);
	local stage = luastate.And(self.rpyheader.diffstage, 0xFFFF);
	return name, difficult, stage, self.rpyheader.seed, self.rpyheader.lifetime, self.rpyheader.pausetime, self.rpyheader.score;
end

function Data:GetReplayData(index)
	if index == nil then
		index = time;
	end
	if index < 0 then
		index = table.getn(self.rpydata);
	end
	return self.rpydata[index];
end

function Data:ClearReplayData()
	self.rpyheader = {};
	self.rpyheader.name = {};
	self.rpydata = {};
	self:FreeReplayContent();
end

function Data:SaveReplayContent()
	self.replaylength = self.headerlength + table.getn(self.rpydata) * 4;
	self.replaycontent = global.Malloc(self.replaylength);
	local nowoffset = 0;
	global.WriteMemory(self.replaycontent, nowoffset, self.rpyheader.sign);
	nowoffset	= nowoffset + 4;
	global.WriteMemory(self.replaycontent, nowoffset, self.rpyheader.magicnumber);
	nowoffset	= nowoffset + 4;
	global.WriteMemory(self.replaycontent, nowoffset, self.rpyheader.name[1]);
	nowoffset	= nowoffset + 4;
	global.WriteMemory(self.replaycontent, nowoffset, self.rpyheader.name[2]);
	nowoffset	= nowoffset + 4;
	global.WriteMemory(self.replaycontent, nowoffset, self.rpyheader.name[3]);
	nowoffset	= nowoffset + 4;
	global.WriteMemory(self.replaycontent, nowoffset, self.rpyheader.name[4]);
	nowoffset	= nowoffset + 4;
	global.WriteMemory(self.replaycontent, nowoffset, self.rpyheader.diffstage);
	nowoffset	= nowoffset + 4;
	global.WriteMemory(self.replaycontent, nowoffset, self.rpyheader.seed);
	nowoffset	= nowoffset + 4;
	global.WriteMemory(self.replaycontent, nowoffset, self.rpyheader.lifetime);
	nowoffset	= nowoffset + 4;
	global.WriteMemory(self.replaycontent, nowoffset, self.rpyheader.pausetime);
	nowoffset	= nowoffset + 4;
	global.WriteMemory(self.replaycontent, nowoffset, self.rpyheader.score);
	nowoffset	= nowoffset + 4;
	for i, it in pairs(self.rpydata) do
		if i > 0 then
			global.WriteMemory(self.replaycontent, self.headerlength + (i-1) * 4, it);
		end
	end
	return self.replaycontent, self.replaylength;
end

function Data:LoadReplayContent(content, length)
	if length < self.headerlength then
		return -1;
	end
	self:ClearReplayData();
	local nowoffset = 0;
	self.rpyheader.sign = global.ReadMemory(content, nowoffset);
	nowoffset = nowoffset + 4;
	if self.rpyheader.sign ~= self:_StringToDWORD(M_REPLAYSIGN) then
		return -1;
	end
	self.rpyheader.magicnumber = global.ReadMemory(content, nowoffset);
	nowoffset = nowoffset + 4;
	if self.rpyheader.magicnumber ~= M_REPLAYMAGICNUMBER then
		return -1;
	end
	self.rpyheader.name[1] = global.ReadMemory(content, nowoffset);
	nowoffset = nowoffset + 4;
	self.rpyheader.name[2] = global.ReadMemory(content, nowoffset);
	nowoffset = nowoffset + 4;
	self.rpyheader.name[3] = global.ReadMemory(content, nowoffset);
	nowoffset = nowoffset + 4;
	self.rpyheader.name[4] = global.ReadMemory(content, nowoffset);
	nowoffset = nowoffset + 4;
	self.rpyheader.diffstage = global.ReadMemory(content, nowoffset);
	nowoffset = nowoffset + 4;
	self.rpyheader.seed = global.ReadMemory(content, nowoffset);
	nowoffset = nowoffset + 4;
	self.rpyheader.lifetime = global.ReadMemory(content, nowoffset);
	nowoffset = nowoffset + 4;
	self.rpyheader.pausetime = global.ReadMemory(content, nowoffset);
	nowoffset = nowoffset + 4;
	self.rpyheader.score = global.ReadMemory(content, nowoffset);
	nowoffset = nowoffset + 4;
	
	if nowoffset >= length then
		return 0;
	end
	
	local index = 1;
	repeat
		self.rpydata[index] = global.ReadMemory(content, nowoffset);
		index = index + 1;
		nowoffset = nowoffset + 4;
	until nowoffset >= length;
	return index - 1;
end

function Data:FreeReplayContent()
	if self.replaycontent ~= NULL then
		global.Free(self.replaycontent);
		self.replaycontent = NULL;
	end
	self.replaylength = 0;
end

function Data:GetReplayLength()
	return table.getn(self.rpydata);
end
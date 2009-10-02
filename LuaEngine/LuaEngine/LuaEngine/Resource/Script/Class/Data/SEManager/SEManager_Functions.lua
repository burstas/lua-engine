function SEManager:Init(tablefilename)
	if tablefilename == nil or tablefilename == "" then
		return;
	end
	local tabledata = {};
	local linecount;
	
	tabledata, linecount = tablefile:GetTableFileData(tablefilename, "nssffff");
	local seindex;
	for i=1, linecount do
		seindex = tabledata[1][i];
		self.filename[seindex] = tabledata[3][i];
		self.se[seindex] = hge.Effect_Load(self.filename[seindex]);
		luastate.SetConst(tabledata[2][i], seindex);
	end
end

function SEManager:Push(seindex, xpos)
	if self.playlist[seindex] == nil then
		self.playlist[seindex] = {};
		self.playlist[seindex].counter = 0;
		self.playlist[seindex].sum = 0;
	end
	self.playlist[seindex].counter = self.playlist[seindex].counter + 1;
	if xpos ~= nil then
		self.playlist[seindex].sum = self.playlist[seindex].sum + xpos - M_CLIENT_CENTER_X;
	end
end

function SEManager:Play()
	for i, it in pairs(self.playlist) do
		if it.counter > 0 then
			local pan = it.sum / it.counter * M_SE_PAN;
			if it.channel ~= nil and hge.Channel_IsPlaying(it.channel) then
				hge.Channel_SetPos(it.channel, 0);
			else
				it.channel = hge.Effect_PlayEx(self.se[i], mp.sevol, pan);
			end
			it.counter = 0;
			it.sum = 0;
		end
	end
end

function SEManager:Stop(seindex)
	local seitem = self.playlist[seindex];
	if seitem ~= nil and seitem.channel ~= nil then
		hge.Channel_Stop(seitem.channel);
	end
end
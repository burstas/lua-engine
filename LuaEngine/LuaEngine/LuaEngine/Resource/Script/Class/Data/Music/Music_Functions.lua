function Music:Init(tablefilename)
	if tablefilename == nil or tablefilename == "" then
		return;
	end
	local tabledata = {};
	local linecount;
	
	tabledata, linecount = tablefile:GetTableFileData(tablefilename, "nssqqq");
	local musicindex;
	for i=1, linecount do
		musicindex = tabledata[1][i];
		self.filename[musicindex] = tabledata[3][i];
		self.stream[musicindex] = hge.Stream_Load(self.filename[musicindex]);
		luastate.SetConst(tabledata[2][i], self.stream[musicindex]);
		self.startpos[musicindex] = tabledata[4][i];
		self.introlength[musicindex] = tabledata[5][i];
		self.alllength[musicindex] = tabledata[6][i];
	end
end

function Music:MusicSlide(slidetime, tovol, topan, topitch)
	if hge.Channel_IsPlaying(self.channel) then
		if tovol == nil or tovol < 0 then
			tovol = 0;
		end
		if topan == nil then
			topan = M_DEFAULT_PAN;
		end
		if topitch == nil then
			topitch = M_DEFAULT_PITCH;
		end
		hge.Channel_SlideTo(self.channel, slidetime, tovol, topan, topitch);
	end
end

function Music:MusicPause()
	if hge.Channel_IsPlaying(self.channel) then
		hge.Channel_Pause(self.channel);
	end
end

function Music:MusicResume()
	if not hge.Channel_IsPlaying(self.channel) then
		hge.Channel_Resume(self.channel);
	end
end

function Music:MusicChange(stream, bforce)
	if stream == nil then
		stream = 0;
	end
	if bforce == nil then
		bforce = false;
	end
	
	if stream == 0 then
		hge.Channel_RemoveLoop(self.channel);
		hge.Channel_Stop(self.channel);
		return;
	end
	if hge.Channel_IsPlaying(self.channel) == false or self.nowstream ~= stream or bforce then
		self.nowstream = stream;
		if self.channel ~= NULL then
			self:MusicSlide(0, mp.bgmvol);
			hge.Channel_Stop(self.channel);
		end
		self.channel = hge.Stream_Play(stream, true, mp.bgmvol);
		hge.Channel_SetPitch(self.channel, 1.0);
		local startpos;
		local introlength;
		local alllength;
		startpos, introlength, alllength = self:_GetSyncInfo(stream);
		hge.Channel_SetLoop(self.channel, startpos, introlength, alllength);
		hge.Channel_SetStartPos(self.channel);
	end
end

function Music:SetVolume(vol)
	if vol == nil then
		vol = mp.bgmvol;
	end
	hge.Channel_SetVolume(self.channel, vol);
end

function Music:_GetSyncInfo(stream)
	for i in pairs(self.stream) do
		if self.stream[i] == stream then
			return self.startpos[i], self.introlength[i], self.alllength[i];
		end
	end
end
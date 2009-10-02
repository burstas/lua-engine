Music	=	{
				}

function Music:new(t)
    local t = t or {};
    self.__index = self;
    setmetatable( t, self );
    t:_Init();
    return t;
end

function Music:_Init()
	self.channel = NULL;
	self.nowstream = 0;
	self.stream = {};
	self.filename	=	{};
	self.startpos = {};
	self.introlength = {};
	self.alllength = {};
end

function Music:Release()
	for i in pairs(self.stream) do
		if self.stream[i] ~= nil and self.stream[i] ~= NULL then
			hge.Stream_Free(self.stream[i]);
		end
	end
	if self.channel ~= NULL then
		if hge.Channel_IsSliding(self.channel) then
			hge.Channel_SlideTo(self.channel, 0, mp.bgmvol, -1, -1);
		end
		hge.Channel_Stop(self.channel);
	end
	self:_Init();
end

music = Music:new();
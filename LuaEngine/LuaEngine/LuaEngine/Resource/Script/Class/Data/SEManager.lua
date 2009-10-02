SEManager	=	{
			}

function SEManager:new(t)
    local t = t or {};
    self.__index = self;
    setmetatable( t, self );
    t:_Init();
    return t;
end

function SEManager:_Init()
	self.se = {};
	self.filename	=	{};
	self.playlist = {};
end

function SEManager:Release()
	for i in pairs(self.se) do
		if self.se[i] ~= nil and self.se[i] ~= NULL then
			hge.Effect_Free(self.se[i]);
		end
	end
	self:_Init();
end

se = SEManager:new();
Data	=	{
				}

function Data:new(t)
    local t = t or {};
    self.__index = self;
    setmetatable( t, self );
    t:_Init();
    return t;
end

function Data:_Init()
	self.dt = {};
	self.rpyheader = {}
	self.rpyheader.name = {};
	self.rpydata = {};
	self.headerlength = 44;
	self.replaycontent = NULL;
	self.replaylength = 0;
	d = self.dt;
end

function Data:Init(filename)
	self.filename = hge.Resource_MakePath(filename);
end

function Data:Release()
	self:_Init();
	self:ClearReplayData();
end

data = Data:new();
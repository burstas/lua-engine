Selector	=	{
						}

function Selector:new(t)
    local t = t or {};
    self.__index = self;
    setmetatable( t, self );
    t:_Init()
    return t;
end

function Selector:_Init()
	self.selinfo = {};
	self.saved = {};
	self.selnum = 0;
	self.timer = 0;
	self.alpha = 0;
	self.saveas = 0;
	self.exiting = false;
	self.nowindex = 0;
	self.pushtimer = 0;
	self.able = false;
end

sel = Selector:new();
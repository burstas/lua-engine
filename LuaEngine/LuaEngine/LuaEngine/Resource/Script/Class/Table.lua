Table	=	{
				}

function Table:new(t)
    local t = t or {};
    self.__index = self;
    setmetatable( t, self );
    return t;
end

tablefile = Table:new();
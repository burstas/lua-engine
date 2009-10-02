Export	=	{
					}

function Export:new(t)
    local t = t or {};
    self.__index = self;
    setmetatable( t, self );
    return t;
end

export = Export:new();
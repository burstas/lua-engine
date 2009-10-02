Texture	=	{
					}

function Texture:new(t)
    local t = t or {};
    self.__index = self;
    setmetatable( t, self );
    t:_Init();
    return t;
end

function Texture:_Init()
	self.tex = {};
	self.filename = {};
	hgeEX.SetTextureNumber(0);
end

function Texture:Release()
	for i in pairs(self.tex) do
		if self.tex[i] ~= nil and self.tex[i] ~= NULL then
			hge.Texture_Free(self.tex[i]);
		end
	end
	self:_Init();
end

tex = Texture:new();
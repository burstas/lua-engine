function SpriteItemManager:NewSprite(siindex)
	return hgeSprite.NewSprite(self.tex[siindex], self.texx[siindex], self.texy[siindex], self.texw[siindex], self.texh[siindex]);
end

function SpriteItemManager:Init(tablefilename)
	if tablefilename == nil or tablefilename == "" then
		return;
	end
	local tabledata = {};
	local linecount;
	
	tabledata, linecount = tablefile:GetTableFileData(tablefilename, "nssffff");
	local siindex;
	local texw;
	local texh;
	local oritexw;
	local oritexh;
	for i=1, linecount do
		siindex = tabledata[1][i];
		luastate.SetConst(tabledata[2][i], siindex);
		self.tex[siindex] = luastate.GetConst(tabledata[3][i]);
		self.texx[siindex] = tabledata[4][i];
		self.texy[siindex] = tabledata[5][i];
		texw = tabledata[6][i];
		texh = tabledata[7][i];
		if texw < 0 or texh < 0 then
			oritexw, oritexh = hge.Texture_GetWH(self.tex[siindex]);
			if texw < 0 then
				texw = oritexw;
			end
			if texh < 0 then
				texh = oritexh;
			end
		end
		self.texw[siindex] = texw;
		self.texh[siindex] = texh;
	end
end

function SpriteItemManager:Push(_able, spriteindex, _x, _y, _rot, _hscale, _vscale, _color)
	local spriteitem = 
		{
			sprite = self:NewSprite(spriteindex);
			able = _able;
			x = _x;
			y = _y;
			rot = _rot;
			hscale = _hscale;
			vscale = _vscale;
			color = _color;
		}
	return spriteitem;
end

function SpriteItemManager:Clear(items)
	if items == nil then
		items = self.sprites;
	end
	for i, it in pairs(items) do
		if it ~= nil then
			if it.sprite == nil then
				self:Clear(it);
			else
				hgeSprite.DeleteSprite(it.sprite);
				it.sprite = NULL;
				it = {};
			end
		end
		it = nil;
	end
	items = nil;
end

function SpriteItemManager:RenderItem(spriteitem)
	if spriteitem == nil then
		return;
	end
	if spriteitem.able then
		if spriteitem.color ~= nil then
			hgeSprite.SetColor(spriteitem.sprite, spriteitem.color);
		end
		hgeSprite.RenderEx(spriteitem.sprite, spriteitem.x, spriteitem.y, spriteitem.rot, spriteitem.hscale, spriteitem.vscale);
	end
end

function SpriteItemManager:RenderItemAs(spriteitem, _x, _y, _rot, _hscale, _vscale, _color)
	if spriteitem == nil then
		return;
	end
	local item = {};
	spriteitem.__index = spriteitem;
	setmetatable( item, spriteitem );
	if _x ~= nil then
		item.x = _x;
	end
	if _y ~= nil then
		item.y = _y;
	end
	if _rot ~= nil then
		item.rot = _rot;
	end
	if _hscale ~= nil then
		item.hscale = _hscale;
	end
	if _vscale ~= nil then
		item._vscale = _vscale;
	end
	item.able = true;
	self:RenderItem(item);
end
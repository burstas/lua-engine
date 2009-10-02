function EffectManager:NewES(effindex, sptex)
	if sptex == nil then
		sptex = NULL;
	end
	return hgeES.NewES(self.filename[effindex], sptex);
end

function EffectManager:Init(tablefilename)
	if tablefilename == nil or tablefilename == "" then
		return;
	end
	local tabledata = {};
	local linecount;
	
	tabledata, linecount = tablefile:GetTableFileData(tablefilename, "nss");
	local effindex;
	for i=1, linecount do
		effindex = tabledata[1][i];
		luastate.SetConst(tabledata[2][i], effindex);
		self.filename[effindex] = tabledata[3][i];
	end
end

function EffectManager:Push(_able, effindex, _x, _y, _z, sptex)
	local effectitem =	{
												effect = self:NewES(effindex, sptex);
												able = _able;
												x = _x;
												y = _y;
												z = _z;
											}
	self:Update(effectitem, effectitem.able, effectitem.x, effectitem.y, effectitem.z, true, false);
	return effectitem;
end

function EffectManager:Update(effectitem, able, x, y, z, bForce, bUpdate)
	if x ~= nil and y ~= nil then
		effectitem.x = x;
		effectitem.y = y;
		effectitem.z = z;
		hgeES.MoveTo(effectitem.effect, x, y, z, bForce);
	end
	if able ~= nil then
		effectitem.able = able;
		if able == true then
			hgeES.Fire(effectitem.effect);
		else
			hgeES.Stop(effectitem.effect, bForce);
		end
	end
	if bUpdate == nil or bUpdate then
		hgeES.Update(effectitem.effect);
	end
end

function EffectManager:Clear(items)
	if items == nil then
		items = self.effects;
	end
	for i, it in pairs(items) do
		if it ~= nil then
			if it.effect == nil then
				self:Clear(it);
			else
				hgeES.DeleteES(it.effect);
				it.effect = NULL;
				it = {};
			end
		end
		it = nil;
	end
	items = nil;
end

function EffectManager:RenderItem(effectitem)
	if effectitem == nil then
		return;
	end
	if effectitem.able then
		hgeES.Render(effectitem.effect);
	end
end
function Process:Render()
	
	export:ClientSetMatrix(self.worldx, self.worldy, self.worldz);
	
	if self.state == STATE_INIT then
		return self:RenderInitState();
	end
	
	if time > 0 then
		if self.state == STATE_TITLE then
			self:_RenderTitle();
		end
		if self.state == STATE_START then
			self:_RenderStart();
		end
		if self.state == STATE_OVER then
			self:_RenderOver();
		end
		if self.state == STATE_PAUSE then
			self:_RenderPause();
		end
	end
	
	hgeFont.printf(self.font, M_CLIENT_LEFT, M_CLIENT_TOP, 0, string.format("%.2f", hge.Timer_GetFPS(35)));
	local active, replaying = self:CheckActive();
	if self.state == STATE_START then
		if replaying and d.replayfps ~= nil then
			hgeFont.printf(self.font, M_CLIENT_LEFT, M_CLIENT_TOP + 16, 0, string.format("%.2f", d.replayfps));
		end
		hgeFont.printf(self.font, M_CLIENT_CENTER_X, M_CLIENT_TOP, HGETEXT_CENTER, string.format("%.5f", data:GetNowLifeTime() / M_INTTIMEFACTOR));
		hgeFont.printf(self.font, M_CLIENT_CENTER_X, M_CLIENT_TOP + 16, HGETEXT_CENTER, time);
		hgeFont.printf(self.font, M_CLIENT_CENTER_X, M_CLIENT_TOP + 32, HGETEXT_CENTER, data:GetNowScore());
	end
	
	if d.displaybgmchange ~= nil and d.displaybgmchange > 0 then
		d.displaybgmchange = d.displaybgmchange - 1;
		hgeFont.printf(self.font, M_CLIENT_CENTER_X, M_CLIENT_BOTTOM - 32, HGETEXT_CENTER, "BGM: "..self.bgmvol.."%");
	end
	if d.displaysechange ~= nil and d.displaysechange > 0 then
		d.displaysechange = d.displaysechange - 1;
		hgeFont.printf(self.font, M_CLIENT_CENTER_X, M_CLIENT_BOTTOM - 16, HGETEXT_CENTER, "SE: "..self.sevol.."%");
	end
	
end

function Process:RenderInitState()
	if self.texInit ~= NULL then
		local quad=hge.struct.hgeQuad();
		quad.blend = BLEND_DEFAULT;
		quad.tex = self.texInit;
		local _col = M_FFFFFFFF;
		for i=1, 4 do
			quad.v[i].col = _col;
		end
		quad.v[1].tx = 0;	quad.v[1].ty = 0;
		quad.v[2].tx = 1;	quad.v[2].ty = 0;
		quad.v[3].tx = 1;	quad.v[3].ty = 1;
		quad.v[4].tx = 0;	quad.v[4].ty = 1;
		quad.v[1].x = M_CLIENT_LEFT;	quad.v[1].y = M_CLIENT_TOP;	quad.v[1].z = 0;
		quad.v[2].x = M_CLIENT_RIGHT;	quad.v[2].y = M_CLIENT_TOP;	quad.v[2].z = 0;
		quad.v[3].x = M_CLIENT_RIGHT;	quad.v[3].y = M_CLIENT_BOTTOM;	quad.v[3].z = 0;
		quad.v[4].x = M_CLIENT_LEFT;	quad.v[4].y = M_CLIENT_BOTTOM;	quad.v[4].z = 0;
		hge.Gfx_RenderQuad(quad);
	end

	return PGO;

end
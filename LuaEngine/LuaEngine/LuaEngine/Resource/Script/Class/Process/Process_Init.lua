function Process:ProcessInit()
	time = time + 1
	if time == 1 then
		return self:ProcessPreInitial();
	end
	
	if self.texInit ~= NULL then
		hge.Texture_Free(self.texInit);
		self.texInit = NULL;
	end
	
	data:Init(hge.Ini_GetString(RESCONFIGS_RESOURCE, RESCONFIGN_RESOURCEFILE, RESCONFIGDEFAULT_RESOURCEFILE));
	tex:Init(RESDEFAULT_DATAFOLDER..RESDEFAULT_TEXTUREDEFINE);
	spim:Init(RESDEFAULT_DATAFOLDER..RESDEFAULT_SPRITEITEMDEFINE);
	effm:Init(RESDEFAULT_DATAFOLDER..RESDEFAULT_EFFECTDEFINE);
	se:Init(RESDEFAULT_DATAFOLDER..RESDEFAULT_SEDEFINE);
	music:Init(RESDEFAULT_DATAFOLDER..RESDEFAULT_MUSICDEFINE);

	self.font = hgeFont.NewFont(RESDEFAULT_FONTFILE);
	self.gamefont = hgeFont.NewFont(RESDEFAULT_FONTFILE);
	hgeFont.SetScale(self.gamefont, 2);
	
	return PTITLE;
end
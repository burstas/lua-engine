Process	=	{
					}

function Process:new(t)
    local t = t or {};
    self.__index = self;
    setmetatable(t, self);
    t:_Init();
    return t;
end

function Process:_Init()
	
	self.keyUp			= RESCONFIGDEFAULT_KEYUP;
	self.keyDown		= RESCONFIGDEFAULT_KEYDOWN;
	self.keyLeft		= RESCONFIGDEFAULT_KEYLEFT;
	self.keyRight		= RESCONFIGDEFAULT_KEYRIGHT;
	self.keyA				=	RESCONFIGDEFAULT_KEYA;
	self.keyS				=	RESCONFIGDEFAULT_KEYS;
	self.keyD				=	RESCONFIGDEFAULT_KEYD;
	self.keyZ				=	RESCONFIGDEFAULT_KEYZ;
	self.keyX				=	RESCONFIGDEFAULT_KEYX
	self.keyC				=	RESCONFIGDEFAULT_KEYC;
	self.keySpace		=	RESCONFIGDEFAULT_KEYSpace;
	self.keyPause		= RESCONFIGDEFAULT_KEYPAUSE;
	self.keySkip		= RESCONFIGDEFAULT_KEYSKIP;
	self.keyEnter		= RESCONFIGDEFAULT_KEYENTER;
	self.keyCancel	=	RESCONFIGDEFAULT_KEYCANCEL;
	self.keyEscape	= RESCONFIGDEFAULT_KEYESCAPE;
	self.keyCapture	= RESCONFIGDEFAULT_KEYCAPTURE;
	self.keySuicide = RESCONFIGDEFAULT_KEYSUICIDE;
	self.keyBGMDown	= RESCONFIGDEFAULT_KEYBGMDOWN;
	self.keyBGMUp		= RESCONFIGDEFAULT_KEYBGMUP;
	self.keySEDown	= RESCONFIGDEFAULT_KEYSEDOWN;
	self.keySEUp		= RESCONFIGDEFAULT_KEYSEUP;
	
	self.joyA				=	RESCONFIGDEFAULT_JOYA;
	self.joyS				=	RESCONFIGDEFAULT_JOYS;
	self.joyD				=	RESCONFIGDEFAULT_JOYD;
	self.joyZ				=	RESCONFIGDEFAULT_JOYZ;
	self.joyX				=	RESCONFIGDEFAULT_JOYX
	self.joyC				=	RESCONFIGDEFAULT_JOYC;
	self.joySpace		=	RESCONFIGDEFAULT_JOYSpace;
	self.joyPause		=	RESCONFIGDEFAULT_JOYPAUSE;
	self.joyEnter		=	RESCONFIGDEFAULT_JOYENTER;
	self.joyCancel	=	RESCONFIGDEFAULT_JOYCANCEL;
	self.joySpeedUp = RESCONFIGDEFAULT_JOYSPEEDUP;
	self.joySuicide = RESCONFIGDEFAULT_JOYSUICIDE;
	
	self.state	=	STATE_INIT;
	
	self.texInit	=	NULL;
	
	self.worldx	=	0;
	self.worldy	=	0;
	self.worldz	=	0;
	
	self.replaying = false;
	self.active = false;
	
	self.font = NULL;
	self.gamefont = NULL;
	
end

function Process:Release()
	
	hge.Ini_SetInt(RESCONFIGS_VOLUME, RESCONFIGN_VOLMUSIC, self.bgmvol);
	hge.Ini_SetInt(RESCONFIGS_VOLUME, RESCONFIGN_VOLSE, self.sevol);

	hge.Ini_SetInt(RESCONFIGS_CUSTOM, RESCONFIGN_SCREENMODE, self.screenmode);
	hge.Ini_SetInt(RESCONFIGS_CUSTOM, RESCONFIGN_DIFFICULT, self.nowdifflv);
	
	if self.texInit ~= NULL then
		hge.Texture_Free(self.texInit);
	end
	
	tex:Release();
	se:Release();
	spim:Release();
	effm:Release();
	music:Release();
	
	self:_Init();
	
end

mp = Process:new();
#include "../Header/Process.h"
#include "../Header/LuaConstDefine.h"

bool Process::_LuaRegistHGEHelpFunction(LuaObject * obj)
{
	// hgeFont
	LuaObject _fontobj = obj->CreateTable("hgeFont");

	_fontobj.Register("NewFont", LuaFn_hgeFont_NewFont);
	_fontobj.Register("DeleteFont", LuaFn_hgeFont_DeleteFont);

	_fontobj.Register("Render", LuaFn_hgeFont_Render);
	_fontobj.Register("printf", LuaFn_hgeFont_Render);
	_fontobj.Register("printfb", LuaFn_hgeFont_printfb);

	_fontobj.Register("SetColor", LuaFn_hgeFont_SetColor);
	_fontobj.Register("SetZ", LuaFn_hgeFont_SetZ);
	_fontobj.Register("SetBlendMode", LuaFn_hgeFont_SetBlendMode);
	_fontobj.Register("SetScale", LuaFn_hgeFont_SetScale);
	_fontobj.Register("SetProportion", LuaFn_hgeFont_SetProportion);
	_fontobj.Register("SetRotation", LuaFn_hgeFont_SetRotation);
	_fontobj.Register("SetTracking", LuaFn_hgeFont_SetTracking);
	_fontobj.Register("SetSpacing", LuaFn_hgeFont_SetSpacing);

	_fontobj.Register("GetColor", LuaFn_hgeFont_GetColor);
	_fontobj.Register("GetZ", LuaFn_hgeFont_GetZ);
	_fontobj.Register("GetBlendMode", LuaFn_hgeFont_GetBlendMode);
	_fontobj.Register("GetScale", LuaFn_hgeFont_GetScale);
	_fontobj.Register("GetProportion", LuaFn_hgeFont_GetProportion);
	_fontobj.Register("GetRotation", LuaFn_hgeFont_GetRotation);
	_fontobj.Register("GetTracking", LuaFn_hgeFont_GetTracking);
	_fontobj.Register("GetSpacing", LuaFn_hgeFont_GetSpacing);

	_fontobj.Register("ChangeSprite", LuaFn_hgeFont_ChangeSprite);
	_fontobj.Register("GetSprite", LuaFn_hgeFont_GetSprite);
	_fontobj.Register("GetPreWidth", LuaFn_hgeFont_GetPreWidth);
	_fontobj.Register("GetPostWidth", LuaFn_hgeFont_GetPostWidth);
	_fontobj.Register("GetHeight", LuaFn_hgeFont_GetHeight);
	_fontobj.Register("GetStringWidth", LuaFn_hgeFont_GetStringWidth);

	// hgeSprite
	LuaObject _spriteobj = obj->CreateTable("hgeSprite");

	_spriteobj.Register("NewSprite", LuaFn_hgeSprite_NewSprite);
	_spriteobj.Register("DeleteSprite", LuaFn_hgeSprite_DeleteSprite);

	_spriteobj.Register("Render", LuaFn_hgeSprite_Render);
	_spriteobj.Register("RenderEx", LuaFn_hgeSprite_Render);
	_spriteobj.Register("RenderStretch", LuaFn_hgeSprite_RenderStretch);
	_spriteobj.Register("Render4V", LuaFn_hgeSprite_Render4V);

	_spriteobj.Register("SetTexture", LuaFn_hgeSprite_SetTexture);
	_spriteobj.Register("SetTextureRect", LuaFn_hgeSprite_SetTextureRect);
	_spriteobj.Register("SetColor", LuaFn_hgeSprite_SetColor);
	_spriteobj.Register("SetZ", LuaFn_hgeSprite_SetZ);
	_spriteobj.Register("SetBlendMode", LuaFn_hgeSprite_SetBlendMode);
	_spriteobj.Register("SetHotSpot", LuaFn_hgeSprite_SetHotSpot);
	_spriteobj.Register("SetFlip", LuaFn_hgeSprite_SetFlip);

	_spriteobj.Register("GetTexture", LuaFn_hgeSprite_GetTexture);
	_spriteobj.Register("GetTextureRect", LuaFn_hgeSprite_GetTextureRect);
	_spriteobj.Register("GetColor", LuaFn_hgeSprite_GetColor);
	_spriteobj.Register("GetZ", LuaFn_hgeSprite_GetZ);
	_spriteobj.Register("GetBlendMode", LuaFn_hgeSprite_GetBlendMode);
	_spriteobj.Register("GetHotSpot", LuaFn_hgeSprite_GetHotSpot);
	_spriteobj.Register("GetFlip", LuaFn_hgeSprite_GetFlip);

	_spriteobj.Register("GetWidth", LuaFn_hgeSprite_GetWidth);
	_spriteobj.Register("GetHeight", LuaFn_hgeSprite_GetHeight);
	_spriteobj.Register("GetBoundingBox", LuaFn_hgeSprite_GetBoundingBox);

	// hgeEffectSystem
	LuaObject _esobj = obj->CreateTable("hgeES");

	_esobj.Register("NewES", LuaFn_hgeES_NewES);
	_esobj.Register("DeleteES", LuaFn_hgeES_DeleteES);

	_esobj.Register("Load", LuaFn_hgeES_Load);
	_esobj.Register("Save", LuaFn_hgeES_Save);

	_esobj.Register("Render", LuaFn_hgeES_Render);
	_esobj.Register("MoveTo", LuaFn_hgeES_MoveTo);
	_esobj.Register("Fire", LuaFn_hgeES_Fire);
	_esobj.Register("Stop", LuaFn_hgeES_Stop);

	_esobj.Register("Update", LuaFn_hgeES_Update);

	return true;
}

#ifndef _PROCESS_H
#define _PROCESS_H

#include "MainDependency.h"
//#define __NOTUSELUA

#define OFNFLAG_NULL	NULL
#define OFNFLAG_TOOPEN	0x01
#define OFNFLAG_TOSAVE	0x02
#define OFNFLAG_OPENED	0x04
#define OFNFLAG_SAVED	0x08

struct OpenFileNameStruct 
{
	BYTE flag;
	int length;
	DWORD content;
	OPENFILENAME ofn;
	char filename[MAX_PATH];
	char strfilter[MAX_PATH];
	char strdefext[MAX_PATH];
	char strtitle[MAX_PATH];
	char strinitdir[MAX_PATH];
};

struct DialogBoxStruct 
{
	char title[MAX_PATH];
	char comment[MAX_PATH];
	char str[MAX_PATH];
};

struct MessageBoxExStruct 
{
	char title[MAX_PATH];
	char str[MAX_PATH];
};

static class Process
{
public:
	Process();
	~Process();

public:

	static bool RenderFunc();
	static bool FrameFunc();
	static bool FocusLostFunc();
	static bool FocusGainFunc();
	static bool GfxRestoreFunc();
	static bool ExitFunc();

#ifdef __NOTUSELUA
	static bool RenderFuncSelf();
	static bool FrameFuncSelf();
	static bool FocusLostFuncSelf();
	static bool FocusGainFuncSelf();
	static bool GfxRestoreFuncSelf();
	static bool ExitFuncSelf();
#endif

	static bool DispatchOpenFileName();
	static bool ReleaseOpenFileNameContent();

	static bool LuaInitial();
	static bool LuaRegistFunction();
	static bool _LuaRegistFunction(LuaObject * obj);
	static bool _LuaRegistHGEFunction(LuaObject * obj);
	static bool _LuaRegistHGEHelpFunction(LuaObject * obj);

	static bool LuaRegistConst();
	static bool _LuaRegistConst(LuaObject * obj);
	static bool _LuaRegistHGEConst(LuaObject * obj);
	static bool _LuaRegistHGEHelpConst(LuaObject * obj);

	static bool LuaClearCallBackFunctions();

	static void ClientInitial();
	static void Release();

	static void _LuaHelper_PushDWORD(LuaState * ls, DWORD dval);
	static DWORD _LuaHelper_GetDWORD(LuaObject * obj);
	static void _LuaHelper_PushLONGLONG(LuaState * ls, LONGLONG llval);
	static LONGLONG _LuaHelper_GetLONGLONG(LuaObject * obj);
	static void _LuaHelper_PushQWORD(LuaState * ls, QWORD qval);
	static QWORD _LuaHelper_GetQWORD(LuaObject * obj);
	static void _LuaHelper_PushString(LuaState * ls, const char * sval);

	static void _LuaHelper_GetCalculateValue(LuaObject * obj, char calchar, bool buseq, void * val);

	static BOOL CALLBACK DialogProc(HWND hwndDlg, UINT uMsg, WPARAM wParam, LPARAM lParam);
	static BOOL CALLBACK MessageBoxExProc(HWND hwndDlg, UINT uMsg, WPARAM wParam, LPARAM lParam);

	static int LuaFn_Global_Calculate(LuaState * ls);
	static int LuaFn_Global_DIST(LuaState * ls);
	static int LuaFn_Global_DIST2(LuaState * ls);
	static int LuaFn_Global_SIGN(LuaState * ls);
	static int LuaFn_Global_ROLL(LuaState * ls);
	static int LuaFn_Global_INTER(LuaState * ls);
	static int LuaFn_Global_ARGB(LuaState * ls);
	static int LuaFn_Global_GetARGB(LuaState * ls);
	static int LuaFn_Global_SetARGB(LuaState * ls);
	static int LuaFn_Global_GetLocalTime(LuaState * ls);
	static int LuaFn_Global_GetPrivateProfileString(LuaState * ls);
	static int LuaFn_Global_WritePrivateProfileString(LuaState * ls);
	static int LuaFn_Global_MessageBox(LuaState * ls);
	static int LuaFn_Global_MessageBoxEx(LuaState * ls);
	static int LuaFn_Global_InputBox(LuaState * ls);
	static int LuaFn_Global_SetOpenFileName(LuaState * ls);
	static int LuaFn_Global_ReceiveOpenFileName(LuaState * ls);
	static int LuaFn_Global_Malloc(LuaState * ls);
	static int LuaFn_Global_Free(LuaState * ls);
	static int LuaFn_Global_WriteMemory(LuaState * ls);
	static int LuaFn_Global_ReadMemory(LuaState * ls);

	static DWORD _Helper_Malloc(int length);
	static bool _LuaHelper_Free(DWORD content);
	static bool _LuaHelper_FreeAll();

	static int LuaFn_LuaState_Reload(LuaState * ls);
	static int LuaFn_LuaState_DoFile(LuaState * ls);
	static int LuaFn_LuaState_SetConst(LuaState * ls);
	static int LuaFn_LuaState_GetConst(LuaState * ls);
	static int LuaFn_LuaState_GetPointer(LuaState * ls);
	static int LuaFn_LuaState_IntToDWORD(LuaState * ls);
	static int LuaFn_LuaState_DWORDToInt(LuaState * ls);
	static int LuaFn_LuaState_And(LuaState * ls);
	static int LuaFn_LuaState_Or(LuaState * ls);
	static int LuaFn_LuaState_Xor(LuaState * ls);
	static int LuaFn_LuaState_Not(LuaState * ls);
	static int LuaFn_LuaState_LShift(LuaState * ls);
	static int LuaFn_LuaState_RShift(LuaState * ls);
	static int LuaFn_LuaState_ReadLineInContent(LuaState * ls);

	/* HGE */
	static DWORD _LuaHelper_GetColor(LuaObject * obj);
	static void _LuaHelper_GetVertex(LuaObject * obj, hgeVertex * vertex);
	static void _LuaHelper_GetTriple(LuaObject * obj, hgeTriple * triple);
	static void _LuaHelper_GetQuad(LuaObject * obj, hgeQuad * quad);

	static void _LuaHelper_hge_DeleteAllTexture();

	static int LuaFn_hge_Struct_hgeQuad(LuaState * ls);

	static int LuaFn_hge_System_SetState(LuaState * ls);
	static int LuaFn_hge_System_GetState(LuaState * ls);
	static int LuaFn_hge_System_Log(LuaState * ls);

	static int LuaFn_hge_System_GetErrorMessage(LuaState * ls);
	static int LuaFn_hge_System_Launch(LuaState * ls);
	static int LuaFn_hge_System_Snapshot(LuaState * ls);

	static int LuaFn_hge_System_Set2DMode(LuaState * ls);
	static int LuaFn_hge_System_Set3DMode(LuaState * ls);
	static int LuaFn_hge_System_GetFarPoint(LuaState * ls);
	static int LuaFn_hge_System_Is2DMode(LuaState * ls);
	static int LuaFn_hge_System_Transform3DPoint(LuaState * ls);

	static int LuaFn_hge_Resource_Load(LuaState * ls);
	static int LuaFn_hge_Resource_Free(LuaState * ls);
	static int LuaFn_hge_Resource_AttachPack(LuaState * ls);
	static int LuaFn_hge_Resource_RemovePack(LuaState * ls);
	static int LuaFn_hge_Resource_SetPath(LuaState * ls);
	static int LuaFn_hge_Resource_MakePath(LuaState * ls);
	static int LuaFn_hge_Resource_EnumFiles(LuaState * ls);
	static int LuaFn_hge_Resource_EnumFolders(LuaState * ls);
	static int LuaFn_hge_Resource_CreatePack(LuaState * ls);
	static int LuaFn_hge_Resource_AddFileInPack(LuaState * ls);
	static int LuaFn_hge_Resource_GetCRC(LuaState * ls);
	static int LuaFn_hge_Resource_GetPackFirstFileName(LuaState * ls);

	static int LuaFn_hge_Ini_SetInt(LuaState * ls);
	static int LuaFn_hge_Ini_GetInt(LuaState * ls);
	static int LuaFn_hge_Ini_SetFloat(LuaState * ls);
	static int LuaFn_hge_Ini_GetFloat(LuaState * ls);
	static int LuaFn_hge_Ini_SetString(LuaState * ls);
	static int LuaFn_hge_Ini_GetString(LuaState * ls);

	static int LuaFn_hge_Random_Seed(LuaState * ls);
	static int LuaFn_hge_Random_Int(LuaState * ls);
	static int LuaFn_hge_Random_Float(LuaState * ls);

	static int LuaFn_hge_Timer_GetTime(LuaState * ls);
	static int LuaFn_hge_Timer_GetDelta(LuaState * ls);
	static int LuaFn_hge_Timer_GetFPS(LuaState * ls);
	static int LuaFn_hge_Timer_GetWorstFPS(LuaState * ls);
	static int LuaFn_hge_Timer_GetCurrentSystemTime(LuaState * ls);

	static int LuaFn_hge_Effect_Load(LuaState * ls);
	static int LuaFn_hge_Effect_Free(LuaState * ls);
	static int LuaFn_hge_Effect_Play(LuaState * ls);

	static int LuaFn_hge_Stream_Load(LuaState * ls);
	static int LuaFn_hge_Stream_Free(LuaState * ls);
	static int LuaFn_hge_Stream_Play(LuaState * ls);

	static int LuaFn_hge_Channel_SetPanning(LuaState * ls);
	static int LuaFn_hge_Channel_SetVolume(LuaState * ls);
	static int LuaFn_hge_Channel_SetPitch(LuaState * ls);
	static int LuaFn_hge_Channel_Pause(LuaState * ls);
	static int LuaFn_hge_Channel_Resume(LuaState * ls);
	static int LuaFn_hge_Channel_Stop(LuaState * ls);
	static int LuaFn_hge_Channel_IsPlaying(LuaState * ls);
	static int LuaFn_hge_Channel_GetLength(LuaState * ls);
	static int LuaFn_hge_Channel_GetPos(LuaState * ls);
	static int LuaFn_hge_Channel_SetPos(LuaState * ls);
	static int LuaFn_hge_Channel_SetStartPos(LuaState * ls);
	static int LuaFn_hge_Channel_SlideTo(LuaState * ls);
	static int LuaFn_hge_Channel_IsSliding(LuaState * ls);
	static int LuaFn_hge_Channel_SetLoop(LuaState * ls);
	static int LuaFn_hge_Channel_RemoveLoop(LuaState * ls);

	static int LuaFn_hge_Input_GetMousePos(LuaState * ls);
	static int LuaFn_hge_Input_SetMousePos(LuaState * ls);
	static int LuaFn_hge_Input_GetMouseWheel(LuaState * ls);
	static int LuaFn_hge_Input_IsMouseOver(LuaState * ls);
	static int LuaFn_hge_Input_KeyDown(LuaState * ls);
	static int LuaFn_hge_Input_KeyUp(LuaState * ls);
	static int LuaFn_hge_Input_GetKeyState(LuaState * ls);
	static int LuaFn_hge_Input_GetKeyName(LuaState * ls);
	static int LuaFn_hge_Input_GetKey(LuaState * ls);
	static int LuaFn_hge_Input_GetChar(LuaState * ls);
	static int LuaFn_hge_Input_GetEvent(LuaState * ls);

	static int LuaFn_hge_Input_GetDIKey(LuaState * ls);
	static int LuaFn_hge_Input_SetDIKey(LuaState * ls);
	static int LuaFn_hge_Input_GetDIJoy(LuaState * ls);
	static int LuaFn_hge_Input_HaveJoy(LuaState * ls);

	static int LuaFn_hge_Gfx_BeginScene(LuaState * ls);
	static int LuaFn_hge_Gfx_EndScene(LuaState * ls);
	static int LuaFn_hge_Gfx_Clear(LuaState * ls);
	static int LuaFn_hge_Gfx_RenderLine(LuaState * ls);
	static int LuaFn_hge_Gfx_RenderTriple(LuaState * ls);
	static int LuaFn_hge_Gfx_RenderQuad(LuaState * ls);
	static int LuaFn_hge_Gfx_StartBatch(LuaState * ls);
	static int LuaFn_hge_Gfx_FinishBatch(LuaState * ls);
	static int LuaFn_hge_Gfx_SetClipping(LuaState * ls);
	static int LuaFn_hge_Gfx_SetTransform(LuaState * ls);

	static int LuaFn_hge_Target_Create(LuaState * ls);
	static int LuaFn_hge_Target_Free(LuaState * ls);
	static int LuaFn_hge_Target_GetTexture(LuaState * ls);

	static int LuaFn_hge_Texture_Create(LuaState * ls);
	static int LuaFn_hge_Texture_Load(LuaState * ls);
	static int LuaFn_hge_Texture_Free(LuaState * ls);
	static int LuaFn_hge_Texture_GetWH(LuaState * ls);
	static int LuaFn_hge_Texture_Lock(LuaState * ls);
	static int LuaFn_hge_Texture_Unlock(LuaState * ls);

	static int LuaFn_hge_Font_Load(LuaState * ls);
	static int LuaFn_hge_Font_Free(LuaState * ls);
	static int LuaFn_hge_Gfx_RenderText(LuaState * ls);
	static int LuaFn_hge_Gfx_RenderTextToTarget(LuaState * ls);

	static int LuaFn_hgeEX_SetTextureNumber(LuaState * ls);
	static int LuaFn_hgeEX_RegisterTextures(LuaState * ls);

	/* HGE Help */

	static hgeFont * _Helper_New_hgeFont();
	static hgeFont * _Helper_New_hgeFont(const char * filename, bool bMipmap=false);
	static hgeSprite * _Helper_New_hgeSprite();
	static hgeSprite * _Helper_New_hgeSprite(HTEXTURE tex, float x, float y, float w, float h);
	static hgeSprite * _Helper_New_hgeSprite(const hgeSprite & spr);
	static hgeEffectSystem * _Helper_New_hgeES();
	static hgeEffectSystem * _Helper_New_hgeES(const char * filename, HTEXTURE tex = 0, HTEXTURE * texset = 0);
	static hgeEffectSystem * _Helper_New_hgeES(const hgeEffectSystem & eff);

	// Font
	static hgeFont * _LuaHelper_hgeFont_Get(LuaStack * args);
	static void _LuaHelper_hgeFont_DeleteFont(hgeFont * _font);
	static void _LuaHelper_hgeFont_DeleteAllFont();
	static int LuaFn_hgeFont_NewFont(LuaState * ls);
	static int LuaFn_hgeFont_DeleteFont(LuaState * ls);

	static int LuaFn_hgeFont_Render(LuaState * ls);
	static int LuaFn_hgeFont_printfb(LuaState * ls);

	static int LuaFn_hgeFont_SetColor(LuaState * ls);
	static int LuaFn_hgeFont_SetZ(LuaState * ls);
	static int LuaFn_hgeFont_SetBlendMode(LuaState * ls);
	static int LuaFn_hgeFont_SetScale(LuaState * ls);
	static int LuaFn_hgeFont_SetProportion(LuaState * ls);
	static int LuaFn_hgeFont_SetRotation(LuaState * ls);
	static int LuaFn_hgeFont_SetTracking(LuaState * ls);
	static int LuaFn_hgeFont_SetSpacing(LuaState * ls);

	static int LuaFn_hgeFont_GetColor(LuaState * ls);
	static int LuaFn_hgeFont_GetZ(LuaState * ls);
	static int LuaFn_hgeFont_GetBlendMode(LuaState * ls);
	static int LuaFn_hgeFont_GetScale(LuaState * ls);
	static int LuaFn_hgeFont_GetProportion(LuaState * ls);
	static int LuaFn_hgeFont_GetRotation(LuaState * ls);
	static int LuaFn_hgeFont_GetTracking(LuaState * ls);
	static int LuaFn_hgeFont_GetSpacing(LuaState * ls);

	static int LuaFn_hgeFont_ChangeSprite(LuaState * ls);
	static int LuaFn_hgeFont_GetSprite(LuaState * ls);
	static int LuaFn_hgeFont_GetPreWidth(LuaState * ls);
	static int LuaFn_hgeFont_GetPostWidth(LuaState * ls);
	static int LuaFn_hgeFont_GetHeight(LuaState * ls);
	static int LuaFn_hgeFont_GetStringWidth(LuaState * ls);


	// Sprite
	static hgeSprite * _LuaHelper_hgeSprite_Get(LuaStack * args);
	static void _LuaHelper_hgeSprite_DeleteSprite(hgeSprite * _sprite);
	static void _LuaHelper_hgeSprite_DeleteAllSprite();
	static int LuaFn_hgeSprite_NewSprite(LuaState * ls);
	static int LuaFn_hgeSprite_DeleteSprite(LuaState * ls);

	static int LuaFn_hgeSprite_Render(LuaState * ls);
	static int LuaFn_hgeSprite_RenderStretch(LuaState * ls);
	static int LuaFn_hgeSprite_Render4V(LuaState * ls);

	static int LuaFn_hgeSprite_SetTexture(LuaState * ls);
	static int LuaFn_hgeSprite_SetTextureRect(LuaState * ls);
	static int LuaFn_hgeSprite_SetColor(LuaState * ls);
	static int LuaFn_hgeSprite_SetZ(LuaState * ls);
	static int LuaFn_hgeSprite_SetBlendMode(LuaState * ls);
	static int LuaFn_hgeSprite_SetHotSpot(LuaState * ls);
	static int LuaFn_hgeSprite_SetFlip(LuaState * ls);

	static int LuaFn_hgeSprite_GetTexture(LuaState * ls);
	static int LuaFn_hgeSprite_GetTextureRect(LuaState * ls);
	static int LuaFn_hgeSprite_GetColor(LuaState * ls);
	static int LuaFn_hgeSprite_GetZ(LuaState * ls);
	static int LuaFn_hgeSprite_GetBlendMode(LuaState * ls);
	static int LuaFn_hgeSprite_GetHotSpot(LuaState * ls);
	static int LuaFn_hgeSprite_GetFlip(LuaState * ls);

	static int LuaFn_hgeSprite_GetWidth(LuaState * ls);
	static int LuaFn_hgeSprite_GetHeight(LuaState * ls);
	static int LuaFn_hgeSprite_GetBoundingBox(LuaState * ls);


	// EffectSystem
	static hgeEffectSystem * _LuaHelper_hgeES_Get(LuaStack * args);
	static void _LuaHelper_hgeES_DeleteES(hgeEffectSystem * _es);
	static void _LuaHelper_hgeES_DeleteAllES();
	static int LuaFn_hgeES_NewES(LuaState * ls);
	static int LuaFn_hgeES_DeleteES(LuaState * ls);

	static int LuaFn_hgeES_Load(LuaState * ls);
	static int LuaFn_hgeES_Save(LuaState * ls);

	static int LuaFn_hgeES_Render(LuaState * ls);
	static int LuaFn_hgeES_MoveTo(LuaState * ls);
	static int LuaFn_hgeES_Fire(LuaState * ls);
	static int LuaFn_hgeES_Stop(LuaState * ls);
	static int LuaFn_hgeES_Update(LuaState * ls);

public:
	static HGE * hge;
	static int texnum;
	static HTEXTURE * texset;
	static hgeChannelSyncInfo channelsyncinfo;
	static list<hgeFont *>fontList;
	static list<hgeSprite *>spriteList;
	static list<hgeEffectSystem *>esList;
	static list<DWORD>mallocList;
	static LuaStateOwner state;

	static LuaFunction<bool> * framefunc;
	static LuaFunction<bool> * renderfunc;
	static LuaFunction<bool> * focuslostfunc;
	static LuaFunction<bool> * focusgainfunc;
	static LuaFunction<bool> * gfxrestorefunc;
	static LuaFunction<bool> * exitfunc;

	static OpenFileNameStruct ofns;
	static DialogBoxStruct dbs;
	static MessageBoxExStruct mbes;
}mp;

#endif
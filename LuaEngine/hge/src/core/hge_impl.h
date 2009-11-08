/*
** Haaf's Game Engine 1.8
** Copyright (C) 2003-2007, Relish Games
** hge.relishgames.com
**
** Common core implementation header
*/


#ifndef HGE_IMPL_H
#define HGE_IMPL_H

#include "..\..\include\hge.h"
#include <stdio.h>
#include <d3d9.h>
#include <d3dx9.h>

#define D3DFVF_HGEVERTEX (D3DFVF_XYZ | D3DFVF_DIFFUSE | D3DFVF_TEX1)
#define VERTEX_BUFFER_SIZE 4000


struct CRenderTargetList
{
	int					width;
	int					height;
	IDirect3DTexture9*	pTex;
	IDirect3DSurface9*	pDepth;
	CRenderTargetList*	next;
};

struct CTextureList
{
	HTEXTURE			tex;
	int					width;
	int					height;
	CTextureList*		next;
};

struct CResourceList
{
	char				filename[_MAX_PATH];
	/************************************************************************/
	/* This member is changed by h5nc (h5nc@yahoo.com.cn)                   */
	/************************************************************************/
	int					password;
	CResourceList*		next;
};

struct CStreamList
{
	HSTREAM				hstream;
	void*				data;
	CStreamList*		next;
};

struct CInputEventList
{
	hgeInputEvent		event;
	CInputEventList*	next;
};

/************************************************************************/
/* This structure is added by Yuki                                      */
/************************************************************************/
/* add by Yuki*/
struct CFontList
{
	HD3DFONT font;
	CFontList * next;
};

void DInit();
void DDone();
bool DFrame();


/*
** HGE Interface implementation
*/
class HGE_Impl : public HGE
{

	/************************************************************************/
	/* These functions are modified by h5nc (h5nc@yahoo.com.cn)             */
	/* Details are marked in hge.h                                          */
	/************************************************************************/
public:
	virtual	void		CALL	Release();

	virtual bool		CALL	System_Initiate();
	virtual void		CALL	System_Shutdown();
	virtual bool		CALL	System_Start();
	virtual bool			CALL	System_Set2DMode(hge3DPoint ptfar){return System_Set2DMode(ptfar.x, ptfar.y, ptfar.z);};
	virtual bool			CALL	System_Set2DMode(float x, float y, float z);
	virtual bool			CALL	System_Set3DMode();
	virtual hge3DPoint *	CALL	System_GetFarPoint();
	virtual bool			CALL	System_Is2DMode();
	virtual float			CALL	System_Transform3DPoint(hge3DPoint * pt){return pt->scale = System_Transform3DPoint(pt->x, pt->y, pt->z);};
	virtual float			CALL	System_Transform3DPoint(float &x, float &y, float &z);
	virtual void		CALL	System_SetStateBool  (hgeBoolState   state, bool        value);
	virtual void		CALL	System_SetStateFunc  (hgeFuncState   state, hgeCallback value);
	virtual void		CALL	System_SetStateHwnd  (hgeHwndState   state, HWND        value);
	virtual void		CALL	System_SetStateInt   (hgeIntState    state, int         value);
	virtual void		CALL	System_SetStateString(hgeStringState state, const char *value);
	virtual bool		CALL	System_GetStateBool  (hgeBoolState  );
	virtual hgeCallback	CALL	System_GetStateFunc  (hgeFuncState  );
	virtual HWND		CALL	System_GetStateHwnd  (hgeHwndState  );
	virtual int			CALL	System_GetStateInt   (hgeIntState   );
	virtual const char*	CALL	System_GetStateString(hgeStringState);
	virtual char*		CALL	System_GetErrorMessage();
	virtual	void		CALL	System_Log(const char *format, ...);
	virtual bool		CALL	System_Launch(const char *url);
	virtual void		CALL	System_Snapshot(const char *filename=0);

	virtual BYTE*		CALL	Resource_Load(const char *filename, DWORD *size=0);
	virtual void		CALL	Resource_Free(void *res);
	virtual bool		CALL	Resource_AttachPack(const char *filename, int password=0);
	virtual void		CALL	Resource_RemovePack(const char *filename);
	virtual void		CALL	Resource_RemoveAllPacks();
	virtual char*		CALL	Resource_SetPath(const char *filename);
	virtual char*		CALL	Resource_MakePath(const char *filename);
	virtual char*		CALL	Resource_EnumFiles(const char *wildcard=0);
	virtual char*		CALL	Resource_EnumFolders(const char *wildcard=0);
	virtual bool		CALL	Resource_CreatePack(const char * filename, int password, hgeMemoryFile * first, ...);
	virtual bool		CALL	Resource_AddFileInPack(const char * filename, int password, hgeMemoryFile * memfile);
	virtual DWORD		CALL	Resource_GetCRC(const BYTE * content, DWORD size);
#ifdef ZLIB_USEPSW
	virtual int			CALL	Resource_GetPSW(int psw);
#else
	virtual char*		CALL	Resource_GetPSW(int psw);
#endif // ZLIB_USEPSW
	virtual char*		CALL	Resource_GetPackFirstFileName(const char * packfilename);

	virtual	void		CALL	Ini_SetInt(const char *section, const char *name, int value);
	virtual	int 		CALL	Ini_GetInt(const char *section, const char *name, int def_val);
	virtual	void		CALL	Ini_SetFloat(const char *section, const char *name, float value);
	virtual	float		CALL	Ini_GetFloat(const char *section, const char *name, float def_val);
	virtual	void		CALL	Ini_SetString(const char *section, const char *name, const char *value);
	virtual	char*		CALL	Ini_GetString(const char *section, const char *name, const char *def_val);

	virtual int			CALL	Random_Seed(int seed=0);
	virtual int			CALL	Random_Int(int min, int max);
	virtual float		CALL	Random_Float(float min, float max);

	virtual float		CALL	Timer_GetTime();
	virtual float		CALL	Timer_GetDelta();
	virtual float		CALL	Timer_GetFPS(int mod = 0);
	virtual float		CALL	Timer_GetWorstFPS(int mod);

	virtual HEFFECT		CALL	Effect_Load(const char *filename, DWORD size=0);
	virtual void		CALL	Effect_Free(HEFFECT eff);
	virtual HCHANNEL	CALL 	Effect_Play(HEFFECT eff);
	virtual HCHANNEL	CALL 	Effect_PlayEx(HEFFECT eff, int volume=100, int pan=0, float pitch=1.0f, bool loop=false);
/*
	virtual HMUSIC		CALL 	Music_Load(const char *filename, DWORD size=0);
	virtual void		CALL	Music_Free(HMUSIC mus);
	virtual HCHANNEL	CALL 	Music_Play(HMUSIC mus, bool loop, int volume = 100, int order = 0, int row = 0);
	virtual void		CALL	Music_SetAmplification(HMUSIC music, int ampl);
	virtual int			CALL	Music_GetAmplification(HMUSIC music);
	virtual int			CALL	Music_GetLength(HMUSIC music);
	virtual void		CALL	Music_SetPos(HMUSIC music, int order, int row);
	virtual bool		CALL	Music_GetPos(HMUSIC music, int *order, int *row);
	virtual void		CALL	Music_SetInstrVolume(HMUSIC music, int instr, int volume);
	virtual int			CALL	Music_GetInstrVolume(HMUSIC music, int instr);
	virtual void		CALL	Music_SetChannelVolume(HMUSIC music, int channel, int volume);
	virtual int			CALL	Music_GetChannelVolume(HMUSIC music, int channel);
*/
	virtual HSTREAM		CALL	Stream_Load(const char *filename, DWORD size=0, bool bLoad=true);
	virtual void		CALL	Stream_Free(HSTREAM stream);
	virtual HCHANNEL	CALL	Stream_Play(HSTREAM stream, bool loop, int volume = 100);

	virtual void		CALL 	Channel_SetPanning(HCHANNEL chn, int pan);
	virtual void		CALL 	Channel_SetVolume(HCHANNEL chn, int volume);
	virtual void		CALL 	Channel_SetPitch(HCHANNEL chn, float pitch);
	virtual void		CALL 	Channel_Pause(HCHANNEL chn);
	virtual void		CALL 	Channel_Resume(HCHANNEL chn);
	virtual void		CALL 	Channel_Stop(HCHANNEL chn);
	virtual void		CALL 	Channel_PauseAll();
	virtual void		CALL 	Channel_ResumeAll();
	virtual void		CALL 	Channel_StopAll();
	virtual bool		CALL	Channel_IsPlaying(HCHANNEL chn);
	virtual QWORD		CALL	Channel_GetLength(HCHANNEL chn);
	virtual QWORD		CALL	Channel_GetPos(HCHANNEL chn);
	virtual void		CALL	Channel_SetPos(HCHANNEL chn, QWORD pos);
	virtual void		CALL	Channel_SetStartPos(HCHANNEL chn, hgeChannelSyncInfo * pcsi);
	virtual void		CALL	Channel_SlideTo(HCHANNEL channel, float time, int volume, int pan = -101, float pitch = -1);
	virtual bool		CALL	Channel_IsSliding(HCHANNEL channel);
	virtual void		CALL	Channel_SetLoop(HCHANNEL channel, hgeChannelSyncInfo * pcsi);
	virtual void		CALL	Channel_RemoveLoop(HCHANNEL channel, hgeChannelSyncInfo * pcsi);

	virtual void		CALL	Input_GetMousePos(float *x, float *y);
	virtual void		CALL	Input_SetMousePos(float x, float y);
	virtual int			CALL	Input_GetMouseWheel();
	virtual bool		CALL	Input_IsMouseOver();
	virtual bool		CALL	Input_KeyDown(int key);
	virtual bool		CALL	Input_KeyUp(int key);
	virtual bool		CALL	Input_GetKeyState(int key);
	virtual char*		CALL	Input_GetKeyName(int key);
	virtual int			CALL	Input_GetKey();
	virtual int			CALL	Input_GetChar();
	virtual bool		CALL	Input_GetEvent(hgeInputEvent *event);
	//add by Thor/h5nc
	//begin
	virtual LPDIRECTINPUT8 CALL Input_GetDevice();
	virtual bool		CALL	Input_GetDIKey(int key, BYTE stateType = DIKEY_PRESSED);
	virtual bool		CALL	Input_SetDIKey(int key, bool set = true);
	virtual bool		CALL	Input_GetDIJoy(int joy, BYTE stateType = DIKEY_PRESSED, int joydevice=0);
	virtual bool		CALL	Input_HaveJoy(int joydevice=0);
	//end

	virtual bool		CALL	Gfx_BeginScene(HTARGET target=0);
	virtual void		CALL	Gfx_EndScene();
	virtual void		CALL	Gfx_Clear(DWORD color);
	virtual void		CALL	Gfx_RenderLine(float x1, float y1, float x2, float y2, DWORD color=0xFFFFFFFF, float z=0.5f);
	virtual void		CALL	Gfx_RenderTriple(const hgeTriple *triple);
	virtual void		CALL	Gfx_RenderQuad(const hgeQuad *quad);
	virtual hgeVertex*	CALL	Gfx_StartBatch(int prim_type, HTEXTURE tex, int blend, int *max_prim);
	virtual void		CALL	Gfx_FinishBatch(int nprim);
	virtual void		CALL	Gfx_SetClipping(int x=0, int y=0, int w=0, int h=0);
	virtual void		CALL	Gfx_SetTransform(float x=0, float y=0, float dx=0, float dy=0, float rot=0, float hscale=0, float vscale=0); 
	virtual void		CALL	Gfx_SetTransform(D3DTRANSFORMSTATETYPE State, CONST D3DMATRIX * pMatrix);

	virtual HTARGET		CALL	Target_Create(int width, int height, bool zbuffer);
	virtual void		CALL	Target_Free(HTARGET target);
	virtual HTEXTURE	CALL	Target_GetTexture(HTARGET target);

	virtual HTEXTURE	CALL	Texture_Create(int width, int height);
	virtual HTEXTURE	CALL	Texture_Load(const char *filename, DWORD size=0, bool bMipmap=false);
	virtual void		CALL	Texture_Free(HTEXTURE tex);
	virtual int			CALL	Texture_GetWidth(HTEXTURE tex, bool bOriginal=false);
	virtual int			CALL	Texture_GetHeight(HTEXTURE tex, bool bOriginal=false);
	virtual DWORD*		CALL	Texture_Lock(HTEXTURE tex, bool bReadOnly=true, int left=0, int top=0, int width=0, int height=0);
	virtual void		CALL	Texture_Unlock(HTEXTURE tex);

	
	/* font support 
	add by Yuki */
	//edit by Thor/h5nc
	// begin
	virtual HD3DFONT    CALL	Font_Load(const char * fontStyle, int height);
	virtual void		CALL	Font_Free(HD3DFONT font);
	virtual int			CALL	Gfx_RenderText(HD3DFONT font, const char * text, float x, float y, float w, float h, DWORD color = 0xffffffff);
	virtual int			CALL	Gfx_RenderTextToTarget(HTEXTURE * tex, HTARGET tar, HD3DFONT font, const char * text, float x, float y, float w, float h, DWORD color = 0xffffffff);
    // end
	//////// Implementation ////////

	static HGE_Impl*	_Interface_Get();
	void				_FocusChange(bool bAct);
	void				_PostError(char *error);

	bool				bActive;
	char				szError[256];
	char				szAppPath[_MAX_PATH];
	/************************************************************************/
	/* This member is added by h5nc (h5nc@yahoo.com.cn)                     */
	/************************************************************************/
	char				szResourcePath[_MAX_PATH];
	char				szIniString[256];


	/************************************************************************/
	/* These members are added by h5nc (h5nc@yahoo.com.cn)                  */
	/************************************************************************/
	// begin
	bool				b2DMode;
	hge3DPoint			ptfar;
	// end

	// System States
	bool				(*procFrameFunc)();
	bool				(*procRenderFunc)();
	bool				(*procFocusLostFunc)();
	bool				(*procFocusGainFunc)();
	bool				(*procGfxRestoreFunc)();
	bool				(*procExitFunc)();
	const char*			szIcon;
	char				szWinTitle[256];
	int					nScreenWidth;
	int					nScreenHeight;
	int					nScreenBPP;
	bool				bWindowed;
	bool				bZBuffer;
	bool				bTextureFilter;
	char				szIniFile[_MAX_PATH];
	char				szLogFile[_MAX_PATH];
	/************************************************************************/
	/* This member is added by h5nc (h5nc@yahoo.com.cn)                     */
	/************************************************************************/
	char				szBassDllFile[_MAX_PATH];
	bool				bUseSound;
	int					nSampleRate;
	int					nFXVolume;
	int					nStreamVolume;
	int					nSampleVolume;
	int					nHGEFPS;
	bool				bHideMouse;
	bool				bDontSuspend;
	/************************************************************************/
	/* These members are added by h5nc (h5nc@yahoo.com.cn)                  */
	/************************************************************************/
	// begin
	HINSTANCE			hInstance;
	HWND				hwnd;
	// end
	HWND				hwndParent;

	// Graphics
	D3DPRESENT_PARAMETERS*  d3dpp;
	IDirect3D9*				pD3D;
	IDirect3DDevice9*		pD3DDevice;

	D3DPRESENT_PARAMETERS   d3dppW;
	RECT					rectW;
	LONG					styleW;

	D3DPRESENT_PARAMETERS   d3dppFS;
	RECT					rectFS;
	LONG					styleFS;

	IDirect3DVertexBuffer9*	pVB;
	IDirect3DIndexBuffer9*	pIB;

	IDirect3DSurface9*	pScreenSurf;
	IDirect3DSurface9*	pScreenDepth;
	CRenderTargetList*	pTargets;
	CRenderTargetList*	pCurTarget;

	D3DXMATRIX			matView;
	D3DXMATRIX			matProj;

	CTextureList*		textures;
	hgeVertex*			VertArray;

	int					nPrim;
	int					CurPrimType;
	int					CurBlendMode;
	HTEXTURE			CurTexture;

	bool				_GfxInit();
	void				_GfxDone();
	bool				_GfxRestore();
	void				_AdjustWindow();
	void				_Resize(int width, int height);
	bool				_init_lost();
	void				_render_batch(bool bEndScene=false);
	int					_format_id(D3DFORMAT fmt);
	void				_SetBlendMode(int blend);
	void				_SetProjectionMatrix(int width, int height);
	

	// Audio
	HINSTANCE			hBass;
	bool				bSilent;
	CStreamList*		streams;
	bool				_SoundInit();
	void				_SoundDone();
	void				_SetSampleVolume(int vol);
	void				_SetStreamVolume(int vol);
	void				_SetFXVolume(int vol);


	// Input
	int					VKey;
	int					Char;
	int					Zpos;
	float				Xpos;
	float				Ypos;
	bool				bMouseOver;
	bool				bCaptured;
	char				keyz[256];
	CInputEventList*	queue;
	void				_UpdateMouse();
	void				_InputInit();
	void				_ClearQueue();
	void				_BuildEvent(int type, int key, int scan, int flags, int x, int y);

	/************************************************************************/
	/* These lines are added by h5nc (h5nc@yahoo.com.cn)                    */
	/************************************************************************/
	// begin
	#define	ERROR_NOKEYBOARD	0x10
	#define ERROR_NOJOYSTICK	0x20

	BYTE				keyState[256];
	BYTE				lastKeyState[256];
	LPDIRECTINPUT8		lpDInput;
	LPDIRECTINPUTDEVICE8 lpDIKDevice;
	LPDIRECTINPUTDEVICE8 lpDIJDevice[DIJOY_MAXDEVICE];
	DIJOYSTATE          joyState[DIJOY_MAXDEVICE];
	DIJOYSTATE          lastJoyState[DIJOY_MAXDEVICE];
	bool				haveJoy[DIJOY_MAXDEVICE];
	static GUID			joyGuid[DIJOY_MAXDEVICE];

	int					_DIInit();
	void				_DIRelease();
	int					_DIUpdate();
	static BOOL CALLBACK _EnumJoysticksCallback (const DIDEVICEINSTANCE * pdidInstance, VOID* pContext);
	// end


	// Resources
	char				szTmpFilename[_MAX_PATH];
	/************************************************************************/
	/* This member is added by h5nc (h5nc@yahoo.com.cn)                     */
	/************************************************************************/
	char				szPackFirstFilename[_MAX_PATH];
	CResourceList*		res;
	HANDLE				hSearch;
	WIN32_FIND_DATA		SearchData;


	// Timer
	float				fTime;
	float				fDeltaTime;
	/************************************************************************/
	/* This member is added by h5nc (h5nc@yahoo.com.cn)                     */
	/************************************************************************/
	float				fFPS;
	/************************************************************************/
	/* These members are deleted by h5nc (h5nc@yahoo.com.cn)                */
	/************************************************************************/
	/*
	DWORD				nFixedDelta;
	int					nFPS;
	DWORD				t0, t0fps, dt;
	int					cfps;
	*/


	/************************************************************************/
	/* These members are added by h5nc (h5nc@yahoo.com.cn)                  */
	/************************************************************************/
	int					nFrameCounter;
	int					nFrameSkip;
	int					nRenderSkip;


	/************************************************************************/
	/* These lines are added by Yuki                                        */
	/************************************************************************/
	/* font 
	add by Yuki */
	void				_FontDone();
	CFontList *			fontList;
private:
	HGE_Impl();
};

extern HGE_Impl*		pHGE;

#endif


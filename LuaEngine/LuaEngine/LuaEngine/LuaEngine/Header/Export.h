#ifndef _EXPORT_H
#define _EXPORT_H

#include "MainDependency.h"

class Export
{
public:
	Export();
	~Export();
public:
	static HGE * InitHGE();
	static HGE * ReleaseHGE();

	static void Release(LuaState * ls = NULL);

	static int LoadLuaFile(LuaState * ls, const char * filename, bool bDoFile = false, int * filecount = NULL, FILE * outputfile = NULL);
private:
	static int _LoadLuaFile(LuaState * ls, const char * filename, bool bDoFile = false, int * filecount = NULL, FILE * outputfile = NULL);
public:
	static int DoLuaFile(LuaState * ls, const char * filename){return LoadLuaFile(ls, filename, true);};

	static int DoLuaFileInMemroy(LuaState * ls, const char * buffer, DWORD size, const char * name);

	static bool CheckUseUnpackedFiles(LuaState * ls);
	static int PackLuaFiles(LuaState * ls);
	static int LoadPackedLuaFiles(LuaState * ls);

	static int LuaChunkWriter(lua_State *L, const void* p, size_t sz, void* ud);

	static int ReadLuaFileTableAndConst(LuaState * ls);

	static void ShowError(int errortype, const char * err);
public:
	static HGE * hge;
};

#endif
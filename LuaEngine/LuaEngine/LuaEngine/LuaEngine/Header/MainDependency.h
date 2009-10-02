#ifndef _MAINDEPENDENCY_H
#define _MAINDEPENDENCY_H

#include "Const.h"

#include "../../hge/include/hge.h"
#include "../../hge/include/hgefont.h"
#include "../../hge/include/hgesprite.h"
#include "../../hge/include/hgeeffectsystem.h"

#pragma warning(disable:4244)
#pragma warning(disable:4800)
#pragma warning(disable:504)

#pragma comment(lib, "winmm.lib")
#ifdef _DEBUG
	#pragma comment(lib, "hge_d.lib")
	#pragma comment(lib, "hgehelp_d.lib")
#else
	#pragma comment(lib, "hge.lib")
	#pragma comment(lib, "hgehelp.lib")
#endif // _DEBUG
#pragma comment(lib, "bass.lib")
#pragma comment(lib, "d3d9.lib")
#pragma comment(lib, "d3dx9.lib")

#include <windows.h>

#include <vector>
#include <list>
#include <xstring>

using namespace std;
#include <LuaPlus.h>
using namespace LuaPlus;

#endif
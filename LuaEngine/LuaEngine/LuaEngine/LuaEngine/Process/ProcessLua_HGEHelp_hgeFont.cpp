#include "../Header/Process.h"
#include "../Header/LuaConstDefine.h"

hgeFont * Process::_Helper_New_hgeFont()
{
	hgeFont * _font = NULL;
	_font = new hgeFont();
	if (_font)
	{
		fontList.push_back(_font);
	}
	return _font;
}

hgeFont * Process::_Helper_New_hgeFont(const char * filename, bool bMipmap/* =false */)
{
	hgeFont * _font = NULL;
	_font = new hgeFont(filename, bMipmap);
	if (_font)
	{
		fontList.push_back(_font);
	}
	return _font;
}

hgeFont * Process::_LuaHelper_hgeFont_Get(LuaStack * args)
{
	LuaObject _obj = (*args)[1];
	return (hgeFont *)_LuaHelper_GetDWORD(&_obj);
}

void Process::_LuaHelper_hgeFont_DeleteFont(hgeFont * _font)
{
	if (_font)
	{
		delete _font;
		for (list<hgeFont *>::iterator it=fontList.begin(); it!=fontList.end(); it++)
		{
			if ((*it) == _font)
			{
				it = fontList.erase(it);
			}
		}
		_font = NULL;
	}
}

void Process::_LuaHelper_hgeFont_DeleteAllFont()
{
	hgeFont * _font;
	for (list<hgeFont *>::iterator it=fontList.begin(); it!=fontList.end(); it++)
	{
		_font = *it;
		if (_font)
		{
			delete _font;
			_font = NULL;
		}
	}
	fontList.clear();
}

int Process::LuaFn_hgeFont_NewFont(LuaState * ls)
{
	LuaStack args(ls);
	DWORD dret = 0;
	char * filename = 0;
	bool bMipmap = false;

	hgeFont * _font = NULL;
	int argscount = args.Count();
	if (argscount > 0)
	{
		filename = (char *)(args[1].GetString());
		if (argscount > 1)
		{
			bMipmap = args[2].GetBoolean();
		}
		_font = _Helper_New_hgeFont(filename, bMipmap);
	}
	else
	{
		_font = _Helper_New_hgeFont();
	}
	dret = (DWORD)_font;

	_LuaHelper_PushDWORD(ls, dret);
	return 1;
}

int Process::LuaFn_hgeFont_DeleteFont(LuaState * ls)
{
	LuaStack args(ls);

	if (args.Count() > 0)
	{
		hgeFont * _font = _LuaHelper_hgeFont_Get(&args);
		_LuaHelper_hgeFont_DeleteFont(_font);
	}
	else
	{
		_LuaHelper_hgeFont_DeleteAllFont();
	}

	return 0;
}

int Process::LuaFn_hgeFont_Render(LuaState * ls)
{
	LuaStack args(ls);
	hgeFont * _font = _LuaHelper_hgeFont_Get(&args);

	_font->Render(args[2].GetFloat(), args[3].GetFloat(), args[4].GetInteger(), args[5].GetString());

	return 0;
}

int Process::LuaFn_hgeFont_printfb(LuaState * ls)
{
	LuaStack args(ls);
	hgeFont * _font = _LuaHelper_hgeFont_Get(&args);

	_font->printfb(args[2].GetFloat(), args[3].GetFloat(), args[4].GetFloat(), args[5].GetFloat(), args[6].GetInteger(), args[7].GetString());

	return 0;
}

int Process::LuaFn_hgeFont_SetColor(LuaState * ls)
{
	LuaStack args(ls);
	hgeFont * _font = _LuaHelper_hgeFont_Get(&args);
	LuaObject _obj;

	if (args.Count() > 1)
	{
		DWORD col[4];
		for (int i=0; i<4; i++)
		{
			_obj = args[i+2];
			col[i] = _LuaHelper_GetColor(&_obj);
		}
		_font->SetColor(col[0], col[1], col[2], col[3]);
	}
	else
	{
		DWORD col;
		_obj = args[2];
		col = _LuaHelper_GetColor(&_obj);
		_font->SetColor(col);
	}

	return 0;
}

int Process::LuaFn_hgeFont_SetZ(LuaState * ls)
{
	LuaStack args(ls);
	hgeFont * _font = _LuaHelper_hgeFont_Get(&args);

	_font->SetZ(args[2].GetFloat());

	return 0;
}

int Process::LuaFn_hgeFont_SetBlendMode(LuaState * ls)
{
	LuaStack args(ls);
	hgeFont * _font = _LuaHelper_hgeFont_Get(&args);

	_font->SetBlendMode(args[2].GetInteger());

	return 0;
}

int Process::LuaFn_hgeFont_SetScale(LuaState * ls)
{
	LuaStack args(ls);
	hgeFont * _font = _LuaHelper_hgeFont_Get(&args);

	_font->SetScale(args[2].GetFloat());

	return 0;
}

int Process::LuaFn_hgeFont_SetProportion(LuaState * ls)
{
	LuaStack args(ls);
	hgeFont * _font = _LuaHelper_hgeFont_Get(&args);

	_font->SetProportion(args[2].GetFloat());

	return 0;
}

int Process::LuaFn_hgeFont_SetRotation(LuaState * ls)
{
	LuaStack args(ls);
	hgeFont * _font = _LuaHelper_hgeFont_Get(&args);

	_font->SetRotation(args[2].GetFloat());

	return 0;
}

int Process::LuaFn_hgeFont_SetTracking(LuaState * ls)
{
	LuaStack args(ls);
	hgeFont * _font = _LuaHelper_hgeFont_Get(&args);

	_font->SetTracking(args[2].GetFloat());

	return 0;
}

int Process::LuaFn_hgeFont_SetSpacing(LuaState * ls)
{
	LuaStack args(ls);
	hgeFont * _font = _LuaHelper_hgeFont_Get(&args);

	_font->SetSpacing(args[2].GetFloat());

	return 0;
}

int Process::LuaFn_hgeFont_GetColor(LuaState * ls)
{
	LuaStack args(ls);
	hgeFont * _font = _LuaHelper_hgeFont_Get(&args);
	DWORD dret;
	int i=0;

	if (args.Count() > 0)
	{
		i = args[i].GetInteger();
	}
	dret = _font->GetColor(i);

	_LuaHelper_PushDWORD(ls, dret);
	return 1;
}

int Process::LuaFn_hgeFont_GetZ(LuaState * ls)
{
	LuaStack args(ls);
	hgeFont * _font = _LuaHelper_hgeFont_Get(&args);
	float fret;

	fret = _font->GetZ();

	ls->PushNumber(fret);
	return 1;
}

int Process::LuaFn_hgeFont_GetBlendMode(LuaState * ls)
{
	LuaStack args(ls);
	hgeFont * _font = _LuaHelper_hgeFont_Get(&args);
	int iret;

	iret = _font->GetBlendMode();

	ls->PushInteger(iret);
	return 1;
}

int Process::LuaFn_hgeFont_GetScale(LuaState * ls)
{
	LuaStack args(ls);
	hgeFont * _font = _LuaHelper_hgeFont_Get(&args);
	float fret;

	fret = _font->GetScale();

	ls->PushNumber(fret);
	return 1;
}

int Process::LuaFn_hgeFont_GetProportion(LuaState * ls)
{
	LuaStack args(ls);
	hgeFont * _font = _LuaHelper_hgeFont_Get(&args);
	float fret;

	fret = _font->GetProportion();

	ls->PushNumber(fret);
	return 1;
}

int Process::LuaFn_hgeFont_GetRotation(LuaState * ls)
{
	LuaStack args(ls);
	hgeFont * _font = _LuaHelper_hgeFont_Get(&args);
	float fret;

	fret = _font->GetRotation();

	ls->PushNumber(fret);
	return 1;
}

int Process::LuaFn_hgeFont_GetTracking(LuaState * ls)
{
	LuaStack args(ls);
	hgeFont * _font = _LuaHelper_hgeFont_Get(&args);
	float fret;

	fret = _font->GetTracking();

	ls->PushNumber(fret);
	return 1;
}

int Process::LuaFn_hgeFont_GetSpacing(LuaState * ls)
{
	LuaStack args(ls);
	hgeFont * _font = _LuaHelper_hgeFont_Get(&args);
	float fret;

	fret = _font->GetSpacing();

	ls->PushNumber(fret);
	return 1;
}

int Process::LuaFn_hgeFont_ChangeSprite(LuaState * ls)
{
	LuaStack args(ls);
	hgeFont * _font = _LuaHelper_hgeFont_Get(&args);
	LuaObject _obj;
	float pre_a=-1;
	float pre_c=-1;

	int argscount = args.Count();
	if (argscount > 5)
	{
		_obj = args[3];
		HTEXTURE _htexture = (HTEXTURE)(_LuaHelper_GetDWORD(&_obj));
		if (argscount > 7)
		{
			pre_a = args[8].GetFloat();
			if (argscount > 8)
			{
				pre_c = args[9].GetFloat();
			}
		}
		_font->ChangeSprite(args[2].GetInteger(), _htexture, args[4].GetFloat(), args[5].GetFloat(), args[6].GetFloat(), args[7].GetFloat(), pre_a, pre_c);
	}
	else
	{
		_obj = args[3];
		hgeSprite * _hgesprite = (hgeSprite *)(_LuaHelper_GetDWORD(&_obj));
		if (argscount > 3)
		{
			pre_a = args[4].GetFloat();
			if (argscount > 4)
			{
				pre_c = args[5].GetFloat();
			}
		}
		_font->ChangeSprite(args[2].GetInteger(), _hgesprite, pre_a, pre_c);
	}

	return 0;
}

int Process::LuaFn_hgeFont_GetSprite(LuaState * ls)
{
	LuaStack args(ls);
	hgeFont * _font = _LuaHelper_hgeFont_Get(&args);
	DWORD dret;

	dret = (DWORD)(_font->GetSprite(args[2].GetInteger()));

	_LuaHelper_PushDWORD(ls, dret);
	return 1;
}

int Process::LuaFn_hgeFont_GetPreWidth(LuaState * ls)
{
	LuaStack args(ls);
	hgeFont * _font = _LuaHelper_hgeFont_Get(&args);
	float fret;

	fret = _font->GetPreWidth(args[2].GetInteger());

	ls->PushNumber(fret);
	return 1;
}

int Process::LuaFn_hgeFont_GetPostWidth(LuaState * ls)
{
	LuaStack args(ls);
	hgeFont * _font = _LuaHelper_hgeFont_Get(&args);
	float fret;

	fret = _font->GetPostWidth(args[2].GetInteger());

	ls->PushNumber(fret);
	return 1;
}

int Process::LuaFn_hgeFont_GetHeight(LuaState * ls)
{
	LuaStack args(ls);
	hgeFont * _font = _LuaHelper_hgeFont_Get(&args);
	float fret;

	fret = _font->GetHeight();

	ls->PushNumber(fret);
	return 1;
}

int Process::LuaFn_hgeFont_GetStringWidth(LuaState * ls)
{
	LuaStack args(ls);
	hgeFont * _font = _LuaHelper_hgeFont_Get(&args);
	float fret;
	bool bMultiline=true;

	if (args.Count() > 2)
	{
		bMultiline = args[3].GetBoolean();
	}
	fret = _font->GetStringWidth(args[2].GetString(), bMultiline);

	ls->PushNumber(fret);
	return 1;
}
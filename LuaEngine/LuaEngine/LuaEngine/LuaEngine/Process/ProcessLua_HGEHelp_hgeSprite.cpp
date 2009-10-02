#include "../Header/Process.h"
#include "../Header/LuaConstDefine.h"

hgeSprite * Process::_Helper_New_hgeSprite()
{
	hgeSprite * _sprite = NULL;
	_sprite = new hgeSprite();
	if (_sprite)
	{
		spriteList.push_back(_sprite);
	}
	return _sprite;
}

hgeSprite * Process::_Helper_New_hgeSprite(HTEXTURE tex, float x, float y, float w, float h)
{
	hgeSprite * _sprite = NULL;
	_sprite = new hgeSprite(tex, x, y ,w, h);
	if (_sprite)
	{
		spriteList.push_back(_sprite);
	}
	return _sprite;
}

hgeSprite * Process::_Helper_New_hgeSprite(const hgeSprite & spr)
{
	hgeSprite * _sprite = NULL;
	_sprite = new hgeSprite(spr);
	if (_sprite)
	{
		spriteList.push_back(_sprite);
	}
	return _sprite;
}


hgeSprite * Process::_LuaHelper_hgeSprite_Get(LuaStack * args)
{
	LuaObject _obj = (*args)[1];
	return (hgeSprite *)_LuaHelper_GetDWORD(&_obj);
}

void Process::_LuaHelper_hgeSprite_DeleteSprite(hgeSprite * _sprite)
{
	if (_sprite)
	{
		delete _sprite;
		for (list<hgeSprite *>::iterator it=spriteList.begin(); it!=spriteList.end(); it++)
		{
			if ((*it) == _sprite)
			{
				it = spriteList.erase(it);
			}
		}
		_sprite = NULL;
	}
}

void Process::_LuaHelper_hgeSprite_DeleteAllSprite()
{
	hgeSprite * _sprite;
	for (list<hgeSprite *>::iterator it=spriteList.begin(); it!=spriteList.end(); it++)
	{
		_sprite = *it;
		if (_sprite)
		{
			delete _sprite;
			_sprite = NULL;
		}
	}
	spriteList.clear();
}

int Process::LuaFn_hgeSprite_NewSprite(LuaState * ls)
{
	LuaStack args(ls);
	DWORD dret = 0;
	hgeSprite * _sprite = NULL;

	int argscount = args.Count();
	if (argscount > 0)
	{
		LuaObject _obj;
		if (argscount > 1)
		{
			_obj = args[1];
			HTEXTURE _htexture = (HTEXTURE)(_LuaHelper_GetDWORD(&_obj));
			float x = args[2].GetFloat();
			float y = args[3].GetFloat();
			float w = args[4].GetFloat();
			float h = args[5].GetFloat();
			_sprite = _Helper_New_hgeSprite(_htexture, x, y, w, h);
		}
		else
		{
			_obj = args[1];
			hgeSprite * __sprite = (hgeSprite *)(_LuaHelper_GetDWORD(&_obj));
			_sprite = _Helper_New_hgeSprite(*__sprite);
		}
	}
	else
	{
		_sprite = _Helper_New_hgeSprite();
	}
	dret = (DWORD)_sprite;

	_LuaHelper_PushDWORD(ls, dret);
	return 1;
}

int Process::LuaFn_hgeSprite_DeleteSprite(LuaState * ls)
{
	LuaStack args(ls);

	if (args.Count() > 0)
	{
		hgeSprite * _sprite = _LuaHelper_hgeSprite_Get(&args);
		_LuaHelper_hgeSprite_DeleteSprite(_sprite);
	}
	else
	{
		_LuaHelper_hgeSprite_DeleteAllSprite();
	}

	return 0;
}

int Process::LuaFn_hgeSprite_Render(LuaState * ls)
{
	LuaStack args(ls);
	hgeSprite * _sprite = _LuaHelper_hgeSprite_Get(&args);

	int argscount = args.Count();

	if (argscount > 2)
	{
		float rot = 0.0f;
		float hscale=1.0f;
		float vscale=0.0f;
		if (argscount > 3)
		{
			if (!args[4].IsNil())
			{
				rot = args[4].GetFloat();
			}
			if (argscount > 4)
			{
				if (!args[5].IsNil())
				{
					hscale = args[5].GetFloat();
				}
				if (argscount > 5)
				{
					if (!args[6].IsNil())
					{
						vscale = args[6].GetFloat();
					}
				}
			}
		}
		_sprite->RenderEx(args[2].GetFloat(), args[3].GetFloat(), rot, hscale, vscale);
	}
	else
	{
		_sprite->Render(args[2].GetFloat(), args[3].GetFloat());
	}

	return 0;
}

int Process::LuaFn_hgeSprite_RenderStretch(LuaState * ls)
{
	LuaStack args(ls);
	hgeSprite * _sprite = _LuaHelper_hgeSprite_Get(&args);

	_sprite->RenderStretch(args[2].GetFloat(), args[3].GetFloat(), args[4].GetFloat(), args[5].GetFloat());

	return 0;
}

int Process::LuaFn_hgeSprite_Render4V(LuaState * ls)
{
	LuaStack args(ls);
	hgeSprite * _sprite = _LuaHelper_hgeSprite_Get(&args);

	_sprite->Render4V(args[2].GetFloat(), args[3].GetFloat(), args[4].GetFloat(), args[5].GetFloat(), args[6].GetFloat(), args[7].GetFloat(), args[8].GetFloat(), args[9].GetFloat());

	return 0;
}

int Process::LuaFn_hgeSprite_SetTexture(LuaState * ls)
{
	LuaStack args(ls);
	hgeSprite * _sprite = _LuaHelper_hgeSprite_Get(&args);

	LuaObject _obj = args[2];
	HTEXTURE _htexture = (HTEXTURE)(_LuaHelper_GetDWORD(&_obj));
	_sprite->SetTexture(_htexture);

	return 0;
}

int Process::LuaFn_hgeSprite_SetTextureRect(LuaState * ls)
{
	LuaStack args(ls);
	hgeSprite * _sprite = _LuaHelper_hgeSprite_Get(&args);
	bool adjSize = true;

	if (args.Count() > 5)
	{
		adjSize = args[6].GetBoolean();
	}
	_sprite->SetTextureRect(args[2].GetFloat(), args[3].GetFloat(), args[4].GetFloat(), args[5].GetFloat(), adjSize);

	return 0;
}

int Process::LuaFn_hgeSprite_SetColor(LuaState * ls)
{
	LuaStack args(ls);
	hgeSprite * _sprite = _LuaHelper_hgeSprite_Get(&args);

	int argscount = args.Count();
	LuaObject _obj;
	if (argscount > 3)
	{
		DWORD col[4];
		for (int i=0; i<4; i++)
		{
			_obj = args[i+2];
			col[i] = _LuaHelper_GetColor(&_obj);
		}
		_sprite->SetColor(col[0], col[1], col[2], col[3]);
	}
	else
	{
		int i=-1;
		if (argscount > 2)
		{
			i = args[3].GetInteger();
		}
		DWORD col;
		_obj = args[2];
		col = _LuaHelper_GetColor(&_obj);
		_sprite->SetColor(col, i);
	}

	return 0;
}

int Process::LuaFn_hgeSprite_SetZ(LuaState * ls)
{
	LuaStack args(ls);
	hgeSprite * _sprite = _LuaHelper_hgeSprite_Get(&args);

	int argscount = args.Count();
	if (argscount > 3)
	{
		_sprite->SetZ(args[2].GetFloat(), args[3].GetFloat(), args[4].GetFloat(), args[5].GetFloat());
	}
	else
	{
		int i=-1;
		if (argscount > 2)
		{
			i = args[3].GetInteger();
		}
		_sprite->SetZ(args[2].GetFloat(), i);
	}
	
	return 0;
}

int Process::LuaFn_hgeSprite_SetBlendMode(LuaState * ls)
{
	LuaStack args(ls);
	hgeSprite * _sprite = _LuaHelper_hgeSprite_Get(&args);

	_sprite->SetBlendMode(args[2].GetInteger());

	return 0;
}

int Process::LuaFn_hgeSprite_SetHotSpot(LuaState * ls)
{
	LuaStack args(ls);
	hgeSprite * _sprite = _LuaHelper_hgeSprite_Get(&args);

	_sprite->SetHotSpot(args[2].GetFloat(), args[3].GetFloat());

	return 0;
}

int Process::LuaFn_hgeSprite_SetFlip(LuaState * ls)
{
	LuaStack args(ls);
	hgeSprite * _sprite = _LuaHelper_hgeSprite_Get(&args);
	bool bHotSpot = false;

	if (args.Count() > 3)
	{
		bHotSpot = args[4].GetBoolean();
	}
	_sprite->SetFlip(args[2].GetBoolean(), args[3].GetBoolean(), bHotSpot);

	return 0;
}

int Process::LuaFn_hgeSprite_GetTexture(LuaState * ls)
{
	LuaStack args(ls);
	hgeSprite * _sprite = _LuaHelper_hgeSprite_Get(&args);
	DWORD dret;

	dret = (DWORD)(_sprite->GetTexture());

	_LuaHelper_PushDWORD(ls, dret);
	return 1;
}

int Process::LuaFn_hgeSprite_GetTextureRect(LuaState * ls)
{
	LuaStack args(ls);
	hgeSprite * _sprite = _LuaHelper_hgeSprite_Get(&args);
	float x;
	float y;
	float w;
	float h;

	_sprite->GetTextureRect(&x, &y, &w, &h);

	ls->PushNumber(x);
	ls->PushNumber(y);
	ls->PushNumber(w);
	ls->PushNumber(h);
	return 4;
}

int Process::LuaFn_hgeSprite_GetColor(LuaState * ls)
{
	LuaStack args(ls);
	hgeSprite * _sprite = _LuaHelper_hgeSprite_Get(&args);
	DWORD dret;
	int i=0;

	if (args.Count() > 1)
	{
		i = args[2].GetInteger();
	}
	dret = _sprite->GetColor(i);

	_LuaHelper_PushDWORD(ls, dret);
	return 1;
}

int Process::LuaFn_hgeSprite_GetZ(LuaState * ls)
{
	LuaStack args(ls);
	hgeSprite * _sprite = _LuaHelper_hgeSprite_Get(&args);
	float fret;
	int i=0;

	if (args.Count() > 1)
	{
		i = args[2].GetInteger();
	}
	fret = _sprite->GetZ(i);

	ls->PushNumber(fret);
	return 1;
}

int Process::LuaFn_hgeSprite_GetBlendMode(LuaState * ls)
{
	LuaStack args(ls);
	hgeSprite * _sprite = _LuaHelper_hgeSprite_Get(&args);
	int iret;

	iret = _sprite->GetBlendMode();

	ls->PushInteger(iret);
	return 1;
}

int Process::LuaFn_hgeSprite_GetHotSpot(LuaState * ls)
{
	LuaStack args(ls);
	hgeSprite * _sprite = _LuaHelper_hgeSprite_Get(&args);
	float x;
	float y;

	_sprite->GetHotSpot(&x, &y);

	ls->PushNumber(x);
	ls->PushNumber(y);
	return 2;
}

int Process::LuaFn_hgeSprite_GetFlip(LuaState * ls)
{
	LuaStack args(ls);
	hgeSprite * _sprite = _LuaHelper_hgeSprite_Get(&args);
	bool bX;
	bool bY;

	_sprite->GetFlip(&bX, &bY);

	ls->PushBoolean(bX);
	ls->PushBoolean(bY);
	return 2;
}

int Process::LuaFn_hgeSprite_GetWidth(LuaState * ls)
{
	LuaStack args(ls);
	hgeSprite * _sprite = _LuaHelper_hgeSprite_Get(&args);
	float fret;

	fret = _sprite->GetWidth();

	ls->PushNumber(fret);
	return 1;
}

int Process::LuaFn_hgeSprite_GetHeight(LuaState * ls)
{
	LuaStack args(ls);
	hgeSprite * _sprite = _LuaHelper_hgeSprite_Get(&args);
	float fret;

	fret = _sprite->GetHeight();

	ls->PushNumber(fret);
	return 1;
}

int Process::LuaFn_hgeSprite_GetBoundingBox(LuaState * ls)
{
	LuaStack args(ls);
	hgeSprite * _sprite = _LuaHelper_hgeSprite_Get(&args);
	hgeRect rect;

	if (args.Count() > 3)
	{
		_sprite->GetBoundingBoxEx(args[2].GetFloat(), args[3].GetFloat(), args[4].GetFloat(), args[5].GetFloat(), args[6].GetFloat(), &rect);
	}
	else
	{
		_sprite->GetBoundingBox(args[2].GetFloat(), args[3].GetFloat(), &rect);
	}

	ls->PushNumber(rect.x1);
	ls->PushNumber(rect.y1);
	ls->PushNumber(rect.x2-rect.x1);
	ls->PushNumber(rect.y2-rect.y1);
	return 4;
}
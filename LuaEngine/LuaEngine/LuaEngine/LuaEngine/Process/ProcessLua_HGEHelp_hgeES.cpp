#include "../Header/Process.h"
#include "../Header/LuaConstDefine.h"

hgeEffectSystem * Process::_Helper_New_hgeES()
{
	hgeEffectSystem * _es = NULL;
	_es = new hgeEffectSystem();
	if (_es)
	{
		esList.push_back(_es);
	}
	return _es;
}

hgeEffectSystem * Process::_Helper_New_hgeES(const char * filename, HTEXTURE tex /* = 0 */, HTEXTURE * texset /* = 0 */)
{
	hgeEffectSystem * _es = NULL;
	_es = new hgeEffectSystem(filename, tex, texset);
	if (_es)
	{
		esList.push_back(_es);
	}
	return _es;
}

hgeEffectSystem * Process::_Helper_New_hgeES(const hgeEffectSystem & eff)
{
	hgeEffectSystem * _es = NULL;
	_es = new hgeEffectSystem(eff);
	if (_es)
	{
		esList.push_back(_es);
	}
	return _es;
}

hgeEffectSystem * Process::_LuaHelper_hgeES_Get(LuaStack * args)
{
	LuaObject _obj = (*args)[1];
	return (hgeEffectSystem *)_LuaHelper_GetDWORD(&_obj);
}

void Process::_LuaHelper_hgeES_DeleteES(hgeEffectSystem * _es)
{
	if (_es)
	{
		delete _es;
		for (list<hgeEffectSystem *>::iterator it=esList.begin(); it!=esList.end(); it++)
		{
			if ((*it) == _es)
			{
				it = esList.erase(it);
			}
		}
		_es = NULL;
	}
}

void Process::_LuaHelper_hgeES_DeleteAllES()
{
	hgeEffectSystem * _es;
	for (list<hgeEffectSystem *>::iterator it=esList.begin(); it!=esList.end(); it++)
	{
		_es = *it;
		if (_es)
		{
			delete _es;
			_es = NULL;
		}
	}
	esList.clear();
}

int Process::LuaFn_hgeES_NewES(LuaState * ls)
{
	LuaStack args(ls);
	DWORD dret = 0;
	hgeEffectSystem * _es = NULL;

	int argscount = args.Count();
	if (argscount > 0)
	{
		LuaObject _obj;
		if (!args[1].IsNumber())
		{
			HTEXTURE _htexture = 0;
			if (argscount > 1)
			{
				_obj = args[2];
				_htexture = (HTEXTURE)(_LuaHelper_GetDWORD(&_obj));
			}
			const char * filename = args[1].GetString();
			_es = _Helper_New_hgeES(filename, _htexture, texset);
		}
		else
		{
			_obj = args[1];
			hgeEffectSystem * __es = (hgeEffectSystem *)(_LuaHelper_GetDWORD(&_obj));
			_es = _Helper_New_hgeES(*__es);
		}
	}
	else
	{
		_es = _Helper_New_hgeES();
	}
	dret = (DWORD)_es;

	_LuaHelper_PushDWORD(ls, dret);
	return 1;
}

int Process::LuaFn_hgeES_DeleteES(LuaState * ls)
{
	LuaStack args(ls);

	if (args.Count() > 0)
	{
		hgeEffectSystem * _es = _LuaHelper_hgeES_Get(&args);
		_LuaHelper_hgeES_DeleteES(_es);
	}
	else
	{
		_LuaHelper_hgeES_DeleteAllES();
	}

	return 0;
}

int Process::LuaFn_hgeES_Load(LuaState * ls)
{
	LuaStack args(ls);
	hgeEffectSystem * _es = _LuaHelper_hgeES_Get(&args);
	int iret;
	HTEXTURE tex=0;
	HTEXTURE * texset=0;

	int argscount = args.Count();
	if (argscount > 2)
	{
		LuaObject _obj;
		_obj = args[3];
		tex = (HTEXTURE)(_LuaHelper_GetDWORD(&_obj));
		if (argscount > 3)
		{
			_obj = args[4];
			texset = (HTEXTURE *)(_LuaHelper_GetDWORD(&_obj));
		}
	}
	iret = _es->Load(args[2].GetString(), tex, texset);

	ls->PushInteger(iret);
	return 1;
}

int Process::LuaFn_hgeES_Save(LuaState * ls)
{
	LuaStack args(ls);
	hgeEffectSystem * _es = _LuaHelper_hgeES_Get(&args);
	bool bret;
	int _texnum=-1;

	if (args.Count() > 2)
	{
		_texnum = args[3].GetInteger();
	}
	bret = _es->Save(args[2].GetString(), _texnum);

	ls->PushBoolean(bret);
	return 1;
}

int Process::LuaFn_hgeES_Render(LuaState * ls)
{
	LuaStack args(ls);
	hgeEffectSystem * _es = _LuaHelper_hgeES_Get(&args);

	_es->Render();

	return 0;
}

int Process::LuaFn_hgeES_MoveTo(LuaState * ls)
{
	LuaStack args(ls);
	hgeEffectSystem * _es = _LuaHelper_hgeES_Get(&args);
	float z = 0;
	bool bForce = false;

	int argscount = args.Count();
	if (argscount > 3)
	{
		z = args[4].GetFloat();
		if (argscount > 4)
		{
			bForce = args[5].GetBoolean();
		}
	}
	_es->MoveTo(args[2].GetFloat(), args[3].GetFloat(), z, bForce);

	return 0;
}

int Process::LuaFn_hgeES_Fire(LuaState * ls)
{
	LuaStack args(ls);
	hgeEffectSystem * _es = _LuaHelper_hgeES_Get(&args);

	_es->Fire();

	return 0;
}

int Process::LuaFn_hgeES_Stop(LuaState * ls)
{
	LuaStack args(ls);
	hgeEffectSystem * _es = _LuaHelper_hgeES_Get(&args);
	bool bKill = false;

	if (args.Count() > 1)
	{
		bKill = args[2].GetBoolean();
	}
	_es->Stop(bKill);

	return 0;
}

int Process::LuaFn_hgeES_Update(LuaState * ls)
{
	LuaStack args(ls);
	hgeEffectSystem * _es = _LuaHelper_hgeES_Get(&args);

	_es->Update();

	return 0;
}

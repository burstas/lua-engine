#include "../Header/Process.h"

#ifdef __NOTUSELUA

bool Process::FrameFuncSelf()
{
	return false;
}

bool Process::RenderFuncSelf()
{
	return false;
}

bool Process::FocusLostFuncSelf()
{
	return false;
}

bool Process::FocusGainFuncSelf()
{
	return false;
}

bool Process::GfxRestoreFuncSelf()
{
	return false;
}

bool Process::ExitFuncSelf()
{
	return true;
}

#endif
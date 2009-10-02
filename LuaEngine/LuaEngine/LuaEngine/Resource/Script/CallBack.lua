function hgeFrameFunc()
	if hge.Input_GetDIKey(DIK_BACK, DIKEY_DOWN) then
		mp:Release();
		luastate.Reload();
		return false;
	end
	if hge.Input_GetDIKey(mp.keyEscape) then
		return true;
	end
	if hge.Input_GetDIKey(mp.keyCapture, DIKEY_DOWN) then
		mp:SnapShot();
	end
	if mp:Frame() == PQUIT then
		return true;
	end
	return false;
end

function hgeRenderFunc()
	hge.Gfx_BeginScene();
	hge.Gfx_Clear(0);
	
	mp:Render();

	hge.Gfx_EndScene();
	return false;
end

function hgeFocusLostFunc()
	return true;
end

function hgeFocusGainFunc()
	return true;
end

function hgeGfxRestoreFunc()
	return true;
end

function hgeExitFunc()
	mp:Release();
	return true;
end
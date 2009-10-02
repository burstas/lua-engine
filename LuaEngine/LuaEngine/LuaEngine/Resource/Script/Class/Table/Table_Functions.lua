function Table:_GetCell(linestr, charformat, initpos)
	local startpos;
	local endpos;
	local substr;
	startpos, endpos = string.find(linestr, "[^\t]+\t", initpos)
	if startpos == nil then
		startpos, endpos = string.find(linestr, "[^\t]+", initpos);
		substr = string.sub(linestr, startpos, endpos);
	else
		substr = string.sub(linestr, startpos, endpos-1);
	end
	
	if charformat == "n" or charformat == "f" then
		substr = tonumber(substr);
	end
	if charformat == "x" then
		substr = tonumber(substr, 16);
	end
	
	return substr, endpos;
end

function Table:_ReadLine(content, size)
	return luastate.ReadLineInContent(content, size);
end

function Table:GetTableFileData(filename, strformat)
	
	local tabledata = {};
	
	if filename == nil then
		return nil;
	end
	
	local fullfilename = hge.Resource_MakePath(filename);
	local file = io.open(fullfilename, "r");
	local content, size;
	local oringinalcontent;
	
	if file == nil then
		content, size = hge.Resource_Load(filename);
		oringinalcontent = content;
	end
	
	local linestr;
	if file ~= nil then
		linestr = file:read();
	else
		linestr, content, size = self:_ReadLine(content, size);
	end
	local linecount = 0;
	
	strformat = string.lower(strformat);
	local ncol = string.len(strformat);
	
	for i=1, ncol do
		tabledata[i] = {};
	end
	
	local initpos;
		while true do
		if file ~= nil then
			linestr = file:read();
		else
			linestr, content, size = self:_ReadLine(content, size);
		end
		if linestr == nil or linestr == "" then
			break;
		end
		linecount = linecount + 1;
		initpos = 1;
		for i=1, ncol do
			tabledata[i][linecount], initpos = self:_GetCell(linestr, string.sub(strformat, i, i), initpos);
		end
	end
	
	if file ~= nil then
		file:close();
	else
		hge.Resource_Free(oringinalcontent);
	end
	
	return tabledata, linecount;
end
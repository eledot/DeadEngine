-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

_R = {}

g_Time = os.time();
g_Version = 0.1;
g_CurPanels = {}
g_PanelList = {}
g_Particles = {}
g_Players = {}
g_EntitiesTable = {}
g_Entities = {}
g_ClientCommands = {}

ScrW = love.graphics.getWidth;
ScrH = love.graphics.getHeight;

function CurTime()
	return os.time() - g_Time;
end

function PrintTable(tbl, t, nt)
	if( not nt ) then
		print("Table:");
	end
	local Tabs = t or 1;
	local tbs = "\t";
	if( Tabs > 1 ) then
		for i = 1, Tabs do
			tbs = tbs .. "\t";
		end
	end
	if(type(tbl) == "table") then
		for k,v in pairs(tbl) do
			if(type(v) == "table") then
				print(tbs..k..":");
				PrintTable(v, Tabs+1, true);
			else
				print(tbs..k.." = "..tostring(v));
			end
		end
	else
		print(tbs..tostring(tbl))
	end
end

function PrecacheTexture(text)
	return love.graphics.newImage(text);
end

function PrecacheSound(sound)
	return love.audio.newSource(sound);
end

function PrecacheFont(fnt)
	return love.graphics.newFont(fnt);
end

function FileEnumerateRecursive(dir, tree)
	local lfs = love.filesystem;
	local files = lfs.enumerate(dir);
	local fileTree = tree or {};
	local file = "";
	for k,v in pairs(files) do
		file = dir.."/"..v;
		if( lfs.isFile(file) ) then
			table.insert(fileTree, file);
		elseif( lfs.isDirectory(file) ) then
			fileTree = FileEnumerateRecursive(file, fileTree);
		end
	end
	return fileTree;
end

function RunString(...)
	local Pass = {...}
	eng.ConsoleLabel("lua> "..table.concat(Pass, " "), Color(22, 22, 22, 255));	
	local Func = assert(loadstring(tostring(table.concat(Pass," "))));
	Func();
end

local oldPrint = print;
function print(...)
	local textColor = (StateManager and StateManager:Color()) or Color(22, 22, 22, 255);
	local STRING = "";
	local Pass = {...};
	for k,v in pairs(Pass) do
		if( #Pass > k ) then
			STRING = STRING..v.."      ";
		else
			STRING = STRING..v;
		end
	end
	eng.ConsoleLabel(STRING, textColor);
	oldPrint(...);
end

function debugPrint(...)
	oldPrint(...);
end
	
function FindMetaTable(strMeta)
	return _R[tostring(strMeta)] or false;
end


			

				
				
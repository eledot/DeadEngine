-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

local function luaDoString(...)
	local Pass = {...}
	RunString(unpack(Pass));
end
clientcommand.Create("lua_run", luaDoString);

local function editorOpen()
	if( not eng.Editor ) then
		StateManager:Push(worldEditor);
		eng.Editor = true;
	end
end
clientcommand.Create("editor_open", editorOpen);

local function editorClose()
	if( eng.Editor ) then
		StateManager:Pop();
		eng.Editor = false;
	end
end
clientcommand.Create("editor_close", editorClose);

local function toggleFPS()
	eng.ShowFPS = not eng.ShowFPS;
end
clientcommand.Create("toggle_bench_info", toggleFPS);

local function toggleEditorGrid()
	if( worldEditor and worldEditor.MapCanvas ) then
		worldEditor.MapCanvas:ToggleGrid();
	end
end
clientcommand.Create("editor_grid", toggleEditorGrid);

local function openMap(...)
	local Pass = {...}
	g_CurrentMap = CreateMap(Pass[1]);
end
clientcommand.Create("map", openMap);

local function pushStack(...)
	local Pass = {...}
	if( Pass[1] ) then
		StateManager:Push(Pass[1]);
	end
end
clientcommand.Create("push", pushStack);

local function popStack()
	StateManager:Pop();
end
clientcommand.Create("pop", popStack);
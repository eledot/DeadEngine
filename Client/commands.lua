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

local function loadWorldEditor(...)
	if( not Engine.WorldEditorEnabled ) then
		Engine.WorldEditorEnabled = true;
		StateManager:Push(worldEditor);
	end
end
clientcommand.Create("open_worldeditor", loadWorldEditor)

local function closeWorldEditor(...)
	if( Engine.WorldEditorEnabled ) then
		Engine.WorldEditorEnabled = false;
		StateManager:Pop();
	end
end
clientcommand.Create("close_worldeditor", closeWorldEditor)

local function showFps(...)
	Engine.FPSLabel:SetText("FPS: "..love.timer.getFPS())
	Engine.FPSLabel:SetLive( not Engine.FPSLabel:Live() );
	Engine.FPSLabel.Think = function(btn)
		btn.Text = "FPS: "..love.timer.getFPS();
	end
end
clientcommand.Create("show_fps", showFps);
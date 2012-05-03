-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

local eng = {}
eng.Textures = {}
eng.Sounds = {}
eng.Fonts = {
	Default = love.graphics.newFont("fonts/Timeless.ttf")
}
eng.Editor = false;
eng.ShowFPS = false;
eng.GameTitle = "EngineTesting";
eng.TextFocused = false;
eng.Shift = false;
eng.WorldEditorEnabled = false;
eng.Characters = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", " " }
eng.SpecialChars = {
	["1"] = "!",
	["2"] = "@",
	["3"] = "#",
	["4"] = "$",
	["5"] = "%",
	["6"] = "^",
	["7"] = "&", 
	["8"] = "*",
	["9"] = "(", 
	["0"] = ")",
	["-"] = "_",
	["="] = "+",
	[","] = "<",
	["."] = ">",
	["/"] = "?",
	[";"] = ":",
	["'"] = "\"",
	["["] = "{",
	["]"] = "}",
	["\\"] = "|"
}
function eng.PrecacheAssets()
	for k,v in pairs(FileEnumerateRecursive("textures")) do
		eng.Textures[v] = PrecacheTexture(v);
	end
	for k,v in pairs(FileEnumerateRecursive("sounds")) do
		eng.Sounds[v] = PrecacheSound(v);
	end
	for k,v in pairs(FileEnumerateRecursive("fonts")) do
		eng.Fonts[v] = PrecacheFont(v);
	end
	PrintTable(eng.Fonts);
end
hook.Add("Initialize", "_Engine.AssetPrecache", eng.PrecacheAssets);

function eng.ShowFPSLabel()
	if( eng.ShowFPS ) then
		surface.SetFont("Default");
		surface.SetColor(Color(220, 220, 0, 255));
		surface.DrawText("Frames /s: "..love.timer.getFPS(), 10, 10, 200, "left");
	end
end
hook.Add("__EngineConsole", "_Engine.ShowFPSLabel", eng.ShowFPSLabel);

function eng.KeyPressed(key, uni)
	if( key == "`" ) then
		eng.CreateConsole();
		return
	end
	if( eng.TextFocused ) then
		if( eng.TextFocused.Count == eng.TextFocused.Max ) then
			return
		end
		if( key == "backspace" and  eng.TextFocused.Count > 0) then
			eng.TextFocused.Count = eng.TextFocused.Count - 1;
			eng.TextFocused.Text = string.sub(eng.TextFocused.Text, 0, eng.TextFocused.Count);
			eng.TextFocused:OnTextChanged();
			return
		end
		if( not eng.TextFocused.Number ) then
			for k,v in pairs(eng.Characters) do
				if( key == v ) then
					if( eng.Shift ) then
						eng.TextFocused.Text = eng.TextFocused.Text..string.upper(key);
						eng.TextFocused.Count = eng.TextFocused.Count + 1;
						eng.TextFocused:OnTextChanged();
					else
						eng.TextFocused.Text = eng.TextFocused.Text..string.lower(key);
						eng.TextFocused.Count = eng.TextFocused.Count + 1;
						eng.TextFocused:OnTextChanged();
					end
					return
				end
			end
		end
		for k,v in pairs(eng.SpecialChars) do
			if( key == k ) then
				if( eng.Shift and not eng.TextFocused.Number ) then
					eng.TextFocused.Text = eng.TextFocused.Text..v;
					eng.TextFocused.Count = eng.TextFocused.Count + 1;
					eng.TextFocused:OnTextChanged();
				else
					eng.TextFocused.Text = eng.TextFocused.Text..k;
					eng.TextFocused.Count = eng.TextFocused.Count + 1;
					eng.TextFocused:OnTextChanged();
				end
				return
			end
		end
		if( key == "return" ) then
			eng.TextFocused:OnReturn();
		end
	end
end
hook.Add("KeyPressed", "_Engine.KeyPressed", eng.KeyPressed);

function eng.Draw()
	if( g_CurPanels[1] and g_CurPanels[#g_CurPanels]:Live() ) then
		g_CurPanels[#g_CurPanels]:Paint()
		g_CurPanels[#g_CurPanels]:_Paint()
	end
end
hook.Add("__EngineConsole", "_Engine.Draw", eng.Draw);
function eng.Think(dt)
	if( gui.key.IsDown("lshift") or gui.key.IsDown("rshift") ) then
		eng.Shift = true;
	else
		eng.Shift = false;
	end
--	if( eng.Console and eng.Console:Live() ) then
--		eng.Console:Think();
--		eng.Console:_Think();
--	end
end
hook.Add("Think", "_Engine.Think", eng.Think);

return eng;
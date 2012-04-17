-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

require "global";

Engine = {}
Engine.GameTitle = "EngineTesting";
Engine.TextFocused = false;
Engine.Shift = false;
Engine.WorldEditorEnabled = false;
Engine.Characters = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", " " }
Engine.Fonts = {
	Default = love.graphics.getFont()
}
Engine.Tilesets = {};
Engine.Textures = {};
Engine.ShowFPS = false;
Engine.SpecialChars = {
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

require "modules.json";

hook = require "modules.hook";
math = require "modules.maths";
gui = require "modules.gui";
string = require "modules.string";
surface = require "modules.surface";
util = require "modules.util";

require "objects.color";
require "objects.player";
require "enums.partenums";
require "objects.panel";
require "objects.stack";
require "objects.state";
require "objects.clientcommand";
require "objects.mapcanvas";
--require "objects.map";
require "objects.entity";

--map = require "modules.map";
--entity = require "modules.entity";
player = require "modules.player";
panel = require "modules.panel";
clientcommand = require "modules.clientcommand";

require "gui.frame";
require "gui.textentry";
require "gui.label";
require "gui.button";
require "gui.scroll";
require "gui.link";
require "gui.img";
require "gui.slider";

require "gui.console";

require "commands";

require "game.main";
gameMain = require "game.game";
gameMenu = require "game.menu";
worldEditor = require "game.editor";
splashScreen = require "game.splash";

Engine.FPSLabel = panel.Create("TextLabel")
Engine.FPSLabel:SetPos(0, 0)
Engine.FPSLabel:SetWide(300)

function love.load()
	Engine.ConsoleLabel("Loading Engine...", Color(100, 255, 133, 255)); 
	Engine.ConsoleLabel("Precaching Images...", Color(100, 255, 133, 255));
	for k,v in pairs(FileEnumerateRecursive("textures")) do
		Engine.Textures[v] = love.graphics.newImage(v);
	end
	Engine.ConsoleLabel("Precaching Tiles...", Color(100, 255, 133, 255));
	for k,v in pairs(FileEnumerateRecursive("tilesets")) do
		Engine.Tilesets[v] = love.graphics.newImage(v);
	end
	Engine.ConsoleLabel("[[----------DeadEngine----------]]", Color(100, 100, 255, 255), "left");
	Engine.ConsoleLabel("[[----By Dropdead-Studios----]]", Color(100, 100, 255, 255), "left");
	Engine.ConsoleLabel("----------------------------------------------------------------------------", Color(255,255,255,255), "left");
	StateManager = Stack();
	StateManager:Push(gameMenu, true);
	StateManager:Push(splashScreen);
	hook.Call("Initialize");
end

function love.update(dt)
	if( gui.key.IsDown("lshift") or gui.key.IsDown("rshift") ) then
		Engine.Shift = true;
	else
		Engine.Shift = false;
	end
	hook.Call("Think");
	StateManager:Think(dt);
	if( Engine.Console and Engine.Console:Live() ) then
		Engine.Console:Think();
		Engine.Console:NoOverride();
	end
end

function love.draw()
	StateManager:ScreenDraw();
	hook.Call("ScreenDraw");
	StateManager:HudDraw();
	hook.Call("HudDraw");
	hook.Call("__GUIDraw");

	if( Engine.Console and Engine.Console:Live() ) then
		Engine.Console:Paint();
		Engine.Console:NoOverridePaint();
	end
end

function love.keypressed(key, uni)
	if( key == "`" ) then
		Engine.CreateConsole();
		return
	end
	if( Engine.TextFocused ) then
		if( Engine.TextFocused.Count == Engine.TextFocused.Max ) then
			return
		end
		if( key == "backspace" and  Engine.TextFocused.Count > 0) then
			Engine.TextFocused.Count = Engine.TextFocused.Count - 1;
			Engine.TextFocused.Text = string.sub(Engine.TextFocused.Text, 0, Engine.TextFocused.Count);
			Engine.TextFocused:OnTextChanged();
			return
		end
		for k,v in pairs(Engine.Characters) do
			if( key == v ) then
				if( Engine.Shift ) then
					Engine.TextFocused.Text = Engine.TextFocused.Text..string.upper(key);
					Engine.TextFocused.Count = Engine.TextFocused.Count + 1;
					Engine.TextFocused:OnTextChanged();
				else
					Engine.TextFocused.Text = Engine.TextFocused.Text..string.lower(key);
					Engine.TextFocused.Count = Engine.TextFocused.Count + 1;
					Engine.TextFocused:OnTextChanged();
				end
				return
			end
		end
		for k,v in pairs(Engine.SpecialChars) do
			if( key == k ) then
				if( Engine.Shift ) then
					Engine.TextFocused.Text = Engine.TextFocused.Text..v;
					Engine.TextFocused.Count = Engine.TextFocused.Count + 1;
					Engine.TextFocused:OnTextChanged();
				else
					Engine.TextFocused.Text = Engine.TextFocused.Text..k;
					Engine.TextFocused.Count = Engine.TextFocused.Count + 1;
					Engine.TextFocused:OnTextChanged();
				end
				return
			end
		end
		if( key == "return" ) then
			Engine.TextFocused:OnReturn();
		end
	end
	StateManager:KeyPressed(key, uni);
end

function love.keyreleased(key, uni)
	StateManager:KeyReleased(key, uni)
end

function love.quit()
	StateManager:Shutdown();
	hook.Call("Shutdown");
	for i = 1, #StateManager.States do
		StateManager:Pop();
	end
end



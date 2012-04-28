-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

socket = require "socket";
-- Require global first, because it's got some important shit.
require "global";

-- Json cause it's amazing.
require "modules.json";

-- All our objects, leaving us with a false sense of OOP in Lua. Order is pretty important, as some rely on others.
require "objects.color";
require "objects.state";
require "objects.stack";
require "objects.panel";
require "objects.clientcommand";
require "objects.block";
require "objects.mapcanvas";

-- Now for our modules, doing it like this actually has no meaning whatsoever it just makes me look like I know what I'm doing.
math = require "modules.maths";
string = require "modules.string";
hook = require "modules.hook";
surface = require "modules.surface";
gui = require "modules.gui";
panel = require "modules.panel";
clientcommand = require "modules.clientcommand";
network = require "modules.network";
simplex = require "modules.simplex";

-- Our Gui elements.
require "gui.frame";
require "gui.button";
require "gui.scroll";
require "gui.slider";
require "gui.label";
require "gui.textentry";
require "gui.progress";

eng = require "engine";

require "console";
require "commands";

-- Game states, yeaaa.
gameSplash = require "game.splash";
worldEditor = require "game.editor";


function love.load(arg)
	love.graphics.setBackgroundColor(100, 100, 100, 255)
	hook.Call("Initialize", arg);
	StateManager = Stack();
	StateManager:Push(gameSplash);
end

function love.update(dt)
	StateManager:Think(dt);
	hook.Call("Think", dt);
end

function love.focus(f)
	StateManager:Focus(f);
	hook.Call("Focus", f);
end

function love.keypressed(k, u)
	StateManager:KeyPressed(k,u);
	hook.Call("KeyPressed", k, u);
end

function love.keyreleased(k, u)
	StateManager:KeyReleased(k,u);
	hook.Call("KeyReleased", k, u);
end

function love.mousepressed(x,y,b)
	StateManager:MousePressed(x,y,b);
	hook.Call("MousePressed", x, y, b);
end

function love.mousereleased(x,y,b)
	StateManager:MouseReleased(x,y,b);
	hook.Call("MouseReleased", x, y, b);
end

function love.draw()
	StateManager:ScreenDraw();
	hook.Call("ScreenDraw");
	StateManager:HudDraw();
	hook.Call("HudDraw");
	hook.Call("__EngineDraw");
	hook.Call("__EngineConsole");
end

function love.quit()
	hook.Call("Shutdown");
	for i = 1, #StateManager.States do
		StateManager:Pop();
	end
end
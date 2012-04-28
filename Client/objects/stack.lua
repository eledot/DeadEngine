-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

_R.Stack = {}
_R.Stack.__index = _R.Stack;

function Stack()
	local stack = {}
	stack.States = {};
	setmetatable(stack, _R.Stack);
	return stack;
end

function _R.Stack:Push(state)
	local NumberStack = #self.States;
	if( NumberStack > 0 ) then
		self:Shutdown();
	end
	self.States[NumberStack+1] = state;
	self:Init();
end

function _R.Stack:Pop()
	local NumberStack = #self.States;
	self.States[NumberStack]:Shutdown();
	self.States[NumberStack] = nil;
	NumberStack = #self.States;
	if( NumberStack > 0 ) then
		self.States[NumberStack]:Init();
	end
end

function _R.Stack:GetCurrentState()
	local NumberStack = #self.States;
	if( NumberStack > 0 ) then
		return self.States[NumberStack];
	end
end

function _R.Stack:Init()
	local NumberStack = #self.States;
	if( NumberStack > 0 ) then
		self.States[NumberStack]:Init();
	end
end

function _R.Stack:MousePressed(x,y,b)
	local NumberStack = #self.States;
	if( NumberStack > 0 ) then
		self.States[NumberStack]:MousePressed(x,y,b);
	end
end

function _R.Stack:MouseReleased(x,y,b)
	local NumberStack = #self.States;
	if( NumberStack > 0 ) then
		self.States[NumberStack]:MouseReleased(x,y,b);
	end
end

function _R.Stack:Focus(f)
	local NumberStack = #self.States;
	if( NumberStack > 0 ) then
		self.States[NumberStack]:Focus(f);
	end
end

function _R.Stack:Color()
	local NumberStack = #self.States;
	if( NumberStack > 0 ) then
		return self.States[NumberStack].TextColor;
	end
	return Color(22, 22, 22, 255);
end

function _R.Stack:HudDraw()
	local NumberStack = #self.States;
	if( NumberStack > 0 ) then
		self.States[NumberStack]:HudDraw();
	end
end

function _R.Stack:Think(dt)
	local NumberStack = #self.States;
	if( NumberStack > 0 ) then
		self.States[NumberStack]:Think(dt);
	end
end

function _R.Stack:KeyPressed(k, u)
	local NumberStack = #self.States;
	if( NumberStack > 0 ) then
		self.States[NumberStack]:KeyPressed(k, u);
	end
end

function _R.Stack:KeyReleased(k, u)
	local NumberStack = #self.States;
	if( NumberStack > 0 ) then
		self.States[NumberStack]:KeyReleased(k, u);
	end
end

function _R.Stack:ScreenDraw()
	local NumberStack = #self.States;
	if( NumberStack > 0 ) then
		self.States[NumberStack]:ScreenDraw();
	end
end

function _R.Stack:Shutdown()
	local NumberStack = #self.States;
	if( NumberStack > 0 ) then
		self.States[NumberStack]:Shutdown();
	end
end
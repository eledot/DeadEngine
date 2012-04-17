-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

_R.State = {}
_R.State.__index = _R.State;

function State()
	local State = {}
	setmetatable(State, _R.State);
	return State;
end

function _R.State:Init()
end
function _R.State:Update()
end
function _R.State:HudDraw()
end
function _R.State:ScreenDraw()
end
function _R.State:Think()
end
function _R.State:Shutdown()
end
function _R.State:KeyPressed(k, u)
end
function _R.State:KeyReleased(k, u)
end
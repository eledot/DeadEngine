-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

local Test = State();

function Test:Init()
	g_CurrentMap = CreateMap("wert");
end

local kd = gui.key.IsDown
function Test:Think()
	if( g_CurrentMap ) then
		if( kd("up") ) then
			g_CurrentMap:Move(0, g_CurrentMap.BlockSize);
		elseif( kd("right") ) then
			g_CurrentMap:Move(-g_CurrentMap.BlockSize, 0);
		elseif( kd("down") ) then
			g_CurrentMap:Move(0, -g_CurrentMap.BlockSize);
		elseif( kd("left") ) then
			g_CurrentMap:Move(g_CurrentMap.BlockSize, 0);
		end
	end
end

function Test:ScreenDraw()
	if( g_CurrentMap ) then
		g_CurrentMap:Paint();
	end
end

return Test;



-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

_R.Map = {}
_R.Map.__index = _R.Map;

function Map(name)
	local map = {}
	if( name and love.filesystem.exists("maps/"..tostring(name)) ) then
		map = love.filesystem.load("maps/"..tostring(name));
		map = json.decode(map);
		setmetatable(map, _R.Map);
	end
	return map;
end

function _R.Map:Init()
end

function _R.Map:GetOnScreenObjects()
	local ObjectTable = {}
	local Count = 1;
	for k,v in pairs(self.Layers.Environment) do
		if( v.PosX + v.iW > 0 and v.PosX < ScrW() ) then
			ObjectTable[Count] = v;
			Count = Count + 1;
		end
	end
	for k,v in pairs(entity.GetAll()) do
		if( v.Pos.x + v.Size.w > 0 and v.Pos.x < ScrW() and v.Pos.y + v.Size.h > 0 and v.Pos.y < ScrH() ) then
			v.PosY = v.Pos.y;
			v.iH = v.Size.h;
			ObjectTable[Count] = v;
			Count = Count + 1;
		end
	end
	return ObjectTable;
end

function _R.Map:Think()
end

function _R.Map:Move(x, y)
end

function _R.Map:SetPos(x, y)
end

function _R.Map:PaintGroundLayer()
end

function _R.Map:PaintEnvironmentLayer()
end

function _R.Map:Paint()
end
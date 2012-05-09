-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

_R.Map = {}
_R.Map.__index = _R.Map;

function CreateMap(strMapName)

	local MapTable = {}
	if( love.filesystem.exists("maps") and love.filesystem.exists("maps/"..strMapName..".dmf") ) then
		local map = json.decode(love.filesystem.read("maps/"..strMapName..".dmf"));
		MapTable.Name = map.Name;
		map = map.Canvas;
		MapTable.Size = { x = map.Size.x, y = map.Size.y };
		MapTable.BlockSize = map.BlockSize;
		MapTable.Pos = { x = 0, y = 0 };
		MapTable.Blocks = {}
		
		local blk
		for k, v in pairs(map.Blocks) do
			MapTable.Blocks[tonumber(k)] = {}
			for i, j in pairs(v) do
				blk = Block(tonumber(k), tonumber(i), MapTable)
				blk.Collide = j.Collide;
				blk.Color = Color(j.Color.r, j.Color.g, j.Color.b, j.Color.a);
				blk.Size = j.Size;
				blk.defTexture = eng.Textures[j.defTexture];
				
				MapTable.Blocks[tonumber(k)][tonumber(i)] = blk;
			end
		end
		
	end
	
	setmetatable(MapTable, _R.Map)
	return MapTable;

end

function _R.Map:GetName()
	return self.Name;
end

function _R.Map:SetPos(x, y)
	self.Pos.x, self.Pos.y = x, y;
end

function _R.Map:GetPos()
	return self.Pos.x, self.Pos.y;
end

function _R.Map:Move(x, y)
	local ScreenWide = (self.Size.x*self.BlockSize);
	local ScreenTall = (self.Size.y*self.BlockSize);
	ScreenWide = ScreenWide < ScrW() and ScreenWide or ScrW();
	ScreenTall = ScreenTall < ScrH() and ScreenTall or ScrH();
	self.Pos.x = math.Clamp(self.Pos.x + x, -(self.Size.x*self.BlockSize)+ScreenWide, 0);
	self.Pos.y = math.Clamp(self.Pos.y + y, -(self.Size.y*self.BlockSize)+ScreenTall, 0);
end

function _R.Map:Paint()
	for x = math.floor(math.abs(self.Pos.x)/self.BlockSize), math.floor((math.abs(self.Pos.x)+ScrW())/self.BlockSize)+1 do
		if( self.Blocks[x] ) then
			for y = math.floor(math.abs(self.Pos.y)/self.BlockSize), math.floor((math.abs(self.Pos.y)+ScrH())/self.BlockSize)+1 do
				if( self.Blocks[x][y] ) then
					self.Blocks[x][y]:Paint();
				end
			end
		end
	end
end
	
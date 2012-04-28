-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

_R.MapCanvas = {}
_R.MapCanvas.__index = _R.MapCanvas;

function Map(bx, by)
	local map = {};
	map.Pos = {x = 0, y = 0};
	map.BlockSize = 16;
	map.Size = {bX = bx, bY = by};
	map.Blocks = {};
	map.Grid = false;
	map.DefaultTexture = eng.Textures["textures/ground/grass_light16.png"];
	setmetatable(map, _R.MapCanvas);
	return map;
end

function _R.MapCanvas:CreateBlocks(strMap)
	local newBlock;
	local newMap = self:LoadMap(strMap);
	if( newMap.BlockSize ) then
		self.Blocks = newMap.Blocks;
		self.Size = newMap.Size;
		self.BlockSize = newMap.BlockSize;
	else
		for j = 0, self.Size.bY-1 do
			for i = 0, self.Size.bX-1 do
				newBlock = Block(i, j, self);
				newBlock:SetSize(self.BlockSize)
				newBlock.defTexture = self.DefaultTexture;
				table.insert(self.Blocks, newBlock);
			end
		end
	end
end

function _R.MapCanvas:LoadMap(strMap)
	local map = {}
	if( strMap and love.filesystem.exists("maps_save/"..strMap) ) then
		map = json.decode(love.filesystem.read("maps_save/"..strMap));
	end
	return map;
end

function _R.MapCanvas:ImportData(tbl)
	self:SetSize(tbl.Size.x, tbl.Size.y);
	self:SetBlockSize(tbl.BlockSize);
	self.Blocks = {}
	for i = 1, #tbl.Blocks do
		local newBlock = Block( tbl.Blocks[i].Pos.x, tbl.Blocks[i].Pos.y, self );
		newBlock.Collide = tbl.Blocks[i].Collide;
		newBlock.Color = Color( tbl.Blocks[i].Color.r, tbl.Blocks[i].Color.g, tbl.Blocks[i].Color.b, tbl.Blocks[i].Color.a );
		newBlock.Size = tbl.Blocks[i].Size;
		newBlock.defTexture = eng.Textures[tbl.Blocks[i].defTexture];
		self.Blocks[i] = newBlock;
	end
end

local function getFromTexture(txt)
	for k,v in pairs(eng.Textures) do
		if( v == txt ) then
			return k
		end
	end
end

function _R.MapCanvas:ExportData()
	local CanvasTable = {}
	CanvasTable.Size = { x = self.Size.bX, y = self.Size.By };
	CanvasTable.BlockSize = self.BlockSize;
	CanvasTable.Blocks = {};
	CanvasTable.DefaultTexture = getFromTexture(self.DefaultTexture);
	for i = 1, #self.Blocks do
		CanvasTable.Blocks[i] = self.Blocks[i]:Export();
	end
	return CanvasTable;
end

function _R.MapCanvas:ToggleGrid()
	self.Grid = not self.Grid;
end

function _R.MapCanvas:SetBlockSize(s)
	if( not s == 16 or not s == 32 or not s == 64 ) then
		self.BlockSize = 16;
		return
	end
	self.BlockSize = tonumber(s) or 16;
end

function _R.MapCanvas:GetBlockSize()
	return self.BlockSize;
end

function _R.MapCanvas:Move(x, y)
	self.Pos.x = self.Pos.x + x;
	self.Pos.y = self.Pos.y + y;
end

function _R.MapCanvas:SetPos(x, y)
	self.Pos.x, self.Pos.y = x, y;
end

function _R.MapCanvas:GetPos()
	return self.Pos.x, self.Pos.y;
end

function _R.MapCanvas:SetSize(bx, by)
	self.Size.bX, self.Size.bY = bx, by;
end

function _R.MapCanvas:GetSize()
	return self.Size.bX, self.Size.bY;
end

function _R.MapCanvas:BlockVisible(blk)
	local bPosx = self.Pos.x + (self.BlockSize*blk.Pos.x);
	local bPosy = self.Pos.y + (self.BlockSize*blk.Pos.y);
	return ( bPosx + self.BlockSize > 0 and bPosx < ScrW() and bPosy + self.BlockSize > 0 and bPosy < ScrH() );
end

local nearest;
local dist;
function _R.MapCanvas:GetNearestBlock(x, y)
	nearest = 9999;
	for k,v in pairs(self:GetAllVisible()) do
		dist = math.Distance(x, y, self.Pos.x+(v.Pos.x*self.BlockSize)+self.BlockSize/2, self.Pos.y+(self.BlockSize*v.Pos.y)+self.BlockSize/2);
		if( dist < nearest ) then
			nearest = dist;
			self.Nearest = v;
		end
	end
	return self.Nearest;
end

function _R.MapCanvas:GetAllVisible()
	local tab = {}
	for k,v in pairs(self.Blocks) do
		if( self:BlockVisible(v) ) then
			table.insert(tab, v);
		end
	end
	return tab;
end

function _R.MapCanvas:Paint()
	for k,v in pairs(self:GetAllVisible()) do
		v:Paint();
		if( v:Solid() ) then
			surface.SetColor(Color(255, 100, 100, 100));
			surface.DrawRect(self.Pos.x+(self.BlockSize*v.Pos.x), self.Pos.y+(self.BlockSize*v.Pos.y), self.BlockSize, self.BlockSize);
		end
	end
	if( self.Grid ) then
		surface.SetColor(0, 0, 0, 60);
		for i = 1, ScrH()/self.BlockSize do
			surface.DrawLine(0, i*self.BlockSize, ScrW(), i*self.BlockSize);
		end
		for i = 1, ScrW()/self.BlockSize do
			surface.DrawLine(i*self.BlockSize, 0, i*self.BlockSize, ScrH());
		end
	end
end
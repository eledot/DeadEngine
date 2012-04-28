-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

_R.Block = {}
_R.Block.__index = _R.Block;

function Block(x, y, mapobj)
	local block = {};
	block.Pos = {x = x, y = y};
	block.Size = 16;
	block.defTexture = eng.Textures["textures/ground/grass_light16.png"];
	block.Collide = false;
	block.Color = Color(255, 255, 255, 255);
	block.Map = mapobj;
	setmetatable(block, _R.Block);
	return block;
end

local function getFromTexture(txt)
	for k,v in pairs(eng.Textures) do
		if( v == txt ) then
			return k
		end
	end
end

function _R.Block:Export()
	local blockData = {
		Pos = { x = self.Pos.x, y = self.Pos.y },
		Size = self.Size,
		Collide = self.Collide,
		Color = { r = self.Color.r, g = self.Color.g, b = self.Color.b, a = self.Color.a },
		defTexture = getFromTexture(self.defTexture)
	}
	return blockData;
end

function _R.Block:SetPos(x, y)
	self.Pos.x, self.Pos.y = x, y;
end

function _R.Block:SetColor(col)
	self.Color = col or Color(255, 255, 255, 255);
end

function _R.Block:GetColor()
	return self.Color;
end

function _R.Block:SetQuad(quad)
	self.Quad = quad;
end

function _R.Block:GetQuad()
	return self.Quad;
end

function _R.Block:GetPos()
	return self.Pos.x, self.Pos.y;
end

function _R.Block:SetSize(w)
	self.Size = w;
end

function _R.Block:GetSize()
	return self.Size;
end

function _R.Block:SetTexture(text)
	self.Texture = eng.Textures[text] or eng.Textures["textures/ground/grass_light16.png"];
end

function _R.Block:GetTexture()
	return self.Texture;
end

function _R.Block:Collision(b)
	self.Collide = b or false;
end

function _R.Block:Solid()
	return self.Collide;
end

local texture
function _R.Block:Paint()
	texture = self:GetTexture() or self.defTexture;
	surface.SetColor(self.Color);
	if( self:GetQuad() ) then
		love.graphics.drawq(texture, self:GetQuad(), self.Map.Pos.x+(self.Size*self.Pos.x), self.Map.Pos.y+(self.Size*self.Pos.y))
	else
		love.graphics.draw(texture, self.Map.Pos.x+(self.Size*self.Pos.x), self.Map.Pos.y+(self.Size*self.Pos.y))
	end
end
-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

_R.Player = {}
_R.Player.__index = _R.Player;

function Player()
	local player = {
		Color = Color(255, 255, 255, 255),
		Pos = { x = 200, y = 200 },
		Rotation = 0,
		Model = "",
		Name = "Unnamed",
		CurMap = "None",
		Speed = 3,
		Inventory = {},
		Money = 15,
		Health = 100,
		Armor = 0
	}
	setmetatable(player, _R.Player)
	return player;
end

function _R.Player:GetInventory()
	return self.Inventory;
end

function _R.Player:AddInventory(item, amnt)
	self.Inventory[tostring(item)] = ( self.Inventory[tostring(item)] and self.Inventory[tostring(item)] + amnt ) or amnt;
end

function _R.Player:CheckInventory(item, amnt)
	return ( self.Inventory[item] and self.Inventory[item] >= amnt );
end

function _R.Player:TakeInventory(item, amnt)
	if( self:CheckInventory(item, amnt+1) ) then
		self.Inventory[item] = self.Inventory[item] - amnt;
	else
		self.Inventory[item] = nil;
	end
end


function _R.Player:ModifyCash(amnt)
	self.Cash = self.Cash + amnt;
end

function _R.Player:GetCash(amnt)
	if( amnt ) then
		return self.Cash >= amnt;
	else
		return self.Cash;
	end
end

function _R.Player:SetHealth(amnt, b)
	if( b ) then
		self.Health = self.Health + amnt;
	else
		self.Health = amnt;
	end
end

function _R.Player:GetHealth(amnt)
	if( amnt ) then
		return self.Health >= amnt;
	else
		return self.Health;
	end
end

function _R.Player:SetArmor(amnt, b)
	if( b ) then
		self.Armor = self.Armor + amnt;
	else
		self.Armor = amnt;
	end
end

function _R.Player:GetArmor(amnt)
	if( amnt ) then
		return self.Armor >= amnt;
	else
		return self.Armor;
	end
end
		
function _R.Player:SetColor(r, g, b, a)
	self.Color:SetColor(r, g, b, a)
end

function _R.Player:GetColor()
	return self.Color:GetRGB();
end

function _R.Player:SetPos(x, y)
	self.Pos.x = x;
	self.Pos.y = y;
end

function _R.Player:GetPos()
	return self.Pos.x, self.Pos.y;
end

function _R.Player:SetRotation(r)
	self.Rotation = r;
end

function _R.Player:GetRotation()
	return self.Rotation;
end

function _R.Player:GetName()
	return self.Name;
end

function _R.Player:SetName(nm)
	self.Name = tostring(nm) or "";
end

function _R.Player:GetModel()
	return self.Model;
end

function _R.Player:SetModel(mdl)
	self.Model = tostring(mdl) or "";
end

function _R.Player:GetMap()
	return self.CurMap;
end

function _R.Player:GetSpeed()
	return self.Speed;
end 

function _R.Player:Paint()
	love.graphics.setColor(self.Color.r, self.Color.g, self.Color.b, self.Color.a);
end
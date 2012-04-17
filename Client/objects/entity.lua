-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

_R.Entity = {}
_R.Entity.__index = _R.Entity;

function Entity()
	local entity = {
		Pos = { x = 0, y = 0 },
		Size = { w = 0, h = 0 },
		Speed = 0,
		MapEnt = false,
		Type = "base_ent"
	}
	setmetatable(entity, _R.Entity);
	return entity;
end

function _R.Entity:Init()
end

function _R.Entity:SetPos(x, y)
	self.Pos.x = tonumber(x);
	self.Pos.y = tonumber(y);
end

function _R.Entity:Kill()
	entity.Kill(self);
end

function _R.Entity:SetSize(w,h)
	self.Size.w, self.Size.h = w, h;
end

function _R.Entity:SetSpeed(s)
	self.Speed = tonumber(s);
end

function _R.Entity:MappingEnt(b)
	self.MapEnt = b;
end

function _R.Entity:MoveTo()
end

function _R.Entity:Think()
end

function _R.Entity:Paint()
end
-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

_R.Color = {}
_R.Color.__index = _R.Color;

function Color(r, g, b, a)
	local Alpha = a;
	if( Alpha == nil ) then
		Alpha = 255;
	end
	local col = { r = r, g = g, b = b, a = Alpha }
	setmetatable(col, _R.Color)
	return col
end

function _R.Color:__tostring()
	return "R = "..self.r..", G = "..self.g..", B = "..self.b..", A = "..self.a;
end

function _R.Color:__add(col)
	if( type(col) == "table" and getmetatable(col) == _R.Color ) then
		self.r = math.Clamp(self.r + col.r, 0, 255);
		self.g = math.Clamp(self.g + col.g, 0, 255);
		self.b = math.Clamp(self.b + col.b, 0, 255);
		self.a = math.Clamp(self.a + col.a, 0, 255);
	elseif( type(col) == "number" ) then
		self.r = math.Clamp(self.r + col, 0, 255);
		self.g = math.Clamp(self.g + col, 0, 255);
		self.b = math.Clamp(self.b + col, 0, 255);
		self.a = math.Clamp(self.a + col, 0, 255);
	end
	return self
end

function _R.Color:GetRGB()
	return self;
end

function _R.Color:SetAlpha(n)
	self.a = math.Clamp(n, 0, 255);
end

function _R.Color:GetAlpha()
	return self.a;
end

function _R.Color:SetColor(r, g, b, a)
	self.r = math.Clamp(r, 0, 255);
	self.g = math.Clamp(g, 0, 255);
	self.b = math.Clamp(b, 0, 255);
	self.a = math.Clamp(a, 0, 255);
end
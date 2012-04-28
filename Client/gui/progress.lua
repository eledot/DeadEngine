-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

local PROGRESS = {}

function PROGRESS:Init()
	self.Text = "";
	self.MaxProgress = 100;
	self.CurProgress = 0;
	self.BarColor = Color(255, 130, 130, 255);
	self.TextColor = Color(22, 22, 22, 255);
end

function PROGRESS:Add()
	self.CurProgress = math.Clamp(self.CurProgress+1, 0, self.MaxProgress);
end

function PROGRESS:SetMax(n)
	self.MaxProgress = n;
end

function PROGRESS:SetBarColor(col)
	self.BarColor = col;
end

function PROGRESS:SetTextColor(col)
	self.TextColor = col;
end

function PROGRESS:MaxedOut()
	return self.CurProgress >= self.MaxProgress;
end

function PROGRESS:AddText(t)
	self.Text = t;
	self.tW, self.tH = surface.GetFont():getWidth(self.Text), surface.GetFont():getHeight();
end

function PROGRESS:GetPercentage()
	return self.CurProgress / self.MaxProgress;
end

function PROGRESS:GetBarWidth()
	return (self.Size.w-2) * self:GetPercentage();
end

function PROGRESS:Paint()
	surface.SetColor(self.BorderColor);
	surface.DrawOutlinedRect(self.Pos.x, self.Pos.y, self.Size.w, self.Size.h)
	surface.SetColor(self.Color)
	surface.DrawRect(self.Pos.x+1, self.Pos.y+1, self.Size.w-2, self.Size.h-2);
	surface.SetColor(self.BarColor)
	surface.DrawRect(self.Pos.x+1, self.Pos.y+1, self:GetBarWidth(), self.Size.h-2);
	if( self.Text ~= "" ) then
		surface.SetColor(self.TextColor)
		surface.DrawText(self.Text, (self.Pos.x + ( (self.Size.w-2) / 2) - self.tW/2), (self.Pos.y + ((self.Size.h-2) / 2) - self.tH/2), self.tW, "center");
	end
end

panel.Register(PROGRESS, "Progress")
	
	
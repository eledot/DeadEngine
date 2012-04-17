-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

local PANEL = {}

function PANEL:Init()
	self.Buttons = {};
	self.Color = Color( 120, 120, 120, 255);
	self.BorderColor = Color(170, 170, 170, 255);
	self.Padding = 2;
end

function PANEL:AddList(list)
	local ListPosX = 2;
	for k,v in pairs(self.Buttons) do
		ListPosX = ListPosX + v.ActualPos.x + self.Padding;
	end
	list:SetPos(ListPosX, v.ActualPos.y);
	table.insert(self.Buttons, list)
end

function PANEL:SetColor(col)
	self.Color = col or self.Color;
end

function PANEL:Paint()
	surface.SetColor(self.BorderColor.r, self.BorderColor.g, self.BorderColor.b, self.BorderColor.a);
	surface.DrawOutlinedRect(self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
	surface.SetColor(self.Color.r, self.Color.g, self.Color.b, self.Color.a);
	surface.DrawRect(self.Pos.x + 1, self.Pos.y + 1, self.Size.w - 2, self.Size.h - 2);
end

panel.Register(PANEL, "FileBar")
	
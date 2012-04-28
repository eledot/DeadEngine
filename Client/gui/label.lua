-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

local LABEL = {}

function LABEL:Init()
	self.Text = "";
	self.MaxWidth = 999;
	self.Color = Color(22,22,22,255);
	self.Aligns = "left";
end

function LABEL:Align(t)
	self.Aligns = tostring(t) or "left";
end

function LABEL:SetWide(n)
	self.MaxWidth = tonumber(n) or self.MaxWidth;
end

function LABEL:SetText(t)
	self.Text = tostring(t) or self.Text;
end

function LABEL:SetColor(col)
	self.Color = col or Color(255,255,255,255);
end

function LABEL:SetFont(fnt)
	self.Font = fnt or "Default";
end

function LABEL:Paint()
	surface.SetFont(self.Font);
	surface.SetColor(self.Color.r, self.Color.g, self.Color.b, self.Color.a)
	surface.DrawText(self.Text, self.Pos.x, self.Pos.y, self.MaxWidth, self.Aligns)
end

panel.Register(LABEL, "TextLabel")
	
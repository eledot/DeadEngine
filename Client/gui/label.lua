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
	self.TextColor = Color(22,22,22,255);
	self.Aligns = "left";
	self.Image = eng.Textures["textures/ui/folder.png"];
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
	self.TextColor = col or Color(255,255,255,255);
end

function LABEL:SetFont(fnt)
	self.Font = fnt or "Default";
end

function LABEL:Paint()
	surface.SetFont(self.Font);
	surface.SetColor(self.TextColor.r, self.TextColor.g, self.TextColor.b, self.TextColor.a)
	surface.DrawText(self.Text, self.Pos.x, self.Pos.y, self.MaxWidth, self.Aligns)
end

panel.Register(LABEL, "TextLabel")

local LINK = {}

function LINK:Init()
	self.TextColor = Color(22,22,22,255);
	self.Text = "";
	self.Image = eng.Textures["textures/ui/folder.png"];
	self.Aligns = "left";
	self.MaxWidth = 999;
end

function LINK:SetImage(img)
	self.Image = eng.Textures["textures/ui/"..img..".png"] or eng.Textures["textures/ui/folder.png"];
end

function LINK:OnMouseEnter()
	local col, bcol = self.Color, self.BorderColor;
	self.Color = bcol;
	self.BorderColor = col;
end

function LINK:OnMouseExit()
	self:OnMouseEnter();
end

function LINK:SetText(txt)
	self.Text = tostring(txt) or "";
end

function LINK:Paint()
	surface.SetColor(self.BorderColor);
	surface.DrawOutlinedRect(self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
	surface.SetColor(self.Color);
	surface.DrawRect(self.Pos.x+1, self.Pos.y+1, self.Size.w - 2, self.Size.h - 2);
	surface.SetColor(255,255,255,255)
	surface.DrawImage(self.Image, self.Pos.x + 3, self.Pos.y+(self.Size.h/2 - 8));
	surface.SetColor(self.TextColor);
	surface.DrawText(self.Text, self.Pos.x + 22, self.Pos.y+(self.Size.h/2 - 5), 30, self.Aligns); 
end

panel.Register(LINK, "Link");
	
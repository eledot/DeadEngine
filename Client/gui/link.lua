-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

local LINK = {}

function LINK:Init()
	self.Text = "";
	self.TextColor = Color(255,255,255,255);
	self.Color = Color(33, 33, 33, 255);
	self.LineColor = Color(100, 100, 100, 255);
	self.Aligns = "left";
end

function LINK:OnMouseEnter()
	local LineColor, bColor = self.Color, self.LineColor;
	self.Color = bColor;
	self.LineColor = LineColor;
end

function LINK:OnMouseExit()
	self:OnMouseEnter()
end

function LINK:OnMousePressed()
	self:OnMouseEnter();
	self:OnClick();
end

function LINK:OnClick()
end

function LINK:Align(t)
	self.Aligns = tostring(t) or "left";
end

function LINK:SetText(t)
	self.Text = tostring(t) or self.Text;
end

function LINK:SetTextColor(col)
	self.TextColor = col or Color(255,255,255,255);
end

function LINK:SetFont(fnt)
	self.Font = fnt or false;
end

function LINK:Paint()
	if( self.Font ) then
		surface.SetFont(self.Font);
	end
	surface.SetColor(self.LineColor.r, self.LineColor.g, self.LineColor.b, self.LineColor.a)
	surface.DrawRect(self.Pos.x, self.Pos.y, self.Size.w, 1);
	surface.DrawRect(self.Pos.x, self.Pos.y+self.Size.h-1, self.Size.w, 1);
	surface.SetColor(self.Color.r, self.Color.g, self.Color.b, self.Color.a);
	surface.DrawRect(self.Pos.x, self.Pos.y+1, self.Size.w, self.Size.h-2);
	surface.SetColor(self.TextColor.r, self.TextColor.g, self.TextColor.b, self.TextColor.a);
	surface.DrawText(self.Text, self.Pos.x+2, self.Pos.y+4, self.Size.w-4, self.Aligns);
end

panel.Register(LINK, "Link")
	
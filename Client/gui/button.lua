-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

local BUTTON = {}

function BUTTON:Init()
	self.Text = "";
	self.Color = Color(150, 150, 150, 220);
	self.BorderColor = Color(190, 190, 190, 190);
	self.TextColor = Color(46, 46, 46, 255);
	self.Func = function(self) end;
	self.Aligned = "center";
end

function BUTTON:OnMouseEnter()
	self.Color = Color(190, 190, 190, 190);
	self.BorderColor = Color(150, 150, 150, 22);
end

function BUTTON:OnMouseExit()
	self.Color = Color(150, 150, 150, 220);
	self.BorderColor = Color(190, 190, 190, 190);
end

function BUTTON:OnMousePressed()
end

function BUTTON:OnMouseReleased()
	self:Func();
end

function BUTTON:SetText(t)
	self.Text = tostring(t) or "";
end

function BUTTON:SetFunction(f)
	self.Func = f or self.Func;
end

function BUTTON:Align(t)
	self.Aligned = tostring(t) or "left";
end

function BUTTON:SetTextColor(col)
	self.TextColor = col or self.TextColor;
end

function BUTTON:Paint()
	surface.SetFont(eng.Fonts.Default);
	surface.SetColor(self.BorderColor.r, self.BorderColor.g, self.BorderColor.b, self.BorderColor.a);
	surface.DrawOutlinedRect(self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
	surface.SetColor(self.Color)
	surface.DrawRect(self.Pos.x+1, self.Pos.y+1, self.Size.w-2, self.Size.h-2);
	surface.SetColor(self.TextColor);
	surface.DrawText(self.Text, self.Pos.x, self.Pos.y+2, self.Size.w, self.Aligned);
end

panel.Register(BUTTON, "Button");

BUTTON = {}

function BUTTON:SetImage(i)
	self.Image = i;
end

function BUTTON:OnMouseEnter()
	self.Hovering = true;
end

function BUTTON:OnMouseExit()
	self.Hovering = false;
end

function BUTTON:SetToolTip(t)
	self.ToolTip  = t
	self.tW, self.tH = surface.GetFont():getWidth(t), surface.GetFont():getHeight();
end

function BUTTON:Paint()
	if not self.Image then return end
	surface.SetColor(self.BorderColor)
	surface.DrawOutlinedRect(self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
	surface.SetColor(self.Color)
	surface.DrawRect(self.Pos.x+1, self.Pos.y+1, self.Size.w-2, self.Size.h-2);
	surface.SetColor(255, 255, 255, 255);
	surface.DrawImage(self.Image, self.Pos.x + (self.Size.w/2) - (self.Image:getWidth()/2), self.Pos.y + (self.Size.h/2) - (self.Image:getHeight()/2));
	if( self.Hovering and self.ToolTip ) then
		surface.SetColor(self.BorderColor);
		surface.DrawOutlinedRect( self.Pos.x + 20, self.Pos.y + 20, self.tW+8, self.tH+4);
		surface.SetColor(self.Color);
		surface.DrawRect(self.Pos.x + 21, self.Pos.y + 21, self.tW+6, self.tH+2);
		surface.SetColor(self.TextColor);
		surface.DrawText(self.ToolTip, self.Pos.x + 23, self.Pos.y + 23, self.tW, "center");
	end
		
end

panel.Register(BUTTON, "ImageButton", "Button");

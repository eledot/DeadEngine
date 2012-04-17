-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

local BUTTON = {}

function BUTTON:Init()
	self.Text = "";
	self.TopColor = Color(66, 66, 66, 255);
	self.Color = Color(77, 77, 77, 255);
	self.BorderColor = Color(170, 170, 170, 255);
	self.Func = function(self) end;
	self.Aligned = "center";
end

function BUTTON:OnMousePressed()
	local TopColor, BottomColor = self.Color, self.TopColor;
	self.TopColor = TopColor;
	self.Color = BottomColor;
end

function BUTTON:OnMouseReleased()
	self:OnMousePressed()
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

function BUTTON:Paint()
	love.graphics.setColor(self.Color.r, self.Color.g, self.Color.b, self.Color.a);
	love.graphics.rectangle("fill", self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
	love.graphics.setColor(self.TopColor.r, self.TopColor.g, self.TopColor.b, self.TopColor.a);
	love.graphics.rectangle("fill", self.Pos.x, self.Pos.y, self.Size.w, self.Size.h-6);
	surface.SetColor(self.BorderColor.r, self.BorderColor.g, self.BorderColor.b, self.BorderColor.a);
	surface.DrawOutlinedRect(self.Pos.x, self.Pos.y, self.Size.w+1, self.Size.h+1);
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
end

function BUTTON:Paint()
	if not self.Image then return end
 	love.graphics.setColor(self.Color.r, self.Color.g, self.Color.b, self.Color.a);
	love.graphics.rectangle("fill", self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
	love.graphics.setColor(self.TopColor.r, self.TopColor.g, self.TopColor.b, self.TopColor.a);
	love.graphics.rectangle("fill", self.Pos.x, self.Pos.y, self.Size.w, self.Size.h-6);
	surface.SetColor(self.BorderColor.r, self.BorderColor.g, self.BorderColor.b, self.BorderColor.a);
	surface.DrawOutlinedRect(self.Pos.x, self.Pos.y, self.Size.w+1, self.Size.h+1);
	surface.SetColor(255, 255, 255, 255);
	love.graphics.draw(self.Image, self.Pos.x + (self.Size.w/2) - (self.Image:getWidth()/2), self.Pos.y + (self.Size.h/2) - (self.Image:getHeight()/2));
	if( self.Hovering and self.ToolTip ) then
		local Width, Height = love.graphics.getFont():getWidth(self.ToolTip), love.graphics.getFont():getHeight(self.ToolTip);
		surface.SetColor(self.BorderColor.r, self.BorderColor.g, self.BorderColor.b, self.BorderColor.a);
		surface.DrawOutlinedRect( self.Pos.x + 20, self.Pos.y + 20, Width+8, Height+4);
		surface.SetColor(self.Color.r, self.Color.g, self.Color.b, self.Color.a);
		surface.DrawRect(self.Pos.x + 21, self.Pos.y + 21, Width+6, Height+2);
		surface.SetColor(230, 230, 230, 255);
		surface.DrawText(self.ToolTip, self.Pos.x + 23, self.Pos.y + 23, Width+2, "center");
	end
		
end

panel.Register(BUTTON, "ImageButton", "Button");

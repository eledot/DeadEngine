-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

local CLOSE = {}

function CLOSE:Init()
	self.Color = Color(225, 225, 225, 255);
	self.ShowX = true;
	self.XPos = eng.Fonts["fonts/coolvetica.ttf"]:getWidth("x");
	self.YPos = eng.Fonts["fonts/coolvetica.ttf"]:getHeight("x");
end

function CLOSE:SetTarget(pnl)
	self.Target = pnl;
end

function CLOSE:OnMousePressed()
	self.Target:SetLive(false);
end

function CLOSE:OnMouseEnter()
	self.Color = Color(255, 255, 255, 255);
	self.BorderColor = Color(255, 100, 100, 255);

end

function CLOSE:OnMouseExit()
	self.Color = Color(225, 225, 225, 255);
	self.BorderColor = Color(22, 22, 22, 180);
end

function CLOSE:SetShowX(b)
	self.ShowX = b or false;
end

function CLOSE:Paint()
	surface.SetColor(self.BorderColor);
	surface.DrawOutlinedRect(self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
	surface.SetColor(self.Color);
	gui.ScissorStart(self.Pos.x + 1, self.Pos.y, self.Size.w - 3, self.Size.h-1);
		surface.DrawImage(eng.Textures["textures/gui/gradient-red.png"], self.Pos.x+1, self.Pos.y);
	gui.ScissorEnd();
	if( self.ShowX ) then
		surface.SetColor(Color(220, 220, 220, 255));
		surface.SetFont("fonts/coolvetica.ttf");
		surface.DrawText("x", (self.Pos.x) + (((self.Size.w -3 )/2) - self.XPos/2), (self.Pos.y) + ((( self.Size.h - 3)/2) - self.YPos/2), 300, "left");
	end
end

panel.Register(CLOSE, "CloseButton")

local TITLE = {}

function TITLE:Init()
	self.Title = "";
	self.Font = "Default";
	self.Color = Color( 255, 255, 255, 255);
	self.Draggable = true;
	self.Dragging = false;
end

function TITLE:SetTitle(ttl)
	self.Title = tostring(ttl) or "";
	self.Height = self:GetHeight();
end

function TITLE:EnableDragging(b)
	self.Draggable = b or false;
end

function TITLE:SetFont(fnt)
	self.Font = fnt or "Default";
	self.Height = self:GetHeight();
end

function TITLE:GetHeight()
	return eng.Fonts[self.Font]:getHeight();
end

function TITLE:OnMousePressed()
	if( self.Draggable ) then
		self.Dragging = true;
		local pX, pY = self:GetParent():GetPos();
		local mX, mY = gui.MousePos();
		self.DirX = mX - pX;
		self.DirY = mY - pY;
	end
end

function TITLE:OnMouseReleased()
	if( self.Draggable ) then
		self.Dragging = false;
	end
end

function TITLE:Think()
	if( self.Dragging ) then
		local moveX, moveY = gui.MousePos()
		moveX = moveX - self.DirX;
		moveY = moveY - self.DirY;
		self:GetParent():SetPos(moveX, moveY)
	end
end	

function TITLE:Paint()
	surface.SetColor(self.BorderColor);
	surface.DrawOutlinedRect(self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
	surface.SetColor(self.Color)
	gui.ScissorStart(self.Pos.x+1, self.Pos.y+1, self.Size.w-2, self.Size.h-2);
		surface.DrawImage(eng.Textures["textures/gui/gradient-bar.png"], self.Pos.x+1, self.Pos.y+1);
	gui.ScissorEnd()
	surface.SetColor(Color(190, 190, 190, 255));
	surface.SetFont(self.Font)
	surface.DrawText(self.Title, self.Pos.x + 5, self.Pos.y + (self.Size.h/2) -self.Height/2, 300, "left");
end

panel.Register(TITLE, "TitleBar");

local FRAME = {}

function FRAME:Init()
	self.Gradient = nil
	self.EnableBorder = true;
end

function FRAME:SetGradient()
	self.Gradient = eng.Textures[grad] or eng.Textures["textures/ui/gradient.png"];
end

function FRAME:SetEnableBorder(b)
	self.EnableBorder = b or false;
end

function FRAME:SetBorderColor(col)
	self.BorderColor = col or self.BorderColor;
end

function FRAME:OnMouseEnter()
end

function FRAME:OnMouseExit()
end

function FRAME:Paint()
	if( self.EnableBorder ) then
		surface.SetColor(self.BorderColor)
		surface.DrawOutlinedRect(self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
	end
	surface.SetColor(Color(255,255,255,255))
	if( self.Gradient ) then
		gui.ScissorStart(self.Pos.x+1, self.Pos.y+1, self.Size.w-2, self.Size.h-2);
			surface.DrawImage(self.Gradient, self.Pos.x+1, self.Pos.y+2);
		gui.ScissorEnd();
	else
		surface.SetColor(self.Color)
		surface.DrawRect(self.Pos.x+1, self.Pos.y+1, self.Size.w-2, self.Size.h-2);
	end
end

panel.Register(FRAME, "Frame");

function panel.CreateTitleFrame(title, close, x, y, w, h, font)
	local TitleFrame = panel.Create("Frame")
	TitleFrame:SetPos(x, y)
	TitleFrame:SetSize(w, h)
	if( title ) then
		TitleFrame.TitleBar = panel.Create("TitleBar", TitleFrame)
		TitleFrame.TitleBar:SetTitle(tostring(title));
		TitleFrame.TitleBar:SetSize(w, 28);
		TitleFrame.TitleBar:SetPos( 0, 0 );
		if( close ) then
			TitleFrame.TitleBar.CloseButton = panel.Create("CloseButton", TitleFrame.TitleBar);
			TitleFrame.TitleBar.CloseButton:SetTarget(TitleFrame);
			TitleFrame.TitleBar.CloseButton:SetSize(28,16);
			TitleFrame.TitleBar.CloseButton:SetPos(w - 30, 1 );
		end
	end
	TitleFrame:SetLive(true);
	return TitleFrame;
end
	

		
	
-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

local CLOSE = {}

function CLOSE:Init()
	self.TopColor = Color(66, 66, 66, 255);
	self.Color = Color(77, 77, 77, 255);
	self.ShowX = true;
end

function CLOSE:SetTarget(pnl)
	self.Target = pnl;
end

function CLOSE:OnMousePressed()
	self.Target:SetLive(false);
end

function CLOSE:OnMouseEnter()
	local TopColor, BottomColor = self.Color, self.TopColor;
	self.Color = BottomColor;
	self.TopColor = TopColor;
end

function CLOSE:OnMouseExit()
	local TopColor, BottomColor = self.Color, self.TopColor;
	self.Color = BottomColor;
	self.TopColor = TopColor;
end

function CLOSE:SetShowX(b)
	self.ShowX = b or false;
end

function CLOSE:SetTopColor(col)
	self.TopColor = col or self.TopColor;
end

function CLOSE:Paint()
	love.graphics.setColor(self.Color.r, self.Color.g, self.Color.b, self.Color.a);
	love.graphics.rectangle("fill", self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
	love.graphics.setColor(self.TopColor.r, self.TopColor.g, self.TopColor.b, self.TopColor.a);
	love.graphics.rectangle("fill", self.Pos.x, self.Pos.y, self.Size.w, self.Size.h-6);
	surface.SetColor(170, 170, 170, 255);
	surface.DrawOutlinedRect(self.Pos.x, self.Pos.y, self.Size.w+1, self.Size.h+1);
	if( self.ShowX ) then
		surface.DrawText("x", self.Pos.x + (self.Size.w/2) -3, self.Pos.y + ((self.Size.h/2) - 8), 300, "left");
	end
end

panel.Register(CLOSE, "CloseButton")

local TITLE = {}

function TITLE:Init()
	self.Title = "";
	self.Font = "";
	self.TopColor = Color(110, 110, 110, 255);
	self.Color = Color( 120, 120, 120, 255);
	self.Draggable = true;
	self.Dragging = false;
end

function TITLE:SetTopColor(col)
	self.TopColor = col or Color(110, 110, 110, 255);
end

function TITLE:SetTitle(ttl)
	self.Title = tostring(ttl) or "";
end

function TITLE:EnableDragging(b)
	self.Draggable = b or false;
end

function TITLE:SetFont(fnt)
	self.Font = tostring(fnt) or "";
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
	love.graphics.setColor(self.Color.r, self.Color.g, self.Color.b, self.Color.a);
	love.graphics.rectangle("fill", self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
	love.graphics.setColor(self.TopColor.r, self.TopColor.g, self.TopColor.b, self.TopColor.a);
	love.graphics.rectangle("fill", self.Pos.x, self.Pos.y, self.Size.w, self.Size.h-6);
	surface.SetColor(170, 170, 170, 255);
	surface.DrawRect(self.Pos.x, self.Pos.y + 22, self.Size.w, 1);
	surface.DrawText(self.Title, self.Pos.x + 2, self.Pos.y + (self.Size.h/2) -8, 300, "left");
end

panel.Register(TITLE, "TitleBar");

local FRAME = {}

function FRAME:Init()
	self.BorderColor = Color(190, 190, 190, 255);
	self.Color = Color(140, 140, 140, 255);
	self.EnableBorder = true;
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
		love.graphics.setColor(self.BorderColor.r, self.BorderColor.g, self.BorderColor.b, self.BorderColor.a);
		love.graphics.rectangle("line", self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
		love.graphics.setColor(self.Color.r, self.Color.g, self.Color.b, self.Color.a);
		love.graphics.rectangle("fill", self.Pos.x+1, self.Pos.y+1, self.Size.w-3, self.Size.h-3);
	else
		love.graphics.setColor(self.Color.r, self.Color.g, self.Color.b, self.Color.a);
		love.graphics.rectangle("fill", self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
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
		TitleFrame.TitleBar:SetSize(w - 6, 22);
		TitleFrame.TitleBar:SetPos( 2, 2 );
		if( close ) then
			TitleFrame.TitleBar.CloseButton = panel.Create("CloseButton", TitleFrame.TitleBar);
			TitleFrame.TitleBar.CloseButton:SetTarget(TitleFrame);
			TitleFrame.TitleBar.CloseButton:SetSize(16, 16);
			TitleFrame.TitleBar.CloseButton:SetPos(w - 24, 2 );
		end
	end
	return TitleFrame;
end
	

		
	
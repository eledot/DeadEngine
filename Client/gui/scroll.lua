-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

local PANEL = {}

function PANEL:Init()
	self.Items = {}
	self.Color = Color(195, 195, 195, 220);
	self.BorderColor = Color(170, 170, 170, 255);
	self.Padding = 2;
	self.Horizontal = false;
	self.NextPos = 2;
	self.ScrollPos = 18;
	self.ScrollDist = 10;
end

function PANEL:SetMaxItems(n)
	self.MaxItems = tonumber(n);
end

function PANEL:EnableHorizontal(b)
	self.Horizontal = b or false;
end

function PANEL:GetItemCount()
	return #self.Items;
end

function PANEL:GetMaxItems()
	return self.MaxItems;
end

function PANEL:CalculateItemPosY()
	if( self.Items[1] ) then
		local Item = self.Items[#self.Items];
		local MaxY = Item.OldPosY;
		local MaxH = Item.Size.h;
		return MaxY + MaxH + self.Padding;
	end
	return self.Padding;
end

function PANEL:TrackDistance()
	return (self.btnFrame.Size.h - 65);
end

function PANEL:DistancePerPixel()
	local Viewable = self.Size.h - 2;
	local Hidden = self.NextPos - Viewable;
	local TrackDistance = self:TrackDistance()
	return Hidden / TrackDistance;
end

function PANEL:ScrollPercentage()
	local Moved = self.btnGrip.ActualPos.y - self.ScrollPos;
	return Moved;
end

function PANEL:ScrollBarMove()
	return self:TrackDistance() / self.ScrollDist;
end

function PANEL:Scroll()
	local Moved = self:ScrollPercentage();
	for k,v in pairs(self.Items) do
		v:SetPos(self.ActualPos.x, v.OldPosY - (self:DistancePerPixel()*Moved));
	end
end

function PANEL:ScrollToBottom()
	if( self.btnGrip ) then
		self.btnGrip:SetPos(1, self.ScrollPos + self:TrackDistance());
		self:Scroll();
	end
end

function PANEL:AddItem(item)
	item:SetParent(self);
	item:SetScissor(true);
	self.NextPos = self:CalculateItemPosY();	
	item:SetPos(self.Padding, self.NextPos);
	item.OldPosY = self.NextPos;
	self.NextPos = self.NextPos + item.Size.h + self.Padding;
	
	table.insert(self.Items, item);
	
	if( self.NextPos > self.Size.h-2 ) then
		if( self.ScrollEnabled and not self.btnFrame ) then
			self:MakeParts();
		end
	end
end

function PANEL:EnableVerticalScrollbar()
	self.ScrollEnabled = true;
end

function PANEL:MakeParts()

	self.btnFrame = panel.Create("Frame", self)
	self.btnFrame:SetColor(Color(170, 170, 170, 220));
	self.btnFrame.BorderColor = Color(0, 0, 0, 0);
	self.btnFrame:SetSize(18, self.Size.h - 2);
	self.btnFrame:SetPos(self.Size.w - 19, 1);
	
	self.btnUp = panel.Create("ImageButton", self.btnFrame)
	self.btnUp:SetPos(1, 0);
	self.btnUp:SetSize(16, 16);
	self.btnUp:SetImage(eng.Textures["textures/ui/arrow_up.png"])
	self.btnUp.Func = function(btn)
		self.btnGrip:SetPos(1, math.Clamp(self.btnGrip.ActualPos.y - self:ScrollBarMove(), self.ScrollPos, self.ScrollPos + self:TrackDistance())) ;
		self:Scroll()
	end
	
	self.btnDown = panel.Create("ImageButton", self.btnFrame)
	self.btnDown:SetPos(1, self.btnFrame.Size.h - 16);
	self.btnDown:SetSize(16, 16);
	self.btnDown:SetImage(eng.Textures["textures/ui/arrow_down.png"])
	self.btnDown.Func = function(btn)
		self.btnGrip:SetPos(1, math.Clamp(self.btnGrip.ActualPos.y + self:ScrollBarMove(), self.ScrollPos, self.ScrollPos + self:TrackDistance()));
		self:Scroll()
	end
	
	self.btnGrip = panel.Create("Button", self.btnFrame)
	self.btnGrip:SetPos(1, 18);
	self.btnGrip:SetSize(16, 30);
	function self.btnGrip.OnMousePressed(btn)
		btn.Dragging = true;
		local pY = btn.ActualPos.y;
		local mX, mY = gui.MousePos();
		btn.DirY = mY - pY;
	end
	function self.btnGrip.OnMouseReleased(btn)
		btn.Dragging = false;
	end
	function self.btnGrip.Think(btn)	
		if( btn.Dragging ) then
			local moveX, moveY = gui.MousePos();
			moveY = moveY - btn.DirY;
			btn:SetPos(1, math.Clamp(moveY, self.ScrollPos, self.ScrollPos+self:TrackDistance()));
			self:Scroll();
		end
	end
		
	self.btnFrame:SetLive(true)
	
end

function PANEL:Think()
	for k,v in pairs(self.Items) do
		if( v.ActualPos.x > self.Size.h+5 ) then
			v:SetLive(false);
		end
	end
end

function PANEL:PaintChildren(pnl)
	pnl:Paint();
	for k,v in pairs(pnl.Children) do
		if( v.Children ) then
			self:PaintChildren(v);
		end
		v:Paint();
	end
end

function PANEL:Paint()
	
	surface.SetColor(self.BorderColor.r, self.BorderColor.g, self.BorderColor.b, self.BorderColor.a)
	surface.DrawOutlinedRect(self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
	
	gui.ScissorStart(self.Pos.x+1, self.Pos.y+1, self.Size.w-2, self.Size.h-2);
		
		surface.SetColor(self.Color.r, self.Color.g, self.Color.b, self.Color.a);
		surface.DrawRect(self.Pos.x+1, self.Pos.y+1, self.Size.w-2, self.Size.h-2);
		
		for k,v in pairs(self.Items) do
			self:PaintChildren(v);
		end
		
	gui.ScissorEnd();
end

panel.Register(PANEL, "ScrollFrame");
	
	

	
	
-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

_R.Panel = {}
_R.Panel.__index = _R.Panel;

function Panel()
	local panel = {
		Alive = false,
		Size = { w = 0, h = 0 },
		Pos = { x = 0, y = 0 },
		ActualPos = { x = 0, y = 0 },
		Color = Color(235, 235, 235, 210),
		BorderColor = Color(22, 22, 22, 180),
		TextColor = Color(22, 22, 22, 255),
		Children = {},
		Parent = false,
		ActualPos = {x = 0, y = 0},
		Scissor = false
	}
	setmetatable(panel, _R.Panel)
	return panel;
end
function _R.Panel:SetSize(w, h)
	self.Size.w = tonumber(w) or 0;
	self.Size.h = tonumber(h) or 0;
end

function _R.Panel:GetSize()
	return self.Size.w, self.Size.h;
end

function _R.Panel:GetParent()
	return self.Parent or false;
end

function _R.Panel:SetParent(pr)
	self.Parent = pr;
	table.insert(pr.Children, self)
	for k,v in pairs(g_CurPanels) do
		if( v == self ) then
			table.remove(g_CurPanels, k);
		end
	end
end

function _R.Panel:SetPos(x, y)
	self.Pos.x, self.Pos.y = x, y;
	self.ActualPos.x, self.ActualPos.y = x, y;
	if( self:GetParent() ) then
		self.Pos.x = self:GetParent().Pos.x + x;
		self.Pos.y = self:GetParent().Pos.y + y;
	end
	for k,v in pairs(self.Children) do
		v:SetPos(v.ActualPos.x, v.ActualPos.y);
	end
end

function _R.Panel:GetPos()
	return self.Pos.x, self.Pos.y;
end

function _R.Panel:SetLive(b)
	self.Alive = b or false;
	for k,v in pairs( self.Children ) do
		v:SetLive(b)
	end
end

function _R.Panel:_GetActualPos()
	return self.ActualPos.x, self.ActualPos.y;
end

function _R.Panel:Live()
	return self.Alive;
end

function _R.Panel:SetColor(col)
	self.Color = col or Color(245, 245, 245, 190);
end

function _R.Panel:SetBorderColor(col)
	self.Color = col or Color(22, 22, 22, 180);
end

function _R.Panel:SetTextColor(col)
	self.TextColor = col or Color(22, 22, 22, 255);
end

function _R.Panel:GetColor()
	return self.Color;
end

function _R.Panel:SetScissor(b)
	self.Scissor = b or false;
end

function _R.Panel:GetScissor()
	return self.Scissor;
end

function _R.Panel:Paint()
end

function _R.Panel:Think()
end

function _R.Panel:OnMouseEnter()
end

function _R.Panel:OnMouseExit()
end

function _R.Panel:OnMousePressed()
end

function _R.Panel:OnMouseReleased()
end

function _R.Panel:OnMouseRightPressed()
end

function _R.Panel:OnMouseRightReleased()
end

function _R.Panel:_Think()
	if( self:Live() ) then
		if( gui.IsHovering(self) ) then
			if( not self.Entered ) then
				self.Entered = true;
				self:OnMouseEnter();
			end
			if( gui.MouseDown("l") ) then
				if( not self.Clicked ) then
					eng.TextFocused = nil;
					panel.PaintOver(gui.GetTopParent(self));
					self.Clicked = true;
					self:OnMousePressed();
				end
			end
			if( gui.MouseDown("r") ) then
				if( not self.rClicked ) then
					if( self.Parent == nil ) then
						panel.PaintOver(self);
					end
					eng.TextFocused = nil;
					self.rClicked = true;
					self:OnMouseRightPressed();
				end
			end
		elseif( self.Entered ) then
			self.Entered = false;
			self:OnMouseExit();
		end
		if( self.Children[1] ) then
			for k,v in pairs(self.Children) do
				if( v:Live() ) then
					v:Think();
					v:_Think();
				end
			end
		end
		if( self.Clicked and not gui.MouseDown("l") ) then
			self:OnMouseReleased();
			self.Clicked = false;
		end
		if( self.rClicked and not gui.MouseDown("r") ) then
			self:OnMouseRightReleased();
			self.rClicked = false;
		end
	end
end

function _R.Panel:_Paint()
	if( self.Children[1] and self:Live() ) then
		for k,v in pairs(self.Children) do
			if( v:Live() and not v:GetScissor() ) then
				v:Paint();
				v:_Paint();
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

local IMG = {}

function IMG:Init()
	self.UseGrid = false;
	self.MouseArea = {}
	self.NearPos = { x = 0, y = 0, w = 0, h = 0 };
end

function IMG:ToggleGrid()
	self.UseGrid = not self.UseGrid;
end

function IMG:DrawGrid()
	if( not self.Image ) then
		return 
	end
	surface.DrawIsometricGrid((self.Size.w/64), (self.Size.h/32), self.Pos.x, self.Pos.y, true);
end		

function IMG:Think()
	if(  not self.UseGrid or not worldEditor ) then
		return
	end
	self.MouseArea.x, self.MouseArea.y = gui.MousePos();
	local Nearest = 9999;
	local nPos = { x = 0, y = 0, w = 0, h = 0 }
	for i = 1, self.Size.h/32 do
		for j = 1, self.Size.w/64 do
			local Dist = math.Distance(self.MouseArea.x, self.MouseArea.y, self.Pos.x + (64*(j-1))+32, self.Pos.y + (32*(i-1))+16);
			if( Dist < Nearest ) then
				Nearest = Dist;
				nPos = {  x = (64*(j-1)), y = (32*(i-1)), w = 64, h = 32 }
			end
		end
	end
	self.NearPos = nPos;
end
	
function IMG:OnMousePressed()
	if( not self.UseGrid or not worldEditor ) then
		return
	end
	if( self:GetParent() ) then
		local Parent = self:GetParent();
		local ParentParent = Parent:GetParent();
		if( Parent.btnGrip and Parent.btnGrip.Dragging ) then
			return
		end
		if( ParentParent and ParentParent.Dragging ) then
			return
		end;
	end
	for k,v in pairs(worldEditor.Selected) do
		if( self.NearPos.x == v.x and self.NearPos.y == v.y ) then
			table.remove(worldEditor.Selected, k);
		end
	end
	self.NearPos.Image = Engine.Tilesets[worldEditor.CurrentTileSet];
	self.NearPos.Quad = love.graphics.newQuad(self.NearPos.x, self.NearPos.y, 64, 32, self.NearPos.Image:getWidth(), self.NearPos.Image:getHeight());
	table.insert(worldEditor.Selected, self.NearPos);
	--worldEditor.Selected = self.NearPos
end

function IMG:OnMouseRightPressed()
	if( not self.UseGrid or not worldEditor ) then
		return
	end
	for k,v in pairs(worldEditor.Selected) do
		if( self.NearPos.x == v.x and self.NearPos.y == v.y ) then
			table.remove(worldEditor.Selected, k);
		end
	end
	--worldEditor.Selected = nil;
end
			
function IMG:SetImage(img)
	self.Image = img;
end

local Sel;
function IMG:Paint()
	if( not worldEditor ) then
		return
	end
	if( self.Image ) then
		surface.SetColor(255, 255, 255, 255);
		love.graphics.draw(self.Image, self.Pos.x, self.Pos.y);
		if( self.UseGrid ) then
			self:DrawGrid();
			surface.SetColor(Color(100, 100, 255, 150));
			surface.DrawRect(self.Pos.x + self.NearPos.x, self.Pos.y + self.NearPos.y, self.NearPos.w, self.NearPos.h);
			surface.SetColor(Color(255, 100, 100, 150));
			--Sel = worldEditor.Selected;
			--if( Sel and Sel.x ) then
			--	surface.DrawRect(self.Pos.x + Sel.x, self.Pos.y + Sel.y, Sel.w, Sel.h);
			--end
			for k,v in pairs(worldEditor.Selected) do
				surface.DrawRect(self.Pos.x + v.x, self.Pos.y + v.y, v.w, v.h);
			end
		end
	end
end

panel.Register(IMG, "TileSetPanel");
	
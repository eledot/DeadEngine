-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

local SLIDER = {}

function SLIDER:Init()
	self.Min = 0;
	self.Max = 100;
	self.Cur = 0;
	self.Color = Color(120, 120, 120, 255);
	self.BorderColor = Color(170, 170, 170, 255);
	self.Padding = 2;
	self.TextColor = Color(255,255,255,255);
end

function SLIDER:SetTextColor(col)
	self.TextColor = col;
end

function SLIDER:SetMax(m)
	self.Max = tonumber(m);
end

function SLIDER:SetMin(m)
	self.Min = tonumber(m)
	self.Cur = self.Min;
end

function SLIDER:SetBounds(m, ma)
	self:SetMin(m);
	self:SetMax(ma);
end

function SLIDER:TrackDistance()
	return (self.Size.w - 39);
end

function SLIDER:SlidePercentage()
	local Moved = self.Slider.ActualPos.x - self.Padding + -10;
	return Moved / self:TrackDistance();
end

function SLIDER:Slide()
	self.Cur = math.Clamp(math.ceil(self.Max*self:SlidePercentage()), self.Min, self.Max);
	print(self.Cur)
end

function SLIDER:MakeParts()

	self.Frame = panel.Create("Frame", self);
	self.Frame:SetSize(self.Size.w-20, 6);
	self.Frame:SetPos(10, 7);
	
	self.Slider = panel.Create("Button", self)
	self.Slider:SetSize(15, 20);
	self.Slider:SetPos(self.Padding+10, 0)
	function self.Slider.OnMousePressed(btn)
		btn.Dragging = true;
		local pX = btn.ActualPos.x;
		local mX, mY = gui.MousePos();
		btn.DirX = mX - pX;
	end
	function self.Slider.OnMouseReleased(btn)
		btn.Dragging = false;
	end
	function self.Slider.Think(btn)	
		if( btn.Dragging ) then
			local moveX, moveY = gui.MousePos();
			moveX = moveX - btn.DirX;
			btn:SetPos( math.Clamp(moveX, self.Padding+10, self.Padding+self:TrackDistance()+10), 0);
			self:Slide();
		end
	end
	self.Frame:SetLive(true);
	
end

function SLIDER:Paint()
	surface.SetColor(self.TextColor);
	surface.DrawText(self.Min, self.Pos.x-10, self.Pos.y + 3, 60, "left");
	surface.DrawText(self.Max, self.Pos.x+self.Size.w-9, self.Pos.y + 3, 60, "left");
end
	

panel.Register(SLIDER, "Slider");
	
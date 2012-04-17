-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

local TEXT = {}

function TEXT:Init()
	self.Carrat = "|";
	self.LastCarrat = 0;
	self.Color = Color(200, 200, 200, 255);
	self.BorderColor = Color(33, 33, 33, 255);
	self.Max = 250;
	self.Count = 0;
	self.OnCount = false;
	self.Text = "";
	self.EntryBox = 1;
end

function TEXT:SetMax(n)
	self.Max = math.Clamp(n, 1, 250);
end

function TEXT:Clear()
	self.Text = "";
	self.Count = 0;
end

function TEXT:GetLength()
	return love.graphics.getFont():getWidth(self.Text);
end

function TEXT:SetValue(t)
	self.Text = tostring(t)
	self.Count = string.len(self.Text);
end

function TEXT:GetApproxChars()
	local width = love.graphics.getFont():getWidth("M");
	return math.ceil((self.Size.w -2)/width);
end

function TEXT:OnTextChanged()
end

function TEXT:OnReturn()
end

function TEXT:Paint()
	if( self.LastCarrat <= CurTime() ) then
		self.OnCount = not self.OnCount;
		self.LastCarrat = CurTime() + 1;
	end
	surface.SetColor(self.BorderColor.r, self.BorderColor.g, self.BorderColor.b, self.BorderColor.a);
	surface.DrawOutlinedRect(self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
	
	gui.ScissorStart(self.Pos.x+1, self.Pos.y+1, self.Size.w-2, self.Size.h-2);
		surface.SetColor(self.Color.r, self.Color.g, self.Color.b, self.Color.a);
		surface.DrawRect(self.Pos.x+1, self.Pos.y+1, self.Size.w - 2, self.Size.h - 2);
		surface.SetColor(0, 0, 0, 255);
		if( Engine.TextFocused and Engine.TextFocused == self ) then
			if( self.OnCount ) then
				surface.DrawText(string.sub(self.Text, math.Clamp(string.len(self.Text)-self:GetApproxChars(), 0, 250) ,string.len(self.Text)), self.Pos.x+2, self.Pos.y+2, self.Max*16, "left");
			else
				surface.DrawText(string.sub(self.Text, math.Clamp(string.len(self.Text)-self:GetApproxChars(), 0, 250) ,string.len(self.Text)).."|", self.Pos.x+2, self.Pos.y+2, self.Max*16, "left");
			end
		else
			surface.DrawText(string.sub(self.Text, math.Clamp(string.len(self.Text)-self:GetApproxChars(), 0, 250) ,string.len(self.Text)), self.Pos.x+2, self.Pos.y+2, self.Max*16, "left");
		end
	gui.ScissorEnd();
	
end

panel.Register(TEXT, "TextEntry");


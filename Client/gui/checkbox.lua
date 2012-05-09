-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

local CHECK = {}

function CHECK:Init()
	self.Checked = false;
	self.CheckImage = eng.Textures["textures/ui/check.png"];
	self.CheckRotation = 0;
	self.Scale = 0.25;
end

function CHECK:SetRotation(r)
	self.CheckRotation = math.Clamp(r, 0, 360)
end

function CHECK:SetScale(n)
	self.Scale = math.Clamp(n, 0, 1);
end

function CHECK:OnMouseReleased()
	self.Checked = not self.Checked;
end

function CHECK:GetChecked()
	return self.Checked;
end

function CHECK:SetChecked()
	self.Checked = true;
end

function CHECK:SetUnChecked()
	self.Checked = false;
end

function CHECK:SetCheckImage(img)
	self.CheckImage = eng.Textures["textures/ui/"..tostring(img)..".png"] or eng.Textures["textures/ui/check.png"];
end

function CHECK:Paint()
	surface.SetColor(self.BorderColor)
	surface.DrawOutlinedRect(self.Pos.x, self.Pos.y, self.Size.w, self.Size.h);
	surface.SetColor(self.Color)
	surface.DrawRect(self.Pos.x+1, self.Pos.y+1, self.Size.w-2, self.Size.h-2);
	if( self.Checked ) then
		surface.SetColor(self.TextColor or Color(22, 22, 22, 255));
		surface.DrawImage(self.CheckImage, (self.Pos.x+1)+(( self.Size.w/2)-8), (self.Pos.y+1)+((self.Size.h/2)-8), self.CheckRotation, self.Scale, self.Scale);
	end
end

panel.Register(CHECK, "CheckBox")
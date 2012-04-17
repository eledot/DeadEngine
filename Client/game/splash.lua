-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

local SplashScreen = State();

function SplashScreen:Init()
	self.Image = Engine.Textures["textures/dropdeadstudios.png"];
	self.Alpha = 0;
	self.AlphaTime = 100;
	self.StartTime = 40;
end


function SplashScreen:Think()
	if( self.StartTime <= 0 ) then
		self.Alpha = math.Clamp(self.Alpha + 1, 0, 255);
		if( self.Alpha == 255 ) then
			self.AlphaTime = self.AlphaTime - 1;
			if( self.AlphaTime <= 0 ) then
				StateManager:Pop();
			end
		end
	end
	self.StartTime = math.Clamp(self.StartTime-1, 0, 40);
end

function SplashScreen:ScreenDraw()
	surface.SetColor(Color(0, 0, 0, 255));
	surface.DrawRect(ScrW(), ScrH(), 0, 0);
	surface.SetColor(Color(255, 255, 255, self.Alpha));
	love.graphics.draw(self.Image, (ScrW()/2) - (self.Image:getWidth()/2), (ScrH()/2) - (self.Image:getHeight()/2));
end

function SplashScreen:Shutdown()
	self.Image = nil;
end

return SplashScreen;



-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------


local GameState = State();
GameState.Interfaces = {}
GameState.TextColor = Color(100, 255, 100, 255);

function GameState:CreateButtons()
	local Label = panel.Create("TextLabel");
	Label:SetPos(1, 1)
	Label:SetWide(ScrW())
	Label:SetText("Game Here");
	Label:Align("center");
	Label:SetLive(true);
	table.insert(self.Interfaces, Label);
end

function GameState:Init()
	Engine.ConsoleLabel("[[----GameState Initialized----]]", self.TextColor, "left");
	self:CreateButtons();
end

function GameState:KeyPressed(k, u)
end

function GameState:Shutdown()
	Engine.ConsoleLabel("[[----GameState Shutting Down----]]", self.TextColor, "left");
	for k,v in pairs(self.Interfaces) do
		v:SetLive(false)
		for i = 1, #g_CurPanels do
			if( g_CurPanels[i] == v ) then
				table.remove(g_CurPanels, i);
			end
		end
		v = nil;
	end
end

return GameState;
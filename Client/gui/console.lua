-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

function Engine.ConsoleLabel(text, color, align)
	local newLabel = panel.Create("TextLabel")
	newLabel:SetText(tostring(text));
	if( color ) then
		newLabel:SetColor(color);
	end
	if( string.len(text) > 80 ) then
		newLabel:SetSize(0, 24);
	elseif( string.len(text) > 163 ) then
		newLabel:SetSize(0, 36);
	else
		newLabel:SetSize(0, 12);
	end
	newLabel:SetWide(486);
	newLabel:SetLive(true);
	if( align ) then
		newLabel:Align(align);
	end
	Engine.Console.Frame:AddItem(newLabel);
	Engine.Console.Frame:ScrollToBottom();
end

function Engine.CreateConsole()
	if( Engine.Console ) then
		Engine.Console:SetLive(not Engine.Console:Live());
		if( Engine.Console:Live() ) then
			Engine.TextFocused = Engine.Console.TextEntry;
		else
			Engine.TextFocused = nil;
		end
		return
	end
	Engine.Console = panel.CreateTitleFrame("Console: "..Engine.GameTitle, true, ScrW()/2 - 250, ScrH()/2 - 250, 500, 500)
	Engine.Console:SetLive(false);
	Engine.Console.Frame = panel.Create("ScrollFrame", Engine.Console);
	Engine.Console.Frame:SetSize(490, 440);
	Engine.Console.Frame:SetPos(5, 30);
	Engine.Console.Frame:SetColor(Color(44,44,44,255));
	Engine.Console.Frame:EnableVerticalScrollbar();
	Engine.Console.Frame:SetLive(false);
	
	Engine.Console.TextEntry = panel.Create("TextEntry", Engine.Console)
	Engine.Console.TextEntry:SetPos(5, 475);
	Engine.Console.TextEntry:SetSize(420, 20);
	Engine.Console.TextEntry:SetLive(false);
	function Engine.Console.TextEntry:OnReturn()
		if( Engine.Console.TextEntry.Text == "" ) then
			return
		end
		local TextTable = string.Explode(" ", self.Text);
		local Cmd = table.remove(TextTable, 1);
		if( TextTable[1] ) then
			clientcommand.Check(Cmd, unpack(TextTable));
		else
			clientcommand.Check(Cmd)
		end
		self:Clear();
	end
	
	Engine.Console.Button = panel.Create("Button", Engine.Console)
	Engine.Console.Button:SetPos(430, 475)
	Engine.Console.Button:SetSize(65, 20);
	Engine.Console.Button:SetText("Enter");
	Engine.Console.Button.Func = function(self)
		Engine.Console.TextEntry:OnReturn();
	end
	
end

Engine.CreateConsole();
for i = 1, #g_CurPanels do
	if( g_CurPanels[i] == Engine.Console ) then
		table.remove(g_CurPanels, i);
	end
end
-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

function eng.ConsoleLabel(text, color, align)
	if not eng.Console then return end;
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
	eng.Console.Frame:AddItem(newLabel);
	eng.Console.Frame:ScrollToBottom();
end

function eng.CreateConsole()
	if( eng.Console ) then
		eng.Console:SetLive(not eng.Console:Live());
		if( eng.Console:Live() ) then
			eng.TextFocused = eng.Console.TextEntry;
			panel.PaintOver(eng.Console)
		else
			eng.TextFocused = nil;
		end
		return
	end
	eng.Console = panel.CreateTitleFrame("Console: "..eng.GameTitle, true, ScrW()/2 - 250, ScrH()/2 - 250, 500, 500)
	eng.Console:SetLive(true);
	eng.Console.Frame = panel.Create("ScrollFrame", eng.Console);
	eng.Console.Frame:SetSize(490, 440);
	eng.Console.Frame:SetPos(5, 30);
	eng.Console.Frame:EnableVerticalScrollbar();
	eng.Console.Frame:SetLive(true);
	
	eng.Console.TextEntry = panel.Create("TextEntry", eng.Console)
	eng.Console.TextEntry:SetPos(5, 475);
	eng.Console.TextEntry:SetSize(420, 20);
	eng.Console.TextEntry:SetLive(true);
	function eng.Console.TextEntry:OnReturn()
		if( eng.Console.TextEntry.Text == "" ) then
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
	
	eng.Console.Button = panel.Create("Button", eng.Console)
	eng.Console.Button:SetPos(430, 475)
	eng.Console.Button:SetSize(65, 20);
	eng.Console.Button:SetText("Enter");
	eng.Console.Button:SetLive(true);
	eng.Console.Button.Func = function(self)
		eng.Console.TextEntry:OnReturn();
	end
	eng.TextFocused = eng.Console.TextEntry;
	
end

--eng.CreateConsole()
--eng.Console:SetLive(false)
--[[
for i = 1, #g_CurPanels do
	if( g_CurPanels[i] == eng.Console ) then
		table.remove(g_CurPanels, i);
	end
end]]
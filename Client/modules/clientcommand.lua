-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

local clientcommand = {}

function clientcommand.Create(name, func)
	ClientCommand(name, func);
end

function clientcommand.Remove(name)
	if( g_ClientCommands[name] ) then
		g_ClientCommands[name] = nil;
	end
end

function clientcommand.Check(comname, ...)
	local Pass = {...}
	if( g_ClientCommands[comname] ) then
		g_ClientCommands[comname]:Run(unpack(Pass));
	else
		Engine.ConsoleLabel("Console command '"..comname.."' does not exist!", Color(170, 170, 170, 255));
	end
end
	
return clientcommand;
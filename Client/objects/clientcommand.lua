-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

_R.ClientCommand = {}
_R.ClientCommand.__index = _R.ClientCommand;

function ClientCommand(com, func)
	g_ClientCommands[com] = {
		Func = func
	}
	setmetatable(g_ClientCommands[com], _R.ClientCommand);
end

function _R.ClientCommand:Run(...)
	local Pass = {...};
	self.Func(unpack(Pass));
end
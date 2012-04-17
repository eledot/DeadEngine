-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

local pairs = pairs;
local hook = {}
local Hooks = {}

function hook.Add(n, u, f)	
	Hooks[n] = Hooks[n] or {}
	Hooks[n][u] = f;
end

function hook.GetTable()
	return Hooks
end

function hook.Remove(n, u)	
	Hooks[n] = Hooks[n] or {}
	if( Hooks[n][u] ) then
		Hooks[n][u] = nil
	end
end

function hook.Call(n, ...)
	if( Hooks[n] ) then
		for k,func in pairs(Hooks[n]) do
			func(...)
		end
	end
end

return hook
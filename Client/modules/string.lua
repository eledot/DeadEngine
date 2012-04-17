-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

local string = string;

function string.ToTable ( str )
	local tab = {}
	for i=1, string.len( str ) do
			table.insert( tab, string.sub( str, i, i ) )
	end        
	return tab
end

function string.Explode ( seperator, str )
	if ( seperator == "" ) then
			return string.ToTable( str )
	end
	local tble={}   
	local ll=0        
	while (true) do
			l = string.find( str, seperator, ll, true )                
			if (l) then
					table.insert(tble, string.sub(str,ll,l-1)) 
					ll=l+1
			else
					table.insert(tble, string.sub(str,ll))
					break
			end                
	end
	return tble
end

function string.Implode(seperator,Table)
    return table.concat(Table,seperator) 
end
   
function string.ImplodeAssocLight(seperator,Table)
	local keys, values = {}, {};
	for k,v in pairs(Table) do
		table.insert(keys, k);
		table.insert(values, v);
	end	
	return(string.Implode(seperator,keys)..seperator..string.Implode(seperator, values));
end

function string.ExplodeAssocLight(seperator,String)
	local Table = string.Explode(seperator, String);
	local Size = #Table;
	local Return = {}
	for i = 1, Size/2 do
		Return[Table[i]] = Table[i+(Size/2)];
	end
	return Return;
end
	
		
return string;
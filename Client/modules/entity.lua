-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

local entity = {}

function entity.Register(typ, tab,  b)
	local ent = {}
	if( b and g_EntitiesTable[b] ) then
		for k,v in pairs(g_EntitiesTable[b]) do
			ent[k] = v;
		end
	end
	for k,v in pairs(tab or {}) do
		ent[k] = v;
	end
	g_EntitiesTable[tostring(typ)] = ent;
end

function entity.Create(typ)
	local ent = {}
	if( g_EntitiesTable[typ] ) then
		ent = Entity();
		for k,v in pairs(g_EntitiesTable[typ]) do
			ent[k] = v;
		end
	end
	ent:Init();
	g_Entities[#g_Entities+1] = ent;
	return ent;
end

function entity.GetAll()
	return g_Entities or {};
end

function entity.GetByClass(typ)
	if not typ then return end;
	local tab = {}
	for k,v in pairs(g_Entities) do
		if( v.Type == typ ) then
			table.insert(tab, v);
		end
	end
	return tab;
end

function entity.Kill(ent)
	local ents
	for k,v in pairs(g_Entities) do
		if( v == ent ) then
			ents = table.remove(g_Entites, k);
		end
	end
	ents = nil;
end

function entity.GetMapEnts()
	local tab = {}
	for k,v in pairs(g_EntitiesTable) do
		if( v.MapEnt ) then
			table.insert(tab, v);
		end
	end
	return tab;
end

local function entityPaint()
	for k,v in pairs(entity.GetAll()) do
		v:Paint();
	end
end

local function entityThink()
	for k,v in pairs(entity.GetAll()) do
		v:Think();
	end
end
hook.Add("Think", "EntityThinkFunc", entityThink);
hook.Add("ScreenDraw", "EntityPaintFunc", entityPaint);

return  entity;
		
	
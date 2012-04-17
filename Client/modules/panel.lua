-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

local panel = {}

function panel.Create(typ, parent)
	local newPanel = Panel();
	if( parent ) then
		table.insert(parent.Children, newPanel);
		newPanel:SetParent( parent )
	end		
	local Type = g_PanelList[tostring(typ)] or g_PanelList["Frame"];
	for k,v in pairs( Type ) do
		newPanel[k] = v;
	end
	newPanel:Init();
	if( not parent ) then
		table.insert(g_CurPanels, newPanel);
	end
	return newPanel;
end

function panel.Exists(name)
	return g_PanelList[tostring(name)] or false;
end

function panel.Register(tbl, name, base)
	local newPanel = {};
	if( base and panel.Exists(base) ) then
		for k,v in pairs(g_PanelList[tostring(base)]) do
			newPanel[k] = v;
		end
	end
	for k,v in pairs(tbl or {}) do
		newPanel[k] = v;
	end
	g_PanelList[tostring(name)] = newPanel;
end

function panel.GetAll()
	return g_CurPanels or {};
end

local function panelPaint()
	--for i = #g_CurPanels, 1, -1 do
	for i = 1, #g_CurPanels do	
		if( g_CurPanels[i]:Live() ) then
			g_CurPanels[i]:Paint();
			g_CurPanels[i]:NoOverridePaint();
		end
	end
end
hook.Add("__GUIDraw", "enginePanelPaint", panelPaint)

local function panelThink()
	for k,v in pairs(g_CurPanels) do
		if( v and v:Live() ) then
			v:Think();
			v:NoOverride();
		end
	end
end
hook.Add("Think", "enginePanelThink", panelThink)

return  panel;
		
	
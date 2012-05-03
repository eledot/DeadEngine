-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

local panel = {}
	
function panel.Register(tbl, name, base)
	local PanelTab = tbl;
	if( base and g_PanelList[base] ) then
		PanelTab = {}
		for k,v in pairs(g_PanelList[base]) do
			PanelTab[k] = v;
		end
		for k,v in pairs(tbl) do
			PanelTab[k] = v;
		end
	end
	g_PanelList[name] = PanelTab;
end

function panel.Create(name, parent)
	local newPanel = Panel();
	
	if( parent ) then
		newPanel:SetParent(parent);
	end
	for k,v in pairs(g_PanelList[name] or g_PanelList["Frame"]) do
		newPanel[k] = v;
	end
	newPanel:Init();
	
	if( not parent ) then
		table.insert(g_CurPanels, newPanel);
	end
	return newPanel;
end
	
function panel.IsLive(pnl)
	for k,v in pairs(g_CurPanels) do
		if( v == pnl ) then
			return true;
		end
	end
	return false;
end

function panel.Remove(pnl)
	if( panel.IsLive(pnl) ) then
		for k,v in pairs(g_CurPanels) do
			if( v == pnl ) then
				table.remove(g_CurPanels, k);
			end
		end
	end
	return pnl;
end

function panel.GetAll()
	return g_CurPanels;
end

function panel.PaintOver(p)
	local pan = panel.Remove(p);
	g_CurPanels[#g_CurPanels+1] = p;
	--table.insert(g_CurPanels, p);
end

local function panelPaint()
	for i = 0, #g_CurPanels-1 do
		if( g_CurPanels[i] and g_CurPanels[i]:Live() and not g_CurPanels[i].Scissor ) then
			g_CurPanels[i]:Paint();
			g_CurPanels[i]:_Paint();
		end
	end
end

local function panelThink()
	for i = #g_CurPanels, 1, -1 do
		if( g_CurPanels[i] and g_CurPanels[i]:Live() ) then
			g_CurPanels[i]:Think();
			g_CurPanels[i]:_Think();
		end
	end
end
hook.Add("Think", "_Engine.PanelThink", panelThink);
hook.Add("__EngineDraw", "_Engine.PanelPaint", panelPaint);

function panel.MessageBox(mess, text)
	local tW, tH = surface.GetFont():getWidth(text), surface.GetFont():getHeight();
	local mBoc = panel.CreateTitleFrame(mess, true, ScrW()/2 - ((tW+30)/2), ScrH()/2 - ((tW+10)/2), tW + 30, 60 + tH);
	
	mBoc.Text = panel.Create("TextLabel", mBoc);
	mBoc.Text:SetText(text)
	mBoc.Text:SetPos(15, 30);
	mBoc.Text:SetSize(200, 20)
	
	mBoc.Ok = panel.Create("Button", mBoc)
	mBoc.Ok:SetPos(5, 50)
	mBoc.Ok:SetText("Okay");
	mBoc.Ok:SetSize(tW+20, 20);
	mBoc.Ok.Func = function()
		panel.Remove(mBoc);
	end
	mBoc:SetLive(true)
end

return panel;
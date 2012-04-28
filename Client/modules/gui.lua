-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

gui = {}
gui.MousePos = love.mouse.getPosition;
gui.MouseX = love.mouse.getX;
gui.MouseY = love.mouse.getY;
gui.MouseDown = love.mouse.isDown;
gui.SetCursorPos = love.mouse.setPosition;
gui.key = {}
gui.key.IsDown = love.keyboard.isDown;

function gui.EnableScreenClicker(b)
	g_MouseVisible = b;
	love.mouse.setVisible(b);
end

function gui.ScreenClickerVisible()
	return g_MouseVisible;
end

function gui._IsHovering( pnl )
	if not pnl then return end
	local x, y = pnl:GetPos();
	local w, h = pnl:GetSize();
	local mX, mY = gui.MousePos();
	return ( mX > x and mX < x+w ) and ( mY > y and mY < y+h );
end

function gui._GetAllHovering()
	local tab = {}
	for i = 1, #g_CurPanels do
		if( gui._IsHovering(g_CurPanels[i]) and g_CurPanels[i]:Live() ) then
			table.insert(tab, g_CurPanels[i]);
		end
	end
	return tab;
end

function gui._TopPanel()
	local tb = gui._GetAllHovering();
	return tb[#tb];
end
--[[
	for k,v in pairs(gui._GetAllHovering()) do
		for i = #g_CurPanels-1, 1, -1 do
			if( g_CurPanels[i] == v ) then
				return v;
			end
		end
	end--]]
--end

function gui.GetTopParent(pn)		
	local top = pn;
	if( top.Parent ) then
		top = gui.GetTopParent(top.Parent);
	end
	return top;
end

function gui.IsHovering(pnl)
	return (gui._TopPanel() == gui.GetTopParent(pnl) and gui._IsHovering(pnl));
end

function gui.LeftClicked( pnl )
	return gui.IsHovering( pnl ) and gui.MouseDown( "l" );
end

function gui.RightClicked( pnl )
	return gui.IsHovering( pnl ) and gui.MouseDown( "r" );
end

function gui.ScissorStart(x, y, w, h)
	love.graphics.setScissor(x, y, w, h);
end

function gui.ScissorEnd()
	love.graphics.setScissor(0, 0, ScrW(), ScrH());
end
				
return gui
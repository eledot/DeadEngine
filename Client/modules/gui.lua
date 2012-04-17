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

function gui.IsHovering( pnl )
	if not pnl then return end
	local x, y = pnl:GetPos();
	local w, h = pnl:GetSize();
	local mX, mY = gui.MousePos();
	return ( mX > x and mX < x+w ) and ( mY > y and mY < y+h );
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
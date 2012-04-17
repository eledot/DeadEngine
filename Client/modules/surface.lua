-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

surface = {}

function surface.DrawRect(x, y, w, h)
	love.graphics.rectangle("fill", x, y, w, h);
end

function surface.DrawOutlinedRect(x, y, w, h)
	love.graphics.rectangle("line", x, y, w, h);
end

function surface.SetColor(r, g, b, a)
	if(type(r) == "table") then
		love.graphics.setColor(r.r, r.g, r.b, r.a);
	else
		love.graphics.setColor(r, g, b, a);
	end
end

function surface.GetFont()
	return love.graphics.getFont();
end

function surface.CreateFont(n, f, s)
	Engine.Fonts[n] = love.graphics.newFont(f, s);
end

function surface.SetFont(font)
	local fnt = Engine.Fonts[font] or Engine.Fonts["Default"];
	love.graphics.setFont(fnt)
end

function surface.DrawText(t, x, y, limit, align)
	love.graphics.printf(t, x, y, limit, align);
end

function surface.DrawCircle(x, y, r, s)
	love.graphics.circle("fill", x, y, r, s);
end

function surface.DrawOutlinedCircle(x, y, r, s)
	love.graphics.circle("line", x, y, r, s);
end

function surface.DrawPoly(mode, ...)
	love.graphics.polygon(mode, ...);
end

function surface.DrawLine(...)
	love.graphics.line(...)
end

function surface.DrawGroundLayer(col, m, x, y)
	surface.SetColor(col)
	surface.DrawPoly(m, x + 32, y, x + 64, y + 16 , x + 32, y + 32, x, y + 16, x + 32, y );
end
--x 64 - 32
--y 32 - 16

function surface.DrawRealLayer(x, y)
	surface.SetColor(Color(100, 100, 170, 80));
	surface.DrawOutlinedRect(x, y, 64, 32);
end

function surface.DrawIsometricGrid(x, y, xps, yps, b)
	local xPos, yPos = 0, 0;
	if( b ) then
		xPos = xps;
		yPos = yps;
	end
	local Mode = "line";
	local Col = Color(170, 170, 170, 80);
	for i = 1, y do
		xPos = b and xps or 0;
		for j = 1, x do
			Mode = "line";
			Col = Color(170, 170, 170, 80);
			if( not b and ( i == 1 or i == 2 or j == 1 or j == x or i == y or i == y - 1 ) ) then
				Mode = "fill";
				Col = Color(170, 100, 100, 100);
			end
			surface.DrawGroundLayer(Col, Mode, xPos, yPos);
			surface.DrawRealLayer(xPos, yPos);
			xPos = xPos + 64;
		end
		yPos = yPos + 32;
	end
end
		
	

return surface;
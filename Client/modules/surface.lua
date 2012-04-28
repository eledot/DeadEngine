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

surface.GetFont = love.graphics.getFont;

function surface.CreateFont(n, f, s)
	eng.Fonts[n] = love.graphics.newFont(f, s);
end

function surface.SetFont(font)
	local fnt = eng.Fonts[font] or eng.Fonts["Default"];
	love.graphics.setFont(fnt)
end

surface.DrawText = love.graphics.printf;

function surface.DrawCircle(x, y, r, s)
	love.graphics.circle("fill", x, y, r, s);
end

function surface.DrawOutlinedCircle(x, y, r, s)
	love.graphics.circle("line", x, y, r, s);
end

surface.DrawPoly = love.graphics.polygon;
surface.DrawLine = love.graphics.line;
surface.DrawImage = love.graphics.draw;
surface.DrawImageQuad = love.graphics.drawq;
	

return surface;
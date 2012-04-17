-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

_R.MapCanvas = {}
_R.MapCanvas.__index = _R.MapCanvas;

function MapCanvas(x, y, w, h)
	local mCan = { x = x or 0, y = y or 0, w = w or 640, h = h or 640, Isometric = 64, UseGrid = true};
	setmetatable(mCan, _R.MapCanvas);
	return mCan;
end

function _R.MapCanvas:SetPos(x, y)
	self.x, self.y = math.min(x, 0), math.min(y, 0);
end

function _R.MapCanvas:Isometric32()
	self.Isometric = 32;
end

function _R.MapCanvas:Isometric64()
	self.Isometric = 64;
end

function _R.MapCanvas:GetPos()
	return self.x, self.y;
end

function _R.MapCanvas:SetSize(w, h)
	self.w, self.h = w, h;
end

function _R.MapCanvas:GetSize()
	return self.w, self.h;
end

local sch, scw = ScrH(), ScrW();
local mc_mPosX, mc_mPosY, Dist, mapX, mapY;
local nPos, nR, xPosT = {}, 9999, 0;
local evenLine = 0;
function _R.MapCanvas:Think()
	mc_mPosX, mc_mPosY = gui.MousePos();
	mapX, mapY = self:GetPos();
	nPos = {}
	xPosT = 0;
	nR = 9999;
	for i = 1, self.h/16 do
		evenLine = (xPosT % 2 == 0 and 0) or 32;
		xPosT = xPosT + 1;
		for j = 1, self.w/64 do
			if( (mc_mPosX > mapX + ((j-1)*64)) and (mc_mPosY > mapY + ((i-1)*16)) ) then
				Dist = math.Distance(mc_mPosX, mc_mPosY, mapX + ((j-1)*64)+32, mapY + ((i-1)*16)+16);
				if( Dist < nR ) then
					nR = Dist;
					nPos = { x = mapX + ((j-1)*64)+evenLine, y = mapY + ((i-1)*16) };
				end
			end
		end
	end
	self.WorldPos = nPos;
end

local function getHighestLeft()
	local topY = 9999;
	local topX = 9999;
	if( worldEditor and worldEditor.Selected ) then
		for k,v in pairs(worldEditor.Selected) do
			if(v.x < topX and v.y < topY) then
				topY = v.y;
				topX = v.x;
			end
		end
	end
	return topX, topY;
end

local function getLowestLeft()
	local lowY, lowX = 0, 0;
	if( worldEditor and worldEditor.Selected ) then
		for k,v in pairs(worldEditor.Selected) do
			if( v.x+64 > lowX and v.y+32 > lowY ) then
				lowX = v.x+64;
				lowY = v.y+32;
			end
		end
	end
	return lowX, lowY;
end

function _R.MapCanvas:PaintSelector()
 	if( nPos and nPos.x ) then
		surface.SetColor(Color(100, 100, 200, 100));
		surface.DrawRect(nPos.x, nPos.y, 64, 32);
		if( worldEditor and (worldEditor.CurrentLayer == "Ground" or worldEditor.CurrentLayer == "Environment" )) then
			local lastX, lastY = 0, 0;
			for k,v in pairs(worldEditor.Selected) do
				surface.SetColor(Color(255, 255, 255, 100));
				love.graphics.drawq(v.Image, v.Quad, nPos.x + lastX, nPos.y + lastY);
				if( worldEditor.Selected[k+1] ) then
					lastX = lastX + ( worldEditor.Selected[k+1].x - v.x );
					lastY = lastY + ( worldEditor.Selected[k+1].y - v.y );
				end
			end
		end
	end
end

function _R.MapCanvas:Paint()
	local mPosX, mPosY = self:GetPos();
	local xPos, yPos = mPosX, mPosY;
	local wSize, hSize = self:GetSize();
	gui.ScissorStart(0, 0, ScrW(), ScrH());
	
	if( self.UseGrid ) then
		for i = 1, hSize/16 do
			xPos = (i % 2 == 0 and mPosX+32) or mPosX;
			for j = 1, wSize/64 do
				if( (j*64)+mPosX-64 < scw and (j*64)+mPosX+128 > 0 and (i*16)+mPosY-32 < sch and (i*16)+mPosY+64 > 0 ) then
					surface.DrawGroundLayer(Color(100, 100, 100, 100), "line", xPos, yPos);
					surface.DrawRealLayer(xPos, yPos);
				end
				xPos = xPos + 64;
			end
			yPos = yPos + 16;
		end
	end
		
	gui.ScissorEnd()
end
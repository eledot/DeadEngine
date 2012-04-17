-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------


local WorldEditor = State();
WorldEditor.Interfaces = {}
WorldEditor.TextColor = Color(20, 255, 20, 255);
WorldEditor.Dirs = {}
WorldEditor.Dirs["Tilesets"] = "tilesets";
WorldEditor.Dirs["Textures"] = "textures";
WorldEditor.Selected = {}
WorldEditor.CurrentLayer = "Ground";
WorldEditor.CurrentRotation = 0;
WorldEditor.Undid = {}


WorldEditor.Map = {}
WorldEditor.Map.Size = { x = 640, y = 640 };
WorldEditor.Map.MapName = "Untitled";
WorldEditor.Map.Layers = {}
WorldEditor.Map.Layers["Ground"] = {}
WorldEditor.Map.Layers["Environment"] = {}
WorldEditor.Map.Layers["Collision"] = {}
WorldEditor.Map.Layers["Entity"] = {}

local function createTileSetBox()
	if( WorldEditor.CurrentImage ) then
		WorldEditor.CurrentImage = nil;
	end
	if( WorldEditor.Interfaces.TileBoxFrame ) then
		for k,v in pairs(g_CurPanels) do
			if( v == WorldEditor.Interfaces.TileBoxFrame ) then
				local fr = table.remove(g_CurPanels, k);
				fr = nil
			end
		end
		WorldEditor.Interfaces.TileBoxFrame:SetLive(false);
		WorldEditor.Interfaces.TileBoxFrame = nil;
	end
	WorldEditor.CurrentImage = Engine.Tilesets[WorldEditor.CurrentTileSet];
	local iF = WorldEditor.Interfaces or {};
	local fX = ((ScrW()/2)-(WorldEditor.CurrentImage:getWidth()/2)) - 3;
	local fY = (ScrH()/2) - 300;
	iF.TileBoxFrame = panel.CreateTitleFrame("TileSet: "..WorldEditor.CurrentTileSet, true, fX, fY, WorldEditor.CurrentImage:getWidth()+26, 600);
	iF.TileBoxFrame:SetLive(true);
	
	iF.TileBoxScroll = panel.Create("ScrollFrame", iF.TileBoxFrame);
	iF.TileBoxScroll:SetPos(3, 25)
	iF.TileBoxScroll:SetSize(iF.TileBoxFrame.Size.w - 6, 572);
	iF.TileBoxScroll:EnableVerticalScrollbar();
	iF.TileBoxScroll:SetLive(true);
	
	local ima = WorldEditor.CurrentImage;
	iF.ImageBox = panel.Create("TileSetPanel")
	iF.ImageBox:SetImage(ima);
	iF.ImageBox:SetSize(ima:getWidth(), ima:getHeight());
	iF.ImageBox:ToggleGrid()
	
	iF.TileBoxScroll:AddItem(iF.ImageBox);

end

local function SortY(a, b)
	return a.PosY + a.iH < b.PosY + b.iH;
end
	
local function sortLayer(layer)
	table.sort(WorldEditor.Map.Layers[layer], SortY);
end
			
local function saveMap()
	sortLayer("Environment");
	sortLayer("Ground");
	love.filesystem.setIdentity("Dropdead/maps");
	love.filesystem.write(string.lower(WorldEditor.Map.MapName)..".dmf", json.encode(WorldEditor.Map));
	love.filesystem.setIdentity("Dropdead");
end

local function loadMap(mapname)
	WorldEditor.Map = json.decode(tostring(love.filesystem.read(string.lower(tostring(mapname)))));
end

local function deleteMap(mapname)
	love.filesystem.remove(string.lower(tostring(mapname)));
end

local function loadDialog()

	local iF = WorldEditor.Interfaces or {};
	
	iF.NewLoad = panel.CreateTitleFrame("LoadMap", true, ScrW()/2-150, ScrH()/2-100, 300, 200);
	iF.NewLoad:SetLive(true);
	
	iF.NewLoad.Scroll = panel.Create("ScrollFrame", iF.NewLoad)
	iF.NewLoad.Scroll:SetSize(290, 130)
	iF.NewLoad.Scroll:SetPos(5, 30);
	iF.NewLoad.Scroll:EnableVerticalScrollbar(true);
	iF.NewLoad.Scroll:SetLive(true)
	
	local SelectedMap
	local Maps = FileEnumerateRecursive("maps")
	
	for k,v in pairs(Maps) do
		local link = panel.Create("Link")
		link:SetText(tostring(v));
		link:SetSize(286, 20);
		link.OnClick = function(lnk)
			SelectedMap = tostring(v);
		end
		iF.NewLoad.Scroll:AddItem(link);
	end
	
	iF.NewLoad.LoadButton = panel.Create("Button", iF.NewLoad);
	iF.NewLoad.LoadButton:SetPos(5, 170)
	iF.NewLoad.LoadButton:SetSize(140, 20)
	iF.NewLoad.LoadButton:SetText("Load Map")
	iF.NewLoad.LoadButton:SetLive(true);
	iF.NewLoad.LoadButton.Func = function(btn)
		if( SelectedMap ) then
			loadMap(SelectedMap);
			SelectedMap = nil
			iF.NewLoad:SetLive(false)
			for k,v in pairs(g_CurPanels) do
				if( v == iF.NewLoad	) then
					table.remove(g_CurPanels[k]);
				end
			end
		end
	end
	
	iF.NewLoad.DeleteButton = panel.Create("Button", iF.NewLoad);
	iF.NewLoad.DeleteButton:SetPos(150, 170)
	iF.NewLoad.DeleteButton:SetSize(145, 20);
	iF.NewLoad.DeleteButton:SetText("Delete Map");
	iF.NewLoad.DeleteButton:SetLive(true);
	iF.NewLoad.DeleteButton.Func = function(btn)
		if( SelectedMap ) then
			deleteMap(SelectedMap)
			SelectedMap = nil;
			iF.NewLoad:SetLive(false)
			for k,v in pairs(g_CurPanels) do
				if( v == iF.NewLoad	) then
					table.remove(g_CurPanels[k]);
				end
			end
			loadDialog();
		end
	end
	
end

local function saveDialog(b, c)
	local CameFromNewMap = b or false;
	local iF = WorldEditor.Interfaces or {};
	
	iF.NewSave = panel.CreateTitleFrame("SaveMap", true, ScrW()/2-100, ScrH()/2-100, 286, 94);
	iF.NewSave:SetLive(true);
	
	iF.NewSave.TextLabel = panel.Create("TextLabel", iF.NewSave)
	iF.NewSave.TextLabel:SetPos(5, 40);
	iF.NewSave.TextLabel:SetSize(70, 18);
	iF.NewSave.TextLabel:SetText("Save "..WorldEditor.Map.MapName.."?");
	iF.NewSave.TextLabel:SetLive(true);
	
	iF.NewSave.Ok = panel.Create("Button", iF.NewSave)
	iF.NewSave.Ok:SetPos(5, 62)
	iF.NewSave.Ok:SetSize(133, 20)
	iF.NewSave.Ok:SetText("Save");
	iF.NewSave.Ok:SetLive(true);
	iF.NewSave.Ok.Func = function(btn)
		saveMap()
		if( iF.NewMap and iF.NewMap.Create and CameFromNewMap ) then
			iF.NewMap.Create:Func(true);
		end
		iF.NewSave:SetLive(false)
		for k,v in pairs(g_CurPanels) do
			if( v == iF.NewSave	) then
				table.remove(g_CurPanels[k]);
			end
		end
		if( c ) then	
			clientcommand.Check("close_worldeditor");
		end
	end
	
	iF.NewSave.No = panel.Create("Button", iF.NewSave)
	iF.NewSave.No:SetPos(147, 62)
	iF.NewSave.No:SetSize(133, 20)
	iF.NewSave.No:SetText("Don't Save");
	iF.NewSave.No:SetLive(true);
	iF.NewSave.No.Func = function(btn)
		if( iF.NewMap and iF.NewMap.Create and CameFromNewMap ) then
			iF.NewMap.Create:Func(true);
		end
		iF.NewSave:SetLive(false);
		for k,v in pairs(g_CurPanels) do
			if( v == iF.NewSave	) then
				table.remove(g_CurPanels[k]);
			end
		end
		if( c ) then	
			clientcommand.Check("close_worldeditor");
		end
	end
			
	
end

local function newMap()
	local iF = WorldEditor.Interfaces or {};
	
	iF.NewMap = panel.CreateTitleFrame("NewMap", true, ScrW()/2-143, ScrH()/2-47, 286, 94);
	iF.NewMap:SetLive(true);
	
	iF.NewMap.TextLabel = panel.Create("TextLabel", iF.NewMap)
	iF.NewMap.TextLabel:SetPos(5, 40)
	iF.NewMap.TextLabel:SetSize(70, 18);
	iF.NewMap.TextLabel:SetText("Map Name:");
	iF.NewMap.TextLabel:SetLive(true);
	
	iF.NewMap.Entry = panel.Create("TextEntry", iF.NewMap)
	iF.NewMap.Entry:SetPos(80, 40);
	iF.NewMap.Entry:SetSize(200, 18);
	iF.NewMap.Entry:SetLive(true);
	
	iF.NewMap.Create = panel.Create("Button", iF.NewMap)
	iF.NewMap.Create:SetPos(5, 62)
	iF.NewMap.Create:SetSize(276, 20);
	iF.NewMap.Create:SetText("Create");
	iF.NewMap.Create:SetLive(true);
	iF.NewMap.Create.Func = function(btn,b)
		if( not b and (WorldEditor.Map.Layers["Ground"][1] or WorldEditor.Map.Layers["Environment"][1] or WorldEditor.Map.Layers["Collision"][1] or WorldEditor.Map.Layers["Entity"][1]) ) then
			saveDialog(true);
		elseif( string.len(iF.NewMap.Entry.Text) > 0 ) then
			WorldEditor.Map.MapName = tostring(iF.NewMap.Entry.Text);
			WorldEditor.Map.Layers["Ground"] = {}
			WorldEditor.Map.Layers["Environment"] = {}
			WorldEditor.Map.Layers["Collision"] = {}
			WorldEditor.Map.Layers["Entity"] = {}
			iF.NewMap:SetLive(false);
			for k,v in pairs(g_CurPanels) do
				if( v == iF.NewMap ) then
					table.remove(g_CurPanels[k]);
				end
			end
		end
	end
end

local function createWorldBar()
	local iF = WorldEditor.Interfaces or {};
	iF.FileBar = panel.Create("FileBar");
	iF.FileBar:SetPos(0, 0);
	iF.FileBar:SetSize(ScrW(), 24);
	iF.FileBar:SetLive(true);
	
	local BarButtons = {}
	BarButtons["ToggleGrid"] = {
		Func = function(btn) 
			if( WorldEditor.MapCanvas ) then
				WorldEditor.MapCanvas.UseGrid = not WorldEditor.MapCanvas.UseGrid;
			end
		end,
		Image = "textures/ui/grid.png",
		PosX = iF.FileBar.Size.w - 145,
		PosY = 3,
		SizeX = 16,
		SizeY = 16
	}
	BarButtons["Tileset Selector"] = {
		Func = function(btn)
			if( iF.TileFrame ) then
				iF.TileFrame:SetLive( not iF.TileFrame:Live() );
			end
		end,
		Image = "textures/ui/tilesel.png";
		PosX = iF.FileBar.Size.w - 166,
		PosY = 3,
		SizeX = 16,
		SizeY = 16
	}
	BarButtons["Layout Panels"] = {
		Func = function(btn)
			if( iF.TileFrame ) then
				iF.TileFrame:SetPos(2, 24);
			end
		end,
		Image = "textures/ui/layout.png";
		PosX = iF.FileBar.Size.w - 187,
		PosY = 3,
		SizeX = 16,
		SizeY = 16
	}
	BarButtons["Save"] = {
		Func = function(btn)
			saveMap();
		end,
		Image = "textures/ui/save.png";
		PosX = iF.FileBar.Size.w - 229,
		PosY = 3,
		SizeX = 16,
		SizeY = 16
	}
	BarButtons["Load"] = {
		Func = function(btn)
			loadDialog();
		end,
		Image = "textures/ui/load.png";
		PosX = iF.FileBar.Size.w - 208,
		PosY = 3,
		SizeX = 16,
		SizeY = 16
	}
	BarButtons["New Map"] = {
		Func = function(btn)
			newMap();
		end,
		Image = "textures/ui/newmap.png",
		PosX = iF.FileBar.Size.w-250,
		PosY = 3,
		SizeX = 16,
		SizeY = 16
	}
	BarButtons["Clear Map"] = {
		Func = function (btn)
			WorldEditor.Map.Layers["Ground"] = {}
			WorldEditor.Map.Layers["Environment"] = {}
			WorldEditor.Map.Layers["Collision"] = {}
			WorldEditor.Map.Layers["Entity"] = {}
		end,
		Image = "textures/ui/clearmap.png",
		PosX = iF.FileBar.Size.w-271,
		PosY = 3,
		SizeX = 16,
		SizeY = 16
	}
	BarButtons["Collision Layer"] = {
		Func = function(btn)
			WorldEditor.CurrentLayer = "Collision";
		end,
		Image = "textures/ui/collision.png",
		PosX = iF.FileBar.Size.w-292,
		PosY = 3,
		SizeX = 16,
		SizeY = 16
	}
	BarButtons["Environment Layer"] = {
		Func = function(btn)
			WorldEditor.CurrentLayer = "Environment";
		end,
		Image = "textures/ui/environment.png",
		PosX = iF.FileBar.Size.w-313,
		PosY = 3,
		SizeX = 16,
		SizeY = 16
	}
	BarButtons["Ground Layer"] = {
		Func = function(btn)
			WorldEditor.CurrentLayer = "Ground";
		end,
		Image = "textures/ui/ground.png",
		PosX = iF.FileBar.Size.w-334,
		PosY = 3,
		SizeX = 16,
		SizeY = 16
	}
	BarButtons["Entity Layer"] = {
		Func = function(btn)
			WorldEditor.CurrentLayer = "Entity";
		end,
		Image = "textures/ui/entity.png",
		PosX = iF.FileBar.Size.w-355,
		PosY = 3,
		SizeX = 16,
		SizeY = 16
	}
	BarButtons["Undo"] = {
		Func = function(btn)
			if( #WorldEditor.Map.Layers[WorldEditor.CurrentLayer] > 0 ) then 
				table.insert(WorldEditor.Undid, table.remove(WorldEditor.Map.Layers[WorldEditor.CurrentLayer], WorldEditor.Map.Layers[#WorldEditor.CurrentLayer]));
			end
		end,
		Image = "textures/ui/rotneg.png",
		PosX = iF.FileBar.Size.w - 376,
		PosY = 3,
		SizeX = 16,
		SizeY = 16
	}
	BarButtons["Redo"] = {
		Func = function(btn)
			if( #WorldEditor.Undid > 0 ) then
				table.insert(WorldEditor.Map.Layers[WorldEditor.CurrentLayer], table.remove(WorldEditor.Undid, #WorldEditor.Undid));
			end
		end,
		Image = "textures/ui/rotpos.png",
		PosX = iF.FileBar.Size.w - 397,
		PosY = 3,
		SizeX = 16,
		SizeY = 16
	}
	BarButtons["Close Editor"] = {
		Func = function(btn)
			if(WorldEditor.Map.Layers["Ground"][1] or WorldEditor.Map.Layers["Environment"][1] or WorldEditor.Map.Layers["Collision"][1] or WorldEditor.Map.Layers["Entity"][1]) then
				saveDialog(false, true);
			else
				clientcommand.Check("close_worldeditor");
			end
		end,
		Image = "textures/ui/close.png",
		PosX = 3,
		PosY = 3,
		SizeX = 16,
		SizeY = 16
	}
	
	for k,v in pairs(BarButtons) do
		local newButton = panel.Create("ImageButton", iF.FileBar)
		newButton:SetPos(v.PosX, v.PosY);
		newButton:SetSize(v.SizeX, v.SizeY);
		newButton:SetImage(Engine.Textures[v.Image]);
		newButton.Func = v.Func;
		newButton:SetToolTip(k);
		newButton:SetLive(true)
	end
	
	iF.yEntry = panel.Create("TextEntry", iF.FileBar)
	iF.yEntry:SetPos(iF.FileBar.Size.w - 50, 3);
	iF.yEntry:SetSize(47, 18);
	iF.yEntry:SetValue("640");
	iF.yEntry:SetLive(true);
	function iF.yEntry.OnTextChanged(entr)
		if( type(tonumber(entr.Text)) == "number" ) then
			WorldEditor.Map.Size.y = math.Clamp(tonumber(entr.Text), 640, 8192);
			if( WorldEditor.MapCanvas ) then
				WorldEditor.MapCanvas.h = WorldEditor.Map.Size.y;
			end
		end

	end
	
	iF.yLabel = panel.Create("TextLabel", iF.FileBar)
	iF.yLabel:SetPos(iF.FileBar.Size.w - 61, 3);
	iF.yLabel:SetSize(20, 18);
	iF.yLabel:SetText("y:");
	iF.yLabel:SetLive(true);
	
	iF.xEntry = panel.Create("TextEntry", iF.FileBar)
	iF.xEntry:SetPos(iF.FileBar.Size.w - 114, 3);
	iF.xEntry:SetSize(47, 18);
	iF.xEntry:SetValue("640");
	iF.xEntry:SetLive(true);
	function iF.xEntry.OnTextChanged(entr)
		if( type(tonumber(entr.Text)) == "number" ) then
			WorldEditor.Map.Size.x = math.Clamp(tonumber(entr.Text), 640, 8192);
			if( WorldEditor.MapCanvas ) then
				WorldEditor.MapCanvas.w = WorldEditor.Map.Size.x;
			end
		end
	end

	iF.xLabel = panel.Create("TextLabel", iF.FileBar)
	iF.xLabel:SetPos(iF.FileBar.Size.w - 125, 3);
	iF.xLabel:SetSize(20, 18);
	iF.xLabel:SetText("x:");
	iF.xLabel:SetLive(true);
	
	iF.InfoLabel = panel.Create("TextLabel", iF.FileBar)
	iF.InfoLabel:SetPos(24, 3)
	iF.InfoLabel:SetText("TileCount: x: "..WorldEditor.Map.Size.x/64 .." y: "..WorldEditor.Map.Size.y/32 .. " FPS: "..love.timer.getFPS() .." MapName: "..WorldEditor.Map.MapName);
	iF.InfoLabel:SetSize(50, 18);
	iF.InfoLabel:SetLive(true);
	iF.InfoLabel.Think = function(bt)
		if( love.timer.getFPS() > 50 ) then
			bt.Color = Color(100, 255, 100, 255);
		else
			bt.Color = Color(255, 100, 100, 255);
		end
		bt.Text = "TileCount: x: ".. WorldEditor.Map.Size.x/64 .." y: ".. WorldEditor.Map.Size.y/32 .. " FPS: "..love.timer.getFPS() .." MapName: "..WorldEditor.Map.MapName;
	end
	iF.InfoLabel:Align("left");
		
	
	iF.TileFrame = panel.CreateTitleFrame("Tileset Selector", false, 2, 24, 196, 288);
	iF.TileFrame:SetLive(true)
	
	iF.TileFrame.ScrollFrame = panel.Create("ScrollFrame", iF.TileFrame);
	local tlf = iF.TileFrame.ScrollFrame;
	tlf:SetPos(3, 28)
	tlf:SetSize(190, 230);
	tlf:SetLive(true);
	
	iF.TileFrame.Select = panel.Create("Button", iF.TileFrame);
	local tlb = iF.TileFrame.Select;
	tlb:SetPos(3, 260);
	tlb:SetSize(190, 25);
	tlb:SetText("Select Tileset");
	tlb:SetLive(true)
	tlb.CurrentSelect = "";
	tlb.Func = function(btn)
		if( tlb.CurrentSelect ~= "" ) then
			WorldEditor.CurrentTileSet = tlb.CurrentSelect;
			createTileSetBox();
		end
	end
			
	
	for k,v in pairs(Engine.Tilesets) do
		local label = panel.Create("Link");
		label:SetSize(200, 20);
		label:SetText(tostring(k));
		label.OnClick = function(btn)
			tlb.CurrentSelect = label.Text;
		end
		tlf:AddItem(label);
	end
	WorldEditor.CurrentTileSet = tlf.Items[1].Text;
end

function WorldEditor:Init()
	self.Interfaces = {}
	WorldEditor.Map.Size = { x = 640, y = 640 };
	WorldEditor.Map.MapName = "Untitled";
	WorldEditor.Map.Layers = {}
	WorldEditor.Map.Layers["Ground"] = {}
	WorldEditor.Map.Layers["Environment"] = {}
	WorldEditor.Map.Layers["Collision"] = {}
	WorldEditor.Map.Layers["Entity"] = {}
	Engine.ConsoleLabel("[[----WorldEditor Initialized----]]", self.TextColor, "left");
	createWorldBar()
	self.MapCanvas = MapCanvas(0, 0, self.Map.Size.x, self.Map.Size.y);
end

function WorldEditor:GetMapSize()
	return self.Map.Size;
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

local function getLowestRight()
	local lowY, lowX = 0, 0;
	if( worldEditor and worldEditor.Selected ) then
		for k,v in pairs(worldEditor.Selected) do
			if( v.x+64 >= lowX and v.y+32 >= lowY ) then
				lowX = v.x+64;
				lowY = v.y+32;
			end
		end
	end
	return lowX, lowY;
end

local function addToLayer(layer,b)
	local layer = tostring(layer) or "Ground";
	local MapX, MapY = WorldEditor.MapCanvas:GetPos();
	local WorldX, WorldY = WorldEditor.MapCanvas.WorldPos.x, WorldEditor.MapCanvas.WorldPos.y;
	local ImageX, ImageY = WorldEditor.Selected.x, WorldEditor.Selected.y;
	local Image = WorldEditor.CurrentTileSet;
	
	local SelTab = {}
	local Tab = {}
	local lastX, lastY = 0, 0;

	if( not b ) then
		for k,v in pairs(WorldEditor.Selected) do
			Tab = {
				PosX = math.abs(MapX) + WorldX + lastX,
				PosY = math.abs(MapY) + WorldY + lastY,
				iX = v.x,
				iY = v.y,
				iW = 64,
				iH = 32,
				Quad = love.graphics.newQuad(v.x, v.y, 64, 32, v.Image:getWidth(), v.Image:getHeight()),
				Image = v.Image
			}
			if( worldEditor.Selected[k+1] ) then
				lastX = lastX + ( worldEditor.Selected[k+1].x - v.x );
				lastY = lastY + ( worldEditor.Selected[k+1].y - v.y );
			end
			table.insert(SelTab, Tab);
		end
	else
		Tab = {
			PosX = math.abs(MapX) + WorldX,
			PosY = math.abs(MapY) + WorldY,
		}
	end
	--if( layer == "Ground" or b ) then
	--	for k,v in pairs(WorldEditor.Map.Layers[layer]) do
	--		if( v.PosX == Tab.PosX and v.PosY == Tab.PosY ) then
	--			table.remove(WorldEditor.Map.Layers[layer], k)
	--		end
	--	end
	--end
--	if( layer == "Ground" ) then
--		for k,v in pairs(SelTab) do
--			table.insert(WorldEditor.Map.Layers[layer], v);
--		end
--	elseif( not b ) then
	if( not b ) then
		local x, y = getHighestLeft();
		local w, h = getLowestRight();
		w, h = w-x, h-y;
		Tab = {
			PosX = math.abs(MapX) + WorldX,
			PosY = math.abs(MapX) + WorldY,
			iX = x,
			iY = y,
			iW = w,
			iH = h,
			PosZ = 0,
			Quad = love.graphics.newQuad(x, y, w, h, WorldEditor.CurrentImage:getWidth(), WorldEditor.CurrentImage:getHeight()),
			Image = WorldEditor.CurrentImage
		}
		table.insert(WorldEditor.Map.Layers[layer], Tab);
	end
	--if( layer ~= "Ground" ) then
		sortLayer(layer);
	--end
	Tab = nil;
end

local function addToCollision(b)
	local MapX, MapY = WorldEditor.MapCanvas:GetPos();
	local WorldX, WorldY = WorldEditor.MapCanvas.WorldPos.x, WorldEditor.MapCanvas.WorldPos.y;
	
	local Tab = {
		PosX = math.abs(MapX) + WorldX,
		PosY = math.abs(MapY) + WorldY
	}
	
	for k,v in pairs(WorldEditor.Map.Layers["Collision"]) do
		if( v.PosX == Tab.PosX and v.PosY == Tab.PosY ) then
			table.remove(WorldEditor.Map.Layers["Collision"], k);
		end
	end
	
	if( not b ) then
		table.insert(WorldEditor.Map.Layers["Collision"], Tab);
	end
	Tab = nil;
end

local LastDT = 3;
function WorldEditor:Think(dt)
	if( self.MapCanvas ) then
		self.MapCanvas:Think();
		local posX, posY = self.MapCanvas:GetPos();
		if( gui.key.IsDown("left") ) then
			self.MapCanvas:SetPos(posX + 10, posY);
		elseif( gui.key.IsDown("right") ) then
			self.MapCanvas:SetPos(posX - 10, posY);
		elseif( gui.key.IsDown("up") ) then
			self.MapCanvas:SetPos(posX, posY+10);
		elseif( gui.key.IsDown("down") ) then
			self.MapCanvas:SetPos(posX, posY-10);
		elseif( gui.key.IsDown("left") and gui.key.IsDown("up") ) then
			self.MapCanvas:SetPos(posX+10, posY+10);
		elseif( gui.key.IsDown("left") and gui.key.IsDown("down") ) then
			self.MapCanvas:SetPos(posX+10, posY-10);
		elseif( gui.key.IsDown("right") and gui.key.IsDown("up") ) then
			self.MapCanvas:SetPos(posX-10, posY+10);
		elseif( gui.key.IsDown("right") and gui.key.IsDown("down") ) then
			self.MapCanvas:SetPos(posX-10, posY-10);
		end
		
		if( gui.key.IsDown("r") ) then
			WorldEditor.Selected = {}
		end
			
		if( self.MapCanvas.WorldPos and self.MapCanvas.WorldPos.x ) then			
			if( gui.key.IsDown("lalt") and gui.MouseDown("l") and util.NoPanelInTheWay() ) then
				if ( (self.CurrentLayer == "Ground" or self.CurrentLayer == "Environment") and (self.Selected) ) then
					if( LastDT == 3) then
						addToLayer(WorldEditor.CurrentLayer);
					end
				elseif( self.CurrentLayer == "Collision" ) then
					addToCollision();
				end
			elseif( gui.MouseDown("r") and util.NoPanelInTheWay() ) then
				if ( self.CurrentLayer == "Ground" or self.CurrentLayer == "Environment" ) then
					addToLayer(WorldEditor.CurrentLayer, true);
				elseif( self.CurrentLayer == "Collision" ) then
					addToCollision(true);
				end
			end
		end
		LastDT = (LastDT == 3 and 0) or LastDT+1;
	end
end

local imgQuad, Alpha
local mapdX, mapdY, curImg
function WorldEditor:ScreenDraw()
	--surface.DrawIsometricGrid(self:GetMapSize().x+2, self:GetMapSize().y+4)
	Alpha = 255;
	if( self.MapCanvas ) then
		mapdX, mapdY = self.MapCanvas:GetPos();
		self.MapCanvas:Paint()
		for k,v in pairs(self.Map.Layers["Ground"]) do
			if( (mapdX + v.PosX)-128 < ScrW() and (mapdX + (v.PosX))+128 > 0 and (mapdY + v.PosY)-64 < ScrH() and (mapdY + (v.PosY))+64 > 0 ) then
				Alpha = (self.CurrentLayer == "Ground" and 255) or 150;
				surface.SetColor(255, 255, 255, Alpha)
				love.graphics.drawq(v.Image, v.Quad, mapdX+v.PosX, mapdY+v.PosY);
			end
		end
		local lmp = self.Map.Layers["Environment"];
		for i = 1, #lmp do
			if( (mapdX + lmp[i].PosX)-(lmp[i].iW*2) < ScrW() and (mapdX + (lmp[i].PosX))+(lmp[i].iW*2) > 0 and (mapdY + lmp[i].PosY)-(lmp[i].iH*2) < ScrH() and (mapdY + (lmp[i].PosY))+(lmp[i].iH*2) > 0 ) then
				Alpha = (self.CurrentLayer == "Environment" and 255) or 70;
				surface.SetColor(255, 255, 255, Alpha)
				love.graphics.drawq(lmp[i].Image, lmp[i].Quad, mapdX+lmp[i].PosX, mapdY+lmp[i].PosY);
			end
		end
		for k,v in pairs(self.Map.Layers["Collision"]) do
			if( (mapdX + v.PosX)-128 < ScrW() and (mapdX + (v.PosX))+128 > 0 and (mapdY + v.PosY)-64 < ScrH() and (mapdY + (v.PosY))+64 > 0 ) then
				Alpha = (self.CurrentLayer == "Collision" and 120) or 80;
				surface.SetColor(255, 100, 100, Alpha);
				surface.DrawRect(mapdX+v.PosX, mapdY+v.PosY, 64, 32);
			end
		end
		self.MapCanvas:PaintSelector();
	end
end

function WorldEditor:KeyPressed(k, u)
end

function WorldEditor:Shutdown()
	if( not self.Interfaces ) then
		return
	end
	Engine.ConsoleLabel("[[----WorldEditor Shutting Down----]]", self.TextColor, "left");
	for k,v in pairs(self.Interfaces) do
		v:SetLive(false)
		for i = 1, #g_CurPanels do
			if( g_CurPanels[i] == v ) then
				table.remove(g_CurPanels, i);
			end
		end
		v = nil;
	end
	self.Interfaces = nil;
	self.MapCanvas = nil;
end

return WorldEditor;

-----------------------------------------------------------------------------------------------------------------
--	 ___   ____   ____   ____   ___   ___     _    ___           ___   _____  _  _   ___    ___   ____    ___  --
--	\   \ /  _ \ / __ \ )  _)\ \   \ ) __(   )_\  \   \  ____   (  _( )__ __() () ( \   \  )_ _( / __ \  (  _( --
--	| ) ( )  ' / ))__(( | '__/ | ) ( | _)   /( )\ | ) ( )____(  _) \    | |  | \/ | | ) (  _| |_ ))__((  _) \  --
--	/___/ |_()_\ \____/ )_(    /___/ )___( )_/ \_(/___/        )____)   )_(  )____( /___/ )_____(\____/ )____) --
-----------------------------------------------------------------------------------------------------------------

local Editor = State();
Editor.Interfaces = {}
Editor.Interfaces.BarButtons = {}
function Editor:Init()
	print("--WorldEditor Enabled--");
	
	Editor.Interfaces = {}
	Editor.Interfaces.BarButtons = {}
	
	Editor.Map = {}
	
	Editor.Defaults = {}
	Editor.Defaults.BlockSize = 16;
	Editor.Defaults.Size = { x = 128, y = 128 };
	Editor.Defaults.Name = "Untitled";
	Editor.Defaults.Texture = eng.Textures["textures/ground/grass_light16.png"];
	
	self:CreateGui();
 
			
end

local function AddButton(tt, im, f, x, y)
	local newButt = {
		ToolTip = tt,
		Image = eng.Textures["textures/ui/"..im..".png"],
		Func = f,
		PosX = x,
		PosY = y
	}
	table.insert(Editor.Interfaces.BarButtons, newButt);
end

local function closeEditor()
	if( Editor.MapCanvas ) then
		-- Save dialog with true exit.
			print("HERE")
		return
	end
	clientcommand.Check("editor_close");
end

function Editor:SaveDialog()
	local inter = self.Interfaces or {}
	inter.Save = panel.CreateTitleFrame("Save Map", true, ScrW()/2 - 200, ScrH()/2-50, 400, 100)
	
	inter.SaveText = panel.Create("TextEntry", inter.Save)
	inter.SaveText:SetPos(5, 50)
	inter.SaveText:SetSize(390, 20)
	
	inter.SaveLabel = panel.Create("TextLabel", inter.Save)
	inter.SaveLabel:SetPos(5, 30)
	inter.SaveLabel:SetSize(390, 20)
	inter.SaveLabel:SetText("Map Name:");
	
	inter.SaveButton = panel.Create("Button", inter.Save)
	inter.SaveButton:SetPos(5, 75)
	inter.SaveButton:SetSize(193, 20)
	inter.SaveButton:SetText("Save Map")
	inter.SaveButton.Func = function()
		if( inter.SaveText.Text == "" ) then
			return;
		end
		Editor.Map.Name = inter.SaveText.Text;
		Editor:SaveMap();
		panel.Remove(inter.Save)
		inter.Save = nil;
	end
	
	inter.CancelButton = panel.Create("Button", inter.Save)
	inter.CancelButton:SetPos(202, 75)
	inter.CancelButton:SetSize(193, 20)
	inter.CancelButton:SetText("Cancel Save")
	inter.CancelButton.Func = function()
		panel.Remove(inter.Save)
		inter.Save = nil;
	end
	
	inter.Save:SetLive(true);
end
	
function Editor:SaveMap()
	if( not self.MapCanvas ) then
		return
	end
	self.Map.Canvas = self.MapCanvas:ExportData();
	if( not love.filesystem.isDirectory("maps_save") ) then
		love.filesystem.mkdir("maps_save");
	end
	if( not self.Map.Name or (self.Map.Name and self.Map.Name == "Untitiled") ) then
		return self:SaveDialog();
	end
	love.filesystem.write("maps_save/"..self.Map.Name..".dmf", json.encode(self.Map));
end

function Editor:ClearMap()
	if( self.MapCanvas ) then
		self.MapCanvas.Blocks = {}
		self.MapCanvas:CreateBlocks();
	end
end

function Editor:LoadMap(strMap)
	if( love.filesystem.isDirectory("maps_save") ) then
		if( love.filesystem.exists("maps_save/"..strMap) ) then
			local mapCan = json.decode(love.filesystem.read("maps_save/"..strMap));
			Editor.MapCanvas = Map(0, 0);
			Editor.MapCanvas:ImportData(mapCan.Canvas);
		end
	end
end
			
		

function Editor:LoadDialog()
	local inter = self.Interfaces or {}
	inter.Load = panel.CreateTitleFrame("Load Map", true, ScrW()/2 - 200, ScrH()/2 - 95, 400, 190);
	
	inter.ScrollLoad = panel.Create("ScrollFrame", inter.Load)
	inter.ScrollLoad:SetPos(5, 30)
	inter.ScrollLoad:SetSize(390, 130)
	inter.ScrollLoad:EnableVerticalScrollbar(true);
	
	inter.LoadButton = panel.Create("Button", inter.Load)
	inter.LoadButton:SetPos(5, 165)
	inter.LoadButton:SetSize(193, 20)
	inter.LoadButton:SetText("Load Map");
	
	inter.CancelButtonL = panel.Create("Button", inter.Load)
	inter.CancelButtonL:SetPos(202, 165)
	inter.CancelButtonL:SetSize(193, 20)
	inter.CancelButtonL:SetText("Cancel Load");
	inter.CancelButtonL.Func = function()
		panel.Remove(inter.Load)
		inter.Load = nil;
	end
	
	inter.Load:SetLive(true);
end

function Editor:AddBarButtons()
	AddButton("CloseEditor", "close", closeEditor, ScrW() - 20, 2);
	AddButton("ToggleGrid", "grid", function() if( Editor.MapCanvas ) then Editor.MapCanvas:ToggleGrid() end end, 2, 2);
	AddButton("NewMap", "newmap", function() Editor:CreateNewMap() end, 20, 2); 
	AddButton("ClearMap", "clearmap", function() Editor:ClearMap() end, 40, 2);
	AddButton("SaveMap", "save", function() Editor:SaveMap() end, 60, 2);
	AddButton("LoadMap", "load", function() Editor:LoadDialog() end, 80, 2);--
	AddButton("EntityLayer", "entity", function() Editor:EntityLayer() end, 100, 2);--
	AddButton("EnvirontmentLayer", "environment", function() Editor:EnvironmentLayer() end, 120, 2);--
	AddButton("CollisionLayer", "collision", function() Editor:CollisionLayer() end, 140, 2);--
	AddButton("Redo", "rotpos", function() Editor:Redo() end, 160, 2);--
	AddButton("Undo", "rotneg", function() Editor:Undo() end, 180, 2);--
	AddButton("TextureSelector", "tilesel", function() Editor:CreateTextureSelector() end, 200, 2);--
	AddButton("EntitySelector", "texsel", function() Editor:CreateEntitySelector() end, 220, 2);--
	AddButton("OriginalLayout", "layout", function() --[[ origlayer]] end, 240, 2);--
end


function Editor:CreateGui()
	local inter = self.Interfaces or {}
	inter.MainBar = panel.Create("Frame")
	inter.MainBar:SetPos(0, 0)
	inter.MainBar:SetSize(ScrW(), 22)
	
	self:AddBarButtons()
	
	for k,v in pairs(inter.BarButtons) do
		local newButton = panel.Create("ImageButton", inter.MainBar);
		newButton:SetPos(v.PosX, v.PosY)
		newButton:SetSize(18, 18)
		newButton:SetImage(v.Image)
		newButton:SetToolTip(v.ToolTip)
		newButton.Func = function()
			v:Func()
		end
	end
	
	
	inter.MainBar:SetLive(true);
end

function Editor:GenerateTerrain(seed, x, y, size)
	local mCanvas = Map(x, y);
	self.Map.Blocks = {}
	local size = size or 16;
	mCanvas:SetBlockSize(size);
	self.Interfaces.Prog = panel.Create("Frame")
	self.Interfaces.Prog:SetPos(ScrW()/2 - 200, ScrH()/2 - 15);
	self.Interfaces.Prog:SetSize(400, 30);
	
	self.Interfaces.BarP = panel.Create("Progress", self.Interfaces.Prog);
	self.Interfaces.BarP:SetPos(5, 5)
	self.Interfaces.BarP:SetSize(390, 20)
	self.Interfaces.BarP:SetMax(x*y);
	self.Interfaces.BarP:AddText("GeneratingTerrain");
	
	self.Interfaces.Prog:SetLive(true)
	
	local newBlock, noise
	for i = 1+seed, y+seed do
		for j = 1+seed, x+seed do
			newBlock = Block(j - seed, i - seed, mCanvas);
			newBlock:SetSize(size)
			newBlock.defTexture = eng.Textures["textures/ground/grass_light"..size..".png"];
			noise = simplex.Simplex2D(j/x, i/y);
			if( noise < -0.45 ) then
				newBlock.Color = Color(0, 0, 180, 255);
			elseif( noise < -0.42 ) then
				newBlock.defTexture = eng.Textures["textures/ground/sand".. size ..".png"];
			elseif( noise > 0.2 ) then
				newBlock.Color = Color(130, 130, 130, 255);
			end
			table.insert(mCanvas.Blocks, newBlock);
			self.Interfaces.BarP:Add()
		end
	end
	if( self.Interfaces.Prog ) then
		panel.Remove(self.Interfaces.Prog)
		self.Interfaces.Prog = nil;
		self.Interfaces.BarP = nil;
	end
	Editor.MapCanvas = mCanvas;
end
clientcommand.Create("genterr", function(...)
	Editor:GenerateTerrain( unpack({...}) );
end)

local function rop2(n)
	if( n < 32 ) then
		return ( 32 - n < 8 and 32 ) or 16;
	else
		return ( 64 - n < 16 and 64 ) or 32;
	end
end

function Editor:CreateNewMap()
	local selTex = eng.Textures["textures/ground/grass_light32.png"];
	local selTexture = eng.Textures["textures/ground/grass_light16.png"];
	local Inter = self.Interfaces or {};
	Inter.NewMap = panel.CreateTitleFrame("Create New Map", true, ScrW()/2 - 150, ScrH()/2 - 75, 300, 150);
	
	Inter.NewMap.NameLabel = panel.Create("TextLabel", Inter.NewMap)
	Inter.NewMap.NameLabel:SetPos(5, 35)
	Inter.NewMap.NameLabel:SetSize(150, 25);
	Inter.NewMap.NameLabel:SetText("Map Name: ");
	
	Inter.NewMap.TextEntry = panel.Create("TextEntry", Inter.NewMap)
	Inter.NewMap.TextEntry:SetPos(5, 50)
	Inter.NewMap.TextEntry:SetSize(150, 20);
	
	Inter.NewMap.TextureLabel = panel.Create("TextLabel", Inter.NewMap)
	Inter.NewMap.TextureLabel:SetPos(5, 75);
	Inter.NewMap.TextureLabel:SetSize(150, 20);
	Inter.NewMap.TextureLabel:SetText("Default Texture");
	
	Inter.NewMap.TextureButtGrass = panel.Create("ImageButton", Inter.NewMap)
	Inter.NewMap.TextureButtGrass:SetPos(5, 93);
	Inter.NewMap.TextureButtGrass:SetSize(20, 20);
	Inter.NewMap.TextureButtGrass:SetImage(eng.Textures["textures/ground/grass_light16.png"]);
	Inter.NewMap.TextureButtGrass:SetToolTip("Grass");
	Inter.NewMap.TextureButtGrass.Func = function(bt)
		selTex = eng.Textures["textures/ground/grass_light32.png"];
		selTexture = eng.Textures["textures/ground/grass_light"..rop2(Inter.NewMap.SliderS:GetValue())..".png"];
	end
	
	Inter.NewMap.TextureButtDirt = panel.Create("ImageButton", Inter.NewMap)
	Inter.NewMap.TextureButtDirt:SetPos(28, 93);
	Inter.NewMap.TextureButtDirt:SetSize(20, 20);
	Inter.NewMap.TextureButtDirt:SetImage(eng.Textures["textures/ground/dirt16.png"]);
	Inter.NewMap.TextureButtDirt:SetToolTip("Dirt");
	Inter.NewMap.TextureButtDirt.Func = function(bt)
		selTex = eng.Textures["textures/ground/dirt32.png"];
		selTexture = eng.Textures["textures/ground/dirt"..rop2(Inter.NewMap.SliderS:GetValue())..".png"];
	end
	
	Inter.NewMap.TextureButtDirtL = panel.Create("ImageButton", Inter.NewMap)
	Inter.NewMap.TextureButtDirtL:SetPos(51, 93);
	Inter.NewMap.TextureButtDirtL:SetSize(20, 20);
	Inter.NewMap.TextureButtDirtL:SetImage(eng.Textures["textures/ground/dirt_light16.png"]);
	Inter.NewMap.TextureButtDirtL:SetToolTip("Dirt Light");
	Inter.NewMap.TextureButtDirtL.Func = function(bt)
		selTex = eng.Textures["textures/ground/dirt_light32.png"];
		selTexture = eng.Textures["textures/ground/dirt_light"..rop2(Inter.NewMap.SliderS:GetValue())..".png"];
	end
	
	Inter.NewMap.TextureButtSand = panel.Create("ImageButton", Inter.NewMap)
	Inter.NewMap.TextureButtSand:SetPos(74, 93);
	Inter.NewMap.TextureButtSand:SetSize(20, 20);
	Inter.NewMap.TextureButtSand:SetImage(eng.Textures["textures/ground/sand16.png"]);
	Inter.NewMap.TextureButtSand:SetToolTip("Sand");
	Inter.NewMap.TextureButtSand.Func = function(bt)
		selTex = eng.Textures["textures/ground/sand32.png"];
		selTexture = eng.Textures["textures/ground/sand"..rop2(Inter.NewMap.SliderS:GetValue())..".png"];
	end
	
	Inter.NewMap.TextureSelButt = panel.Create("ImageButton", Inter.NewMap);
	Inter.NewMap.TextureSelButt:SetPos(97, 113 - 36)
	Inter.NewMap.TextureSelButt:SetSize(36, 36);
	Inter.NewMap.TextureSelButt:SetImage(selTex);
	Inter.NewMap.TextureSelButt:SetToolTip("Selected");
	Inter.NewMap.TextureSelButt.Think = function(bt)
		bt:SetImage(selTex);
	end
	
	Inter.NewMap.SliderXLab = panel.Create("TextLabel", Inter.NewMap)
	Inter.NewMap.SliderXLab:SetPos(165, 35);
	Inter.NewMap.SliderXLab:SetSize(115, 25);
	Inter.NewMap.SliderXLab:SetText("Size X");
	
	Inter.NewMap.SliderX = panel.Create("Slider", Inter.NewMap)
	Inter.NewMap.SliderX:SetPos(165, 50);
	Inter.NewMap.SliderX:SetSize(115, 20);
	Inter.NewMap.SliderX:SetMin(16);
	Inter.NewMap.SliderX:SetMax(128);
	Inter.NewMap.SliderX:MakeParts();
	
	Inter.NewMap.SliderYLab = panel.Create("TextLabel", Inter.NewMap)
	Inter.NewMap.SliderYLab:SetPos(165, 75);
	Inter.NewMap.SliderYLab:SetSize(115, 25);
	Inter.NewMap.SliderYLab:SetText("Size Y");
	
	Inter.NewMap.SliderY = panel.Create("Slider", Inter.NewMap)
	Inter.NewMap.SliderY:SetPos(165, 90);
	Inter.NewMap.SliderY:SetSize(115, 20);
	Inter.NewMap.SliderY:SetMin(16);
	Inter.NewMap.SliderY:SetMax(128);
	Inter.NewMap.SliderY:MakeParts();
	
	Inter.NewMap.SizeLab = panel.Create("TextLabel", Inter.NewMap)
	Inter.NewMap.SizeLab:SetPos(165, 110);
	Inter.NewMap.SizeLab:SetSize(115, 25);
	Inter.NewMap.SizeLab:SetText("Block Size");
	
	Inter.NewMap.SliderS = panel.Create("Slider", Inter.NewMap)
	Inter.NewMap.SliderS:SetPos(165, 125);
	Inter.NewMap.SliderS:SetSize(115, 20);
	Inter.NewMap.SliderS:SetMin(16);
	Inter.NewMap.SliderS:SetMax(64);
	Inter.NewMap.SliderS:MakeParts();
	
	Inter.NewMap.CreateB = panel.Create("Button", Inter.NewMap)
	Inter.NewMap.CreateB:SetPos(5, 125);
	Inter.NewMap.CreateB:SetSize(71, 20);
	Inter.NewMap.CreateB:SetText("Create");
	Inter.NewMap.CreateB.Func = function(btn)
		if( Editor.MapCanvas and Editor.MapCanvas.Blocks[1] ) then
			return Editor:SaveMap()
		end
		Editor.MapCanvas = Map(Inter.NewMap.SliderX:GetValue(), Inter.NewMap.SliderY:GetValue());
		Editor.MapCanvas:SetBlockSize(rop2(Inter.NewMap.SliderS:GetValue()));
		Editor.MapCanvas.DefaultTexture = selTexture;
		Editor.MapCanvas:CreateBlocks()
		panel.Remove(Inter.NewMap)
		Inter.NewMap = nil;
	end
	
	Inter.NewMap.CancelB = panel.Create("Button", Inter.NewMap)
	Inter.NewMap.CancelB:SetPos(79, 125);
	Inter.NewMap.CancelB:SetSize(71, 20);
	Inter.NewMap.CancelB:SetText("Cancel");
	Inter.NewMap.CancelB.Func = function(btn)
		panel.Remove(Inter.NewMap);
		Inter.NewMap = nil;
	end
	
	Inter.NewMap:SetLive(true);
end
clientcommand.Create("newmap", function() Editor:CreateNewMap() end)

local kd = gui.key.IsDown;
local mX, mY = 0, 0;
function Editor:Think()
	if( not self.MapCanvas ) then return end;
	mX, mY = gui.MousePos()
	self.MouseOver = self.MapCanvas:GetNearestBlock(mX, mY);
	if( kd("up") ) then
		self.MapCanvas:Move(0, self.MapCanvas.BlockSize);
	elseif( kd("right") ) then
		self.MapCanvas:Move(-self.MapCanvas.BlockSize, 0);
	elseif( kd("down") ) then
		self.MapCanvas:Move(0, -self.MapCanvas.BlockSize);
	elseif( kd("left") ) then
		self.MapCanvas:Move(self.MapCanvas.BlockSize, 0);
	end
end

function Editor:ScreenDraw()
	if( not self.MapCanvas ) then return end;
	Editor.MapCanvas:Paint();
	if( self.MouseOver ) then
		surface.SetColor(Color(100, 100, 255, 100));
		surface.DrawRect(self.MapCanvas.Pos.x+(self.MapCanvas.BlockSize*self.MouseOver.Pos.x), self.MapCanvas.Pos.y+(self.MapCanvas.BlockSize*self.MouseOver.Pos.y), self.MapCanvas.BlockSize, self.MapCanvas.BlockSize);
	end
end

function Editor:Shutdown()
	self.MapCanvas = nil;
	for k,v in pairs(self.Interfaces) do
		if( getmetatable(self.Interfaces[k]) == _R.Panel ) then
			panel.Remove(v);
		end
		self.Interfaces[k] = nil;
	end
	self.Interfaces = nil;
	self.Map = nil;
end

return Editor;



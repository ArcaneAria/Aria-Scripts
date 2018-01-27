---------------------------
-- Jurassic Park Ocean Explorer by ArcaneAria --
--
-- Requires table.save-1.0.lua to be in the same directory!
--
-- Creates a visual overlay of the map when you jump off the Ship and run
-- into the ocean. Newly explored tiles will automatically show up as white.
-- The red square is the player.
--
-- Press L to save the map to a file. This will automatically happen
-- every 10 new tiles.
--
-- Press R to place a black tile, which signifies a wall.
--
-- Press Y to place a green tile, which signifies a trap (electric or vine).
--
-- The ocean map resembles map on the West end of the park, except you're
-- jumping into the trees.
--
-- Ocean map data is saved in oceanMap.lua.
---------------------------

local xPosAddr = 0x002476
local yPosAddr = 0x002C4A
local x
local y

local startX = 4000
local startY = 1000

local mapSize = 225
local stepSize = 16
local screenWidth = 510
local screenHeight = 445

local oceanMap
--local tileMap
local tileMapSize = 21
local tileWidth = screenWidth / tileMapSize
local tileHeight = screenHeight / tileMapSize

local filename = "oceanMap.lua"
local saveOffset = 10
local prevJoypad

dofile( "table.save-1.0.lua" )

memory.usememorydomain("WRAM")

local function saveTable()
	assert(table.save(oceanMap, "oceanMap.lua") == nil )
end

local function initializeOceanMap()
	local savedMap, err = table.load(filename)
	
	if not err == nil then
		console.log("Creating new table")
		oceanMap = {}
		for i = 1, mapSize do
			oceanMap[i] = {}
			for j = 1, mapSize do
				oceanMap[i][j] = "X"
			end
		end
	else
		oceanMap = savedMap
	end
end

local function drawTile(xIndex, yIndex, color)
	local x = tileWidth * xIndex
	local y = tileHeight * yIndex
	if (xIndex == 11 and yIndex == 11) then
		color = "red"
	end
	gui.drawBox(x, y, x + tileWidth, y + tileHeight, color, color)
end

local function drawTiles(xIndex, yIndex)

	--tileMap = {}
	for i = 1, tileMapSize do
		--tileMap[i] = {}
		for j = 1, tileMapSize do
			local x = xIndex - (11 - i)
			local y = yIndex - (11 - j)
			
			if (x > 0 and x < mapSize and y > 0 and y < mapSize) then
				if (oceanMap[x][y] == "_") then
					drawTile(i, j, "white")
				elseif (oceanMap[x][y] == "T") then
					drawTile(i, j, "green")
				elseif (oceanMap[x][y] == "W") then
					drawTile(i, j, "black")
				end
			end
		end
	end

end

local function getCurrentPosition()
	x = memory.read_u16_le(xPosAddr)
	y = memory.read_u16_le(yPosAddr)
	
	xIndex = math.floor((x - startX) / stepSize)
	yIndex = math.floor((y - startY) / stepSize)
	
	-- Check to see that we're in bounds of our map
	if (xIndex < 0 or xIndex > mapSize) then
		console.log("xIndex out of bounds at " .. xIndex)
	elseif (yIndex < 0 or yIndex > mapSize) then
		console.log("yIndex out of bounds at " .. yIndex)
	-- If we are pressing the X button, mark this tile
	elseif (joypad.get()["P1 X"] and not prevJoypad["P1 X"]) then
		-- Toggle between trap and explored tiles on press
		if (oceanMap[xIndex][yIndex] == "_") then
			oceanMap[xIndex][yIndex] = "T"
		else
			oceanMap[xIndex][yIndex] = "_"
		end
		
	elseif (joypad.get()["P1 R"] and not prevJoypad["P1 R"]) then
		-- Toggle between wall and explored tiles on press
		if (oceanMap[xIndex][yIndex] == "_") then
			oceanMap[xIndex][yIndex] = "W"
		else
			oceanMap[xIndex][yIndex] = "_"
		end
		
	-- Otherwise, set this tile to explored
	elseif (oceanMap[xIndex][yIndex] == "X") then
		console.log("New value - (" .. xIndex .. ", " .. yIndex .. ")")
		oceanMap[xIndex][yIndex] = "_"
		
		-- Save the table to a file
		saveOffset = saveOffset - 1
		if (saveOffset <= 0) then
			saveTable()
			saveOffset = 10
		end
	end
	
	-- Now draw the updated map
	drawTiles(xIndex, yIndex)
end

local function outputOceanMap()
	console.log("Exporting map")
	file = io.open("ocean.txt", "w")
	for i = 1, mapSize do
		for j = 1, mapSize do
			file:write(oceanMap[j][i])
		end
		file:write("\n")
	end
	file:close()
end

local function drawRectangle()
	--gui.drawBox(0, 0, screenWidth, screenHeight)
	--gui.drawBox(15, 33, 502, 415)
end

initializeOceanMap()
prevJoypad = joypad.get()
while true do
	getCurrentPosition()
	if (joypad.get()["P1 L"] and not prevJoypad["P1 L"]) then
		outputOceanMap()
		saveTable()
	end
	drawRectangle()
	prevJoypad = joypad.get()
	emu.frameadvance()
end
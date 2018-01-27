------------------------------------------------------------------------------
-- Jurassic Park Water Test Script by ArcaneAria
--
-- This script moves Grant around (xMin,yMin) to (xMax,yMax) checking for a 
-- respawn. This was to search water areas that were glitched as walkable tiles,
-- such as North of the ship gear on v1.0 carts.
------------------------------------------------------------------------------

-- Top left of North river (1595, 0)
-- Bottom right of North river (1772,1001)
local xPosAddr = 0x002476
local yPosAddr = 0x002C4A
local xMin = 3643
local xMax = 4096
local yMin = 2586
local yMax = 3250
local xWidth = (xMax - xMin) / 4
local yWidth = (yMax - yMin) / 4
local tileSize = 4

memory.usememorydomain("WRAM")

local function advanceFrame(count)
	for i = 1, count do
		emu.frameadvance()
	end
end

local function createMap()
	
	map = {}
	for x = 1, xWidth do
		map[x] = {}
		for y = 1, yWidth do
			map[x][y] = "."
		end
	end
end

local function outputMap()
	console.log("Exporting map")
	file = io.open("oceanBoxMap.txt", "w")
	for j = 1, yWidth do
			for i = 1, xWidth do
			file:write(map[i][j])
		end
		file:write("\n")
	end
	file:close()
end

createMap()

for y = 1, yWidth do
	for x = 1, xWidth do
		savestate.loadslot(1)
		console.log("Processing (" .. (x * tileSize + xMin) .. ", " .. (y * tileSize + yMin) .. ")")
		memory.write_u16_le(xPosAddr, xMin + x * tileSize)
		memory.write_u16_le(yPosAddr, yMin + y * tileSize)
		advanceFrame(200)
		
		local currX = memory.read_u16_le(xPosAddr)
		local currY = memory.read_u16_le(yPosAddr)
		
		if (currX ~= 2053 or currY ~= 2341) then
			map[x][y] = "X";
		end
	end
	outputMap()
end
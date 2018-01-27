---------------------------
-- Jurassic Park Overworld Map Maker by ArcaneAria --
--
-- This script moves Grant along the screen, taking screenshots every xWidth
-- pixels. I combined the results of these into a large entire world map.
-- Each run of this program only does 1 row at a time, so you need to update
-- current row. 
---------------------------

local xPosAddr = 0x002476
local yPosAddr = 0x002C4A

local xWidth = 246
local yWidth = 191

local xStart = 112
local yStart = 88
local currentRow = 20

memory.usememorydomain("WRAM")

local function setup()
	snes.setlayer_bg_3(false)
	snes.setlayer_obj_3(false)
	snes.setlayer_obj_4(false)
end

local function cleanUp()
	snes.setlayer_obj_4(true)
	snes.setlayer_obj_3(true)
	snes.setlayer_bg_3(true)
end

local function processMap()
	for x = 2, 4096 do
		memory.write_u16_le(xPosAddr, x)
		memory.write_u16_le(yPosAddr, yStart + (yWidth * currentRow))
		if (x % xWidth == xStart) then
			client.screenshot()
		end
		emu.frameadvance();
	end
end

setup()
processMap()
cleanUp()
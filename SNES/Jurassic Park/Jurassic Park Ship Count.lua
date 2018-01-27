------------------------------------------------------------------------------
-- Jurassic Park Ship Counter by ArcaneAria
--
-- For V1.0 carts. Dinosaurs that appear on the ship can also appear in other
-- sections of the game. This script scans the memory addresses for the ship
-- dinosaurs and informs you when one has died.
--
-- This helped me find that there is 1 ship dino in Nublar, 3 in North, and
-- a handful in the Raptor Nest.
--
-- Other dinosaurs share values in other sections, so this could be tweaked
-- for trying to find when a certain dinosaur is killed elsewhere. The basement
-- of the Visitor Center has a lot of dinos like this.
------------------------------------------------------------------------------

local ship = {}
ship["F1"] = {0x001B84, 0x001B86, 0x001B88, 0x001B8A, 0x001B8C, 0x001B8E, 0x001B90, 0x001B92, 0x001B94, 
	0x001B96, 0x001B98, 0x001B9A, 0x001B9C, 0x001B9E, 0x001BA0, 0x001BA2, 0x001BA4, 0x001BA6, 0x001BA8}
	
ship["B1"] = {0x001D24, 0x001D28, 0x001D2C, 0x001D30, 0x001D32, 0x001D34, 0x001D38, 0x001D40, 0x001D3C, 
	0x001D44}

ship["B2"] = {0x001D44, 0x001D48, 0x001D4C, 0x001D50, 0x001D54, 0x001D58, 0x001D5C, 0x001D5E, 0x001D62,
	0x001D64, 0x001D66, 0x001D68, 0x001D6C, 0x001D70, 0x001D74}
	
ship["B3"] = {0x001D64, 0x001D66, 0x001D6A, 0x001D6E, 0x001D72, 0x001D74, 0x001D76, 0x001D7A, 0x001D7E, 
	0x001D82, 0x001D86, 0x001D88, 0x001D8A, 0x001D8E, 0x001D92, 0x001D94, 0x001D96, 0x001D98, 0x001D9C, 
	0x001DA0, 0x001DA4}
	
ship["B4"] = {0x001D84, 0x001D88, 0x001D8C, 0x001D90, 0x001D94, 0x001D98, 0x001D9A, 0x001D9C, 0x001D9E,
	0x001DA2, 0x001DA4, 0x001DA6, 0x001DA8, 0x001DAA, 0x001DAE, 0x001DB0, 0x001DB2, 0x001DB4, 0x001DB8,
	0x001DBC, 0x001DBE, 0x001DC2, 0x001DC4, 0x001DC6, 0x001DCA, 0x001DCC, 0x001DCE, 0x001DD2, 0x001DD4,
	0x001DD8, 0x001DDA}

memory.usememorydomain("WRAM")

local function getColor(offset)
	if (offset / 16) % 2 == 0 then
		return "red"
	else
		return "white"
	end
end

local function checkFloors()
	local offset = 0
	for floorName,addresses in pairs(ship) do
		local floorCount = 0
		for x = 1, #addresses do
			local status = memory.read_u16_le(addresses[x])
			memory.write_u16_le(addresses[x], 0xFFFF)
			if status > 0 then
				floorCount = floorCount + 1
			end
		end
		gui.text(900, offset, "Floor: " .. floorName .. ", Killed: " .. floorCount, getColor(offset))
		offset = offset + 16
	end
end

while true do
	checkFloors()
	emu.frameadvance()
end
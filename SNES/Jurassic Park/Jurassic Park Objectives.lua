---------------------------
-- Jurassic Park Objective Tracker by ArcaneAria --
-- This is an unfinished script that will look for objective flags
-- in memory and show a message on screen if a flag got flipped.
-- 
-- This would be useful for learning if a flag triggers early due to a glitch,
-- such as deploying the nerve gas by line of sight instead of touching them.
--
-- These values are currently using v1.1(Rev A) cart values.
---------------------------

local objectives = {}
objectives["Generator is on"] = 0x00026B
objectives["Mainland comms is ready"] = 0x000274
objectives["Mainland comms activated"] = 0x000275

memory.usememorydomain("WRAM")

local function checkObjectiveStatus()
	local offset = 0
	for key,value in pairs(objectives) do
		local status = memory.read_u16_le(value)
		if status > 0 then
			color = "red"
			gui.text(900, offset, key, color)
			offset = offset + 16
		end
	end
end

while true do
	checkObjectiveStatus()
	emu.frameadvance()
end
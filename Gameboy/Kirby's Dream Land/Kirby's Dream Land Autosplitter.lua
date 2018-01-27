-------------------------------------------------------------------------
-- Kirby's Dream Land autosplitter by ArcaneAria
-- Note: LiveSplitUtils.lua must be in the same directory as this file!
--
-- Timer starts when Start is pressed on the main menu.
-- Timer splits after each stage boss, but not during the boss rush.
-- Timer finishes on last hit on Dedede.
-------------------------------------------------------------------------

game_running = false
bosses_defeated = 0
in_boss_fight = false
lives_previous_frame = 0

lives_address = 0x1089
boss_health_address = 0x1093

memory.usememorydomain("WRAM")
local LiveSplitUtils = require("LiveSplitUtils")

-- If we haven't started yet and our lives become 5,
-- then we've hit the start button
local function check_for_start()
	local lives = memory.readbyte(lives_address)
	if lives == 5 then
		lives_previous_frame = lives
		LiveSplitUtils.start_timer()
		game_running = true
	end
end

-- Check boss statuses and split if necessary
local function check_bosses()
	local boss_health = memory.readbyte(boss_health_address)
	local lives = memory.readbyte(lives_address)

	if in_boss_fight then
		-- If the player died, reset the boss flag
		if lives_previous_frame > lives then
			in_boss_fight = false

		-- If the boss dies, split and reset the boss flag
		elseif boss_health == 0 then
			LiveSplitUtils.split()
			in_boss_fight = false
			bosses_defeated = bosses_defeated + 1
		end
		
	-- If we're not in a boss fight and are still on the first
	-- 4 bosses, then check to see if a boss spawns.
	-- We check for 4 bosses to avoid splitting on the boss rush.
	elseif bosses_defeated < 4 then
	
		-- Minibosses have 3 health, so ignore them
		if boss_health > 3 then
			in_boss_fight = true
		end
	
	-- Dedede is the only boss with 10 health, so we
	-- know we're at the final boss if this happens
	elseif boss_health == 10 then
		in_boss_fight = true
	end
	
	lives_previous_frame = lives
	
end

LiveSplitUtils:setup()

while true do
	if not game_running then
		check_for_start()
	else
		check_bosses()
	end
	
	emu.frameadvance()
end

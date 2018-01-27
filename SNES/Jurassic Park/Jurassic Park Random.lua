----------------------------------------------------------------------
-- Button Randomizer by ArcaneAria
--
-- Slaps the controller really quickly except for the Start button
-- Turn on infinite life and ammo and just let the game have function
-- trying to glitch into something.
--
-- It's not very useful, but fun to watch
----------------------------------------------------------------------

buttonNames = {"A", "B", "X", "Y", "Up", "Left", "Right", "Select", "L", "R"}
controller = {}

local function randomizeButtons()
	for x = 1, #buttonNames do
		controller["P1 " .. buttonNames[x]] = (math.random() >= 0.5);
	end
	joypad.set(controller)
end

while true do
	randomizeButtons()
	emu.frameadvance()
end
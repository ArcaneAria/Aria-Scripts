# Kirby's Dream Land autosplitter for BizHawk

This autosplitter will automatically start when you press Start on the main menu. Then, it will split upon boss death
on the stages bosses, not during the boss rush. Finally, it will finish on the last hit on Dedede.

This has been tested on normal mode, but it should work on extra mode.

The RAM values are from the USA, Europe version of the game. I haven't verified this with the Japanese versions, but all you would need to change are Kirby's health and the boss health addresses.

# Directions
* Open LiveSplit.
* Open up BizHawk and load up Kirby's Dream Land.
* Navigate to Tools -> Lua Console.
* Go to Script -> Open Script. Find "Kirby's Dream Land Autosplitter.lua" and open it.
* The 'Output' console should say "Connected to LiveSplit successfully!"
  * If it says "Failed to connect to LiveSplit," verify LiveSplit is open and try again.
* Clicking on the script should show something like "1 script (1 active, 0 paused)." You're good to go if the script is active!

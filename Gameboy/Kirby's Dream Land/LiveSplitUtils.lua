-----------------------------------------------------------------
-- LiveSplitUtils by ArcaneAria
-- 
-- LiveSplit utility file that handles connecting to LiveSplit
-- and sending commands.
-----------------------------------------------------------------

local LiveSplitUtils = {}

local connection

function LiveSplitUtils.setup()
	connection = io.open("//./pipe/LiveSplit", 'a')
	
	if not connection then
		error("\nFailed to open LiveSplit named pipe!\n" ..
			"Please make sure LiveSplit is running and reload the script.")
	end
	
	connection:write("reset\r\n")
	connection:flush()
	
	console.log("Connected to LiveSplit successfully!")
end

function LiveSplitUtils.start_timer()
	connection:write("starttimer\r\n")
	connection:flush()
	console.log("Starting timer!")
end

function LiveSplitUtils.split()
	connection:write("split\r\n")
	connection:flush()
	console.log("Split!")
end

return LiveSplitUtils

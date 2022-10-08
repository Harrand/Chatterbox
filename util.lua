local addon_name, chatter = ...
-- API Setup
chatter.util = {}
chatter.util.impl = {}

-- COLOUR FUNCTIONALITY
chatter.util.colour = function(colourcode)
	if colourcode == nil then
		return "|r"
	end
	-- colourcode is gonna be RRGGBB
	-- color escape codes are AARRGGBB
	local argb = "00" .. colourcode
	return "|c" .. argb
end

-- DELAY FUNCTIONALITY
-- Frame used for delay function specifically.
chatter.util.impl.delay_frame = CreateFrame("Frame")
-- Time when the delay function should execute.
chatter.util.impl.delay_time = 0
-- 1 if we're waiting on a delay, otherwise 0
chatter.util.impl.delay_latch = 0
-- Function to execute when delay completes
chatter.util.impl.delay_event = nil
-- This should never change. Contains implementation for checking if time has passed.
chatter.util.impl.delay_function = function()
	if time() >= chatter.util.impl.delay_time and chatter.util.impl.delay_latch == 1 then
		chatter.util.impl.delay_latch = 0
		if chatter.util.impl.delay_event ~= nil then
			chatter.util.impl.delay_event()
		end
		chatter.util.delay_event = nil
	end
end
chatter.util.impl.delay_frame:SetScript("OnUpdate", chatter.util.impl.delay_function)

-- Publically-facing API function
chatter.util.delay = function(millis, func)
	chatter.util.impl.delay_event = func
	chatter.util.impl.delay_time = time() + (millis / 1000.0)
	chatter.util.impl.delay_latch = 1
end

local addon_name, chatter = ...

-- Frame used for delay function specifically.
chatter.delay_frame = CreateFrame("Frame")
chatter.delay_frame:SetScript("OnUpdate", chatter.delay_function)
-- Time when the delay function should execute.
chatter.delay_time = 0
-- 1 if we're waiting on a delay, otherwise 0
chatter.delay_latch = 0
-- Function to execute when delay completes
chatter.delay_event = nil
-- This should never change. Contains implementation for checking if time has passed.
chatter.delay_function = function()
	if time() >= chatter.delay_time and chatter.delay_latch == 1 then
		chatter.delay_latch = 0
		if chatter.delay_event ~= nil then
			chatter.delay_event()
		end
	end
end
chatter.delay_frame:SetScript("OnUpdate", chatter.delay_function)

-- Publically-facing API function
chatter.util = {}
chatter.util.delay = function(millis, func)
	chatter.delay_event = func
	chatter.delay_time = time() + (millis / 1000.0)
	chatter.delay_latch = 1
end

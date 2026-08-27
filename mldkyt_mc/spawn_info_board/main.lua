
local monitor = peripheral.wrap("back")
local w, h = monitor.getSize()

function renderClock()
	local hours = math.floor(os.time())
	local minutes = math.floor((os.time() % 1) * 60)

	if string.len(hours) == 1:
		hours = "0" .. hours
	end
	if string.len(minutes) == 1:
		minutes = "0" .. minutes
	end

	monitor.setCursorPos(w - 5, 1)
	monitor.write(hours .. ":" .. minutes)
end

monitor.setCursorPos(1, 1)
monitor.write("Hello world! This is a test if this works or not. ")

renderClock()

while true do
    os.queueEvent("tick")
    local event, p1, p2, p3, p4, p5 = os.pullEvent()

    if event == "monitor_touch":
    	local side, x, y = p1, p2, p3

    	-- TODO
    end

end

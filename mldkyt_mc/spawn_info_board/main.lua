
local monitor = peripheral.wrap("top")
local w, h = monitor.getSize()

local screen = "main"

function renderClock()
	local hours = math.floor(os.time())
	local minutes = math.floor((os.time() % 1) * 60)

	if string.len(hours) == 1 then
		hours = "0" .. hours
	end
	if string.len(minutes) == 1 then
		minutes = "0" .. minutes
	end

	monitor.setCursorPos(w - 5, 1)
	monitor.write(hours .. ":" .. minutes)
end

function prettyPrint(str)
	i = 0

	for word in str:gmatch("%S+") do
		i = i + string.len(word)

		if i > w then
			local x, y = monitor.getCursorPos()
			monitor.setCursorPos(1, y + 1)
			i = 0
		end

		monitor.write(word .. " ")
	end
end

function draw()
	monitor.clear()

	if screen == "main" then
		monitor.setCursorPos(1, 1)
		prettyPrint("Welcome to mldkyt's Minecraft Server!") 

		monitor.setCursorPos(1, 3)
		prettyPrint("This is a \"semi\" \"vanilla\" Minecraft server. This means that some mods are allowed, and the admins may give out items sometimes.")
	end
end

draw()
renderClock()

while true do
    os.queueEvent("tick")
    local event, p1, p2, p3, p4, p5 = os.pullEvent()

    if event == "monitor_touch" then
    	local side, x, y = p1, p2, p3

    	-- TODO
    end

    if event == "tick" then
    	renderClock()
    end

end

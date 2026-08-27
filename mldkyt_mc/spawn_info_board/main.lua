
monitor = peripheral.wrap("top")
w, h = monitor.getSize()
buttons = {}

screen = "main"

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
		i = i + string.len(word) + 1

		if i > w then
			local x, y = monitor.getCursorPos()
			monitor.setCursorPos(1, y + 1)
			i = 0
		end

		monitor.write(word .. " ")
	end

	local x, y = monitor.getCursorPos()
	monitor.setCursorPos(1, y + 2)
end

function addButton(label, id)
	monitor.write("[" .. label .. "]")
	local x, y = monitor.getCursorPos()
	monitor.setCursorPos(1, y + 1)

	table.insert(buttons, {
		["x"] = x,
		["y"] = y,
		["w"] = string.len(label) + 2,
		["id"] = id
	})
end

function handleButtonClick(id)
	if id == "graves" then
		page = "graves"
	end
	if id == "back" then
		page = "main"
	end
end

function draw()
	monitor.clear()
	monitor.setCursorPos(1, 1)	

	if screen == "main" then
		prettyPrint("Welcome to mldkyt's Minecraft Server!") 
		prettyPrint("This is a \"semi\" \"vanilla\" Minecraft server. This means that some mods are allowed, and the admins may give out items sometimes.")
		addButton("Graves", "graves")
	end
	if screen == "graves" then
		addButton("Back", "back")
		prettyPrint("The graves mod is very self explanatory. When you die, a grave will be placed on your location. Graves are protected from any damage, and can be picked up either by breaking the grave, or shift-right clicking it.")
		prettyPrint("Players also get a grave compass on death to quickly find their death location. All players have 15 minutes to locate and pick up their items before they drop, and then an additional 3 minutes if you consider vanilla item despawns.")
	end
end

draw()
renderClock()

while true do
    os.queueEvent("tick")
    local event, p1, p2, p3, p4, p5 = os.pullEvent()

    if event == "monitor_touch" then
    	local side, x, y = p1, p2, p3

    	for button in pairs(buttons) do
    		if x > button.x and x < button.x + button.w and y == button.y then
    			handleButtonClick(button.id)
    		end
    	end

    	draw()
    end

    if event == "tick" then
    	renderClock()
    end

end

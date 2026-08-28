
buttons = {}

local monitor = peripheral.wrap("back")

function addButton(label, id)
	monitor.write("[" .. label .. "]")
	local x, y = mon1.getCursorPos()

	table.insert(buttons, {
		x = x,
		y = y,
		w = string.len(label) + 2,
	    id = id
	})
end

function handleButtonClick(id)
	if id == "oak" then
		commands.give("@p", "oak_boat", "1")
	end
	if id == "spruce" then
		commands.give("@p", "spruce_boat", "1")
	end
	if id == "birch" then
		commands.give("@p", "birch_boat", "1")
	end
	if id == "cherry" then
		commands.give("@p", "cherry_boat", "1")
	end
end

function draw()
	buttons = {}

	monitor.setCursorPos(1, 1)

	monitor.write("Need a boat?")
	monitor.setCursorPos(2, 3)

	addButton("Oak Boat", "oak")
	monitor.setCursorPos(2, 4)
	addButton("Spruce Boat", "spruce")
	monitor.setCursorPos(2, 5)
	addButton("Birch Boat", "birch")
	monitor.setCursorPos(2, 6)
	addButton("Cherry Boat", "cherry")
end

draw()

while true do
    local event, p1, p2, p3, p4, p5 = os.pullEvent()

    if event == "monitor_touch" then
    	local side, x, y = p1, p2, p3

    	for i, button in pairs(buttons) do
    		if x > button.x - button.w and x < button.x and y == button.y then
    			handleButtonClick(button.id)
    		end
    	end

    	draw()
    end
end

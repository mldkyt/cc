local monitor = peripheral.wrap("back")

w, h = monitor.getSize()
print("size", w, h)

monitor.setTextScale(0.5)

function draw()
	monitor.clear()

	-- Spawn

	monitor.setCursorPos(68, 31)
	monitor.write("S")

	monitor.setCursorPos(68, 32)
	monitor.write("^")

	monitor.setCursorPos(63, 33)
	monitor.write("YOU ARE HERE")

	-- Above spawn, intersection
	monitor.setCursorPos(68, 30)
	monitor.write("|")

	monitor.setCursorPos(68, 29)
	monitor.write("+")

	-- Iron Farm
	monitor.setCursorPos(53, 29)
	monitor.write("+")
	for i = 54, 67 do
		monitor.write("=")
	end

	-- mldkyt's base
	monitor.setCursorPos(69, 29)
	for i = 69, 81 do
		monitor.write("=")
	end
	monitor.write("+")
end

draw()

while true do
    local event, p1, p2, p3, p4, p5 = os.pullEvent()

    if event == "monitor_touch" then
    	local side, x, y = p1, p2, p3

    	print("touch at", x, y)
    end
end

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
end

draw()

while true do
    local event, p1, p2, p3, p4, p5 = os.pullEvent()

    if event == "monitor_touch" then
    	local side, x, y = p1, p2, p3

    	print("touch at", x, y)
    end
end

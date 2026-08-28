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
	monitor.setCursorPos(49, 31)
	monitor.write("IRON FARM")

	-- mldkyt's base
	monitor.setCursorPos(69, 29)
	for i = 69, 81 do
		monitor.write("=")
	end
	monitor.write("+")
	monitor.setCursorPos(76, 31)
	monitor.write("MLDKYT'S BASE")

	-- Next intersection
	for i = 25, 28 do
		monitor.setCursorPos(68, i)
		monitor.write("|")
	end

	monitor.setCursorPos(68, 24)
	monitor.write("+")

	monitor.write("=====+")
	monitor.setCursorPos(69, 26)
	monitor.write("LINA'S BASE")

	monitor.setCursorPos(52, 24)
	monitor.write("+")
	for i = 53, 67 do
		monitor.write("=")
	end

	monitor.setCursorPos(45, 26)
	monitor.write("TRADING CENTER")

	-- Next intersection
	monitor.setCursorPos(68, 23)
	monitor.write("|")
	monitor.setCursorPos(68, 22)
	monitor.write("+")

	-- Minty's base
	monitor.setCursorPos(36, 22)
	monitor.write("+")
	for i = 37, 67 do
		monitor.write("=")
	end
	monitor.setCursorPos(30, 24)
	monitor.write("MINTY'S BASE")

	-- Next intersection
	monitor.setCursorPos(68, 21)
	monitor.write("|")
	monitor.setCursorPos(68, 20)
	monitor.write("|")
	monitor.setCursorPos(68, 19)
	monitor.write("+")

	-- sel's base
	monitor.setCursorPos(37, 19)
	monitor.write("+")
	for i = 38, 67 do
		monitor.write("=")
	end
	monitor.setCursorPos(32, 21)
	monitor.write("SEL'S BASE")

	-- Next intersection
	for i = 4, 18 do
		monitor.setCursorPos(68, i)
		monitor.write("|")
	end
	monitor.setCursorPos(68, 3)
	monitor.write("+")

	-- yuki's base
	monitor.setCursorPos(61, 3)
	monitor.write("+")
	for i = 62, 67 do
		monitor.write("=")
	end
	
	monitor.setCursorPos(56, 5)
	monitor.write("YUKI'S BASE")
end

draw()

while true do
    local event, p1, p2, p3, p4, p5 = os.pullEvent()

    if event == "monitor_touch" then
    	local side, x, y = p1, p2, p3

    	print("touch at", x, y)
    end
end

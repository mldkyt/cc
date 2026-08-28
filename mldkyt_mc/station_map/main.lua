local monitor = peripheral.wrap("back")

w, h = monitor.getSize()
print("size", w, h)

monitor.setTextScale(0.5)

function draw()
	for i = 1, w do
		monitor.setCursorPos(i, 1)
		monitor.write("w")
	end

	for i = 1, h do
		monitor.setCursorPos(w, i)
		monitor.write("h")
	end

end

draw()

while true do
    local event, p1, p2, p3, p4, p5 = os.pullEvent()

    if event == "monitor_touch" then
    	local side, x, y = p1, p2, p3

    	print("touch at", x, y)
    end
end

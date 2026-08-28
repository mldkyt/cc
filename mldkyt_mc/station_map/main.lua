local monitor = peripheral.wrap("back")

w, h = monitor.getSize()
print("size", w, h)

monitor.setTextScale(0.5)

function draw()
end

draw()

while true do
    local event, p1, p2, p3, p4, p5 = os.pullEvent()
end

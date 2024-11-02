
local mon = peripheral.wrap("monitor_1")

local screen = "list"
local selectedDevice = ""

function getRealTime()
    local hour = os.time("utc")
    local minute = hour % 1
    minute = minute * 60

    return string.format("%02d", hour) .. ":" .. string.format("%02d", minute)
end

function getIGT()
    local hour = os.time()
    local minute = hour % 1
    minute = minute * 60

    return string.format("%02d", hour) .. ":" .. string.format("%02d", minute)
end

function getDevices()
    local devices = {}
    for k, v in ipairs(peripheral.getNames()) do
        if v ~= "right" and v ~= "left" and v ~= "top" and v ~= "bottom" and v ~= "back" and v ~= "front" then
            table.insert(devices, v)
        end
    end

    return devices
end

function drawListOfDevices()
    local listOfDevices = getDevices()
    mon.clear()
    mon.setCursorPos(1, 1)
    mon.write("List of devices on this network:")

    mon.setCursorPos(2, 2)
    mon.write("NAME")

    mon.setCursorPos(30, 2)
    mon.write("TYPE")

    for k, v in ipairs(listOfDevices) do
        mon.setCursorPos(2, k + 2)
        mon.write(v)
        mon.setCursorPos(30, k + 2)
        mon.write(peripheral.getType(v))
    end

    local x, y = mon.getSize()

    msg = "IGT " .. getIGT() .. " IRL " .. getRealTime()
    mon.setCursorPos(x - #msg, y)
    mon.write(msg)

end

function drawDeviceInformation()
    mon.clear()
    mon.setCursorPos(1, 1)
    mon.write("<< BACK")

    mon.setCursorPos(1, 2)
    mon.write("Device: " .. selectedDevice)
    mon.setCursorPos(1, 3)
    mon.write(" Type: " .. peripheral.getType(selectedDevice))

    local methods = peripheral.getMethods(selectedDevice)
    mon.setCursorPos(1, 4)
    mon.write("Methods: ")
    for k, v in ipairs(methods) do
        mon.setCursorPos(2, methods[k] + 4)
        mon.write(" - " .. v .. "()")
    end
end

while true do
    os.queueEvent("drawListOfDevices")
    event, p1, p2, p3, p4, p5 = os.pullEvent()

    if event == "monitor_touch" then
        if screen == "list" then
            local devices = getDevices()
            if p2 > 2 and p2 < 30 and p3 > 3 and p3 < #devices + 3 then
                selectedDevice = devices[p3 - 3]
                screen = "device"
            end
        end

        if screen == "device" then
            if p2 > 1 and p2 < 6 and p3 == 1 then
                screen = "list"
            end
        end
    end
    
    if screen == "list" then
        drawListOfDevices()
    end

    if screen == "device" then
        drawDeviceInformation()
    end
end


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
        local methods = peripheral.getMethods(v)
        for _, v in ipairs(methods) do
            if v == "isOn" then
                if peripheral.call(v, "isOn") then
                    mon.setBackgroundColor(colors.green)
                else
                    mon.setBackgroundColor(colors.red)
                end
            end
        end

        mon.setCursorPos(2, k + 2)
        mon.write(v)

        mon.setBackgroundColor(colors.black)
        
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

    mon.setCursorPos(2, 4)
    local perX, perY = peripheral.getSize(selectedDevice)
    local perSize = peripheral.getSize(selectedDevice)
    mon.write("W: " .. perX .. ", H: " .. perY .. ", font size: " .. perSize)

    local methods = peripheral.getMethods(selectedDevice)
    mon.setCursorPos(1, 5)
    mon.write(" Methods: ")

    if peripheral.getType(selectedDevice) == "monitor" then
        mon.setCursorPos(2, 6)
        mon.write("[Clear]")

        mon.setCursorPos(12, 6)
        mon.write("[]")
    elseif peripheral.getType(selectedDevice) == "computer" then

    else
        for k, v in ipairs(methods) do
            mon.setCursorPos(2, k + 4)
            mon.write("  - " .. v .. "()")
        end
    end
end

local lastClock = os.time("utc")

while true do
    os.queueEvent("drawListOfDevices")
    event, p1, p2, p3, p4, p5 = os.pullEvent()

    if event == "monitor_touch" then
        if screen == "list" then
            local devices = getDevices()
            if p2 > 2 and p2 < 30 and p3 > 2 and p3 < #devices + 2 then
                selectedDevice = devices[p3 - 2]
                screen = "device"
            end
        end

        if screen == "device" then
            if p2 > 1 and p2 < 6 and p3 == 1 then
                screen = "list"
            end
        end
    end
    
    if lastClock ~= os.time("utc") then
        if screen == "list" then
            drawListOfDevices()
        end
    
        if screen == "device" then
            drawDeviceInformation()

            if peripheral.getType(selectedDevice) == "monitor" then
                if p2 > 2 and p2 < 9 and p3 == 6 then
                    peripheral.call(selectedDevice, "clear")
                end
            elseif peripheral.getType(selectedDevice) == "computer" then
                
            end
        end

        lastClock = os.time("utc")
    end
end

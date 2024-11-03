
local mon = peripheral.wrap("monitor_1")

local DEBUG = true

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


    if peripheral.getType(selectedDevice) == "monitor" then
        mon.setCursorPos(2, 4)
        local perX, perY = peripheral.call(selectedDevice, "getSize")
        local perSize = peripheral.call(selectedDevice, "getTextScale")
        mon.write("W: " .. perX .. ", H: " .. perY .. ", font size: " .. perSize)
    
        local methods = peripheral.getMethods(selectedDevice)
        mon.setCursorPos(1, 5)
        mon.write(" Methods: ")

        mon.setCursorPos(2, 6)
        mon.write("[Clear]")

        local perXCur, perYCur = peripheral.call(selectedDevice, "getCursorPos")
        local perBlink = peripheral.call(selectedDevice, "getCursorBlink")

        mon.setCursorPos(2, 7)
        mon.write("Cursor: X: [- " .. string.format("%02d", perXCur) ..  " +], Y: [- " .. string.format("%02d", perYCur) .. " +]")

        mon.setCursorPos(2, 8)
        mon.write("[")
        if perBlink then
            mon.setBackgroundColor(colors.green)
        else
            mon.setBackgroundColor(colors.red)
        end
        mon.write(" ")
        mon.setBackgroundColor(colors.black)
        mon.write("] Cursor Blink")
    elseif peripheral.getType(selectedDevice) == "computer" then

    else
        for k, v in ipairs(methods) do
            mon.setCursorPos(2, k + 4)
            mon.write("  - " .. v .. "()")
        end
    end
end

function handleClicking()
    while true do
        event, p1, p2, p3, p4, p5 = os.pullEvent()
    
        if event == "monitor_touch" then
            if DEBUG then
                mon.setCursorPos(p2, p3)
                mon.write("X")
                mon.setCursorPos(p2, p3 + 1)
                mon.write("X="..p2)
                mon.setCursorPos(p2, p3 + 2)
                mon.write("Y="..p3)
            end
    
            if screen == "list" then
                local devices = getDevices()
                if p2 > 2 and p2 < 30 and p3 > 2 and p3 < #devices + 3 then
                    selectedDevice = devices[p3 - 2]
                    screen = "device"
                end
            end
    
            if screen == "device" then
                if p2 > 1 and p2 < 6 and p3 == 1 then
                    screen = "list"
                end
    
                
                if peripheral.getType(selectedDevice) == "monitor" then
                    if p2 > 2 and p2 < 9 and p3 == 6 then
                        peripheral.call(selectedDevice, "clear")
                    end
    
                    if p2 == 14 and p3 == 7 then
                        local perX, perY = peripheral.call(selectedDevice, "getCursorPos")
                        perX = perX - 1
                        peripheral.call(selectedDevice, "setCursorPos", perX, perY)
                    end
    
                    if p2 == 19 and p3 == 7 then
                        local perX, perY = peripheral.call(selectedDevice, "getCursorPos")
                        perX = perX + 1
                        peripheral.call(selectedDevice, "setCursorPos", perX, perY)
                    end
    
                    if p2 == 27 and p3 == 7 then
                        local perX, perY = peripheral.call(selectedDevice, "getCursorPos")
                        perY = perY - 1
                        peripheral.call(selectedDevice, "setCursorPos", perX, perY)
                    end
    
                    if p2 == 32 and p3 == 7 then
                        local perX, perY = peripheral.call(selectedDevice, "getCursorPos")
                        perY = perY + 1
                        peripheral.call(selectedDevice, "setCursorPos", perX, perY)
                    end
    
                    if p2 == 3 and p3 == 8 then
                        local perBlink = not peripheral.call(selectedDevice, "getCursorBlink")
                        peripheral.call(selectedDevice, "setCursorBlink", perBlink)
                    end
                elseif peripheral.getType(selectedDevice) == "computer" then
                    
                end
            end
        end
    end    
end

function handleDrawing()    
    while true do
        os.sleep(1)
        
        if screen == "list" then
            drawListOfDevices()
        end
    
        if screen == "device" then
            drawDeviceInformation()
        end        
    end
end

print("Starting display loops")
parallel.waitForAny(handleDrawing, handleClicking)
print("One of the loops exited.")

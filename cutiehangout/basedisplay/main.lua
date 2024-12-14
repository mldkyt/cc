
function getIGT()
    local hour = os.time()
    local minute = hour % 1
    minute = minute * 60

    return string.format("%02d", hour) .. ":" .. string.format("%02d", minute)
end

function getRealTime()
    local hour = os.time("utc")
    local minute = hour % 1
    minute = minute * 60

    return string.format("%02d", hour) .. ":" .. string.format("%02d", minute)
end


function getComputers()
    local devices = {}
    for k, v in ipairs(peripheral.getNames()) do
        if v ~= "right" and v ~= "left" and v ~= "top" and v ~= "bottom" and v ~= "back" and v ~= "front" and peripheral.getType(v) == "computer" then
            table.insert(devices, v)
        end
    end

    local devices2 = {}

    for k, v in ipairs(devices) do
        table.insert(devices2, {
            device = v,
            isOn = peripheral.call(v, "isOn")
        })
    end

    return devices2
end

local mon = peripheral.wrap("back")
function printTime()
    while true do
        local time = getIGT()

        mon.setCursorPos(1, 1)
        mon.write("It is currently " .. time .. ".")

        mon.setCursorPos(1, 2)

        local realTime = getRealTime()
        mon.write("Real time is " .. realTime .. ".")

        os.sleep(0.5)

        local devices = getComputers()
        mon.setCursorPos(2, 4)
        mon.write("COMPUTERS ON NETWORK")
        
        for k, v in ipairs(devices) do
            mon.setCursorPos(2, k + 4)
            mon.write(v.device)
            if v.isOn then
                mon.write(" - ONLINE")
            else
                mon.write(" - OFFLINE!")
            end
        end
    end
end

parallel.waitForAny(printTime)

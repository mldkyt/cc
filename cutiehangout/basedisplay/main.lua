
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
    end
end

parallel.waitForAny(printTime)


local mon = peripheral.wrap("monitor_1")

local listOfDevices = peripheral.getNames()


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

mon.clear()
mon.setCursorPos(1, 1)
mon.write("List of devices on this network:")

mon.setCursorPos(2, 2)
mon.write("NAME")

mon.setCursorPos(30, 2)
mon.write("TYPE")

for k, v in ipairs(listOfDevices) do
    if v ~= "right" and v ~= "left" and v ~= "top" and v ~= "bottom" and v ~= "back" and v ~= "front" then 
        mon.setCursorPos(2, k + 2)
        mon.write(v)
        mon.setCursorPos(30, k + 2)
        mon.write(peripheral.getType(v))
    end
end

msg = "IGT " .. getIGT() .. " IRL " .. getRealTime()
mon.setCursorPos(mon.getSize()[1] - #msg, mon.getSize()[2])
mon.write(msg)


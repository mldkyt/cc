
local mon = peripheral.wrap("back")
function printTime()
    while true do
        local time = os.time()
        local hours = math.floor(time % 86400 / 3600)
        local minutes = math.floor((time % 3600) / 60)

        mon.setCursorPos(1, 1)
        mon.write("IGT:")
        mon.setCursorPos(1, 2)
        mon.write(string.format("%02d:%02d", hours, minutes))

        os.sleep(0.5)
    end
end

parallel.waitForAny(printTime)

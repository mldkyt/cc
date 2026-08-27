
local monitor = peripheral.wrap("back")

monitor.setCursorPos(1, 1)
monitor.write("Hello world! This is a test if this works or not. ")

local hours = math.floor(os.time())
local minutes = math.floor((hours % 1) * 60)

monitor.write("Here is a clock: " .. hours .. ":" .. minutes)

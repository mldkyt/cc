
local monitor = peripheral.wrap("monitor_3")

local seedsInChest = peripheral.wrap("quark:variant_chest_1")
local seedsOutChest = peripheral.wrap("quark:variant_chest_0")
local wheatChest = peripheral.wrap("minecraft:chest_0")

inChestString = ""
outChestString = ""
wheatChestString = ""

inChestPercentage = 0
outChestPercentage = 0
wheatChestPercentage = 0

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

function getSeedsInChest()
    local capacity = seedsInChest.size() * 64
    local usage = 0
    for k, v in pairs(seedsInChest.list()) do
        usage = usage + v.count
    end

    inChestPercentage = (usage / capacity) * 100

    return string.format("%.0f/%.0f (%.2f)", usage, capacity, inChestPercentage)
end

function getSeedsOutChest()
    local capacity = seedsOutChest.size() * 64
    local usage = 0
    for k, v in pairs(seedsOutChest.list()) do
        usage = usage + v.count
    end

    outChestPercentage = (usage / capacity) * 100

    return string.format("%.0f/%.0f (%.2f)", usage, capacity, outChestPercentage)
end

function getWheatChest()
    local capacity = wheatChest.size() * 64
    local usage = 0
    for k, v in pairs(wheatChest.list()) do
        usage = usage + v.count
    end

    wheatChestPercentage = (usage / capacity) * 100

    return string.format("%.0f/%.0f (%.2f)", usage, capacity, wheatChestPercentage)
end



function refreshChestData()
    while true do
        inChestString = getSeedsInChest()
        outChestString = getSeedsOutChest()
        wheatChestString = getWheatChest()
        os.sleep(1)
    end
end

function drawChestData()
    while true do
        monitor.setBackgroundColor(colors.white)
        monitor.setTextColor(colors.black)
        monitor.clear()
    
        -- Title
        monitor.setCursorPos(1, 1)
        monitor.write("CHEST STATUS")
        
        -- Seeds in Chest
        monitor.setCursorPos(1, 3)
        monitor.write("Seeds in chest")
        monitor.setCursorPos(2, 4)
        if inChestPercentage > 90 then
            monitor.setTextColor(colors.red)
        elseif inChestPercentage > 60 then
            monitor.setTextColor(colors.yellow)
        elseif inChestPercentage < 20 then
            monitor.setTextColor(colors.green)
        end
        monitor.write(inChestString)
        monitor.setTextColor(colors.black)
    
        -- Seeds out Chest
        monitor.setCursorPos(1, 6)
        monitor.write("Seeds out chest")
        monitor.setCursorPos(2, 7)
        if outChestPercentage > 90 then
            monitor.setTextColor(colors.red)
        elseif outChestPercentage > 60 then
            monitor.setTextColor(colors.yellow)
        elseif outChestPercentage < 20 then
            monitor.setTextColor(colors.green)
        end
        monitor.write(outChestString)
        monitor.setTextColor(colors.black)
    
        -- Wheat Chest
        monitor.setCursorPos(1, 9)
        monitor.write("Wheat chest")
        monitor.setCursorPos(2, 10)
        if wheatChestPercentage > 90 then
            monitor.setTextColor(colors.red)
        elseif wheatChestPercentage > 60 then
            monitor.setTextColor(colors.yellow)
        elseif wheatChestPercentage < 20 then
            monitor.setTextColor(colors.green)
        end
        monitor.write(wheatChestString)
        monitor.setTextColor(colors.black)

        local w, h = monitor.getSize()
        monitor.setCursorPos(1, h)
        monitor.write("IGT ".. getIGT() .. " IRL " .. getRealTime())
    
        os.sleep(0.1)
    end    
end

print("Starting Farm Chest display software :3")
parallel.waitForAny(drawChestData, refreshChestData)

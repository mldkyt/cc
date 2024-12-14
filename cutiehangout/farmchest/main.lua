
local monitor = peripheral.wrap("monitor_3")

local seedsInChest = peripheral.wrap("quark:variant_chest_1")
local seedsOutChest = peripheral.wrap("quark:variant_chest_0")
local wheatChest = peripheral.wrap("minecraft:chest_0")

inChestString = ""
outChestString = ""
wheatChestString = ""

function getSeedsInChest()
    local capacity = seedsInChest.size() * 64
    local usage = 0
    for k, v in ipairs(seedsInChest.list()) do
        usage = usage + v.count
    end

    local percentage = (usage / capacity) * 100

    return string.format("%.0f/%.0f (%.2f)", usage, capacity, percentage)
end

function getSeedsOutChest()
    local capacity = seedsOutChest.size() * 64
    local usage = 0
    for k, v in ipairs(seedsOutChest.list()) do
        usage = usage + v.count
    end

    local percentage = (usage / capacity) * 100

    return string.format("%.0f/%.0f (%.2f)", usage, capacity, percentage)
end

function getWheatChest()
    local capacity = wheatChest.size() * 64
    local usage = 0
    for k, v in ipairs(wheatChest.list()) do
        usage = usage + v.count
    end

    local percentage = (usage / capacity) * 100

    return string.format("%.0f/%.0f (%.2f)", usage, capacity, percentage)
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
        monitor.write(inChestString)
    
        -- Seeds out Chest
        monitor.setCursorPos(1, 6)
        monitor.write("Seeds out chest")
        monitor.setCursorPos(2, 7)
        monitor.write(outChestString)
    
        -- Wheat Chest
        monitor.setCursorPos(1, 9)
        monitor.write("Wheat chest")
        monitor.setCursorPos(2, 10)
        monitor.write(wheatChestString)
    
        os.sleep(0.1)
    end    
end

print("Starting Farm Chest display software :3")
parallel.waitForAny(drawChestData, refreshChestData)

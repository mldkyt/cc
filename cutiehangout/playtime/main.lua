local json = require("json")

a = http.get("https://chb.mldchan.dev/api/get", {
    ["Accept"] = "application/json",
    ["User-Agent"] = "CutieHangout/1.0"
})

a = json.decode(a.readAll())

function formatTime(seconds)
    local months = math.floor(seconds / 2629743) % 12
    local weeks = math.floor(seconds / 604800) % 52
    local days = math.floor(seconds / 86400) % 7
    local hours = math.floor(seconds / 3600) % 24
    local minutes = math.floor(seconds / 60) % 60
    local seconds = math.floor(seconds % 60)

    local formattedTime = ""

    if months > 0 then
        formattedTime = formattedTime .. months .. "mo "
    end

    if weeks > 0 then
        formattedTime = formattedTime .. weeks .. "w "
    end

    if days > 0 then
        formattedTime = formattedTime .. days .. "d "
    end

    if hours > 0 then
        formattedTime = formattedTime .. hours .. "h "
    end

    if minutes > 0 then
        formattedTime = formattedTime .. minutes .. "m "
    end

    formattedTime = formattedTime .. seconds .. "s "

    return formattedTime
end

function truncateString(str, length)
    if #str > length then
        return str:sub(1, length)
    else
        spaces = ''
        for i = 1, length - #str do
            spaces = spaces .. ' '
        end
        return str .. spaces
    end
end

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

local mon = peripheral.wrap("Create_DisplayLink_1")
local y, x = mon.getSize()

mon.clear()
mon.update()

local j = 1

while true do
    j = j + 1
    if j > 10 then
        j = 1
        a = http.get("https://chb.mldchan.dev/api/get", {
            ["Accept"] = "application/json",
            ["User-Agent"] = "CutieHangout/1.0"
        })
        
        a = json.decode(a.readAll())
    end

    local onlinePlayers = 0
    local offlinePlayers = 0

    local i = 1
    for k, v in ipairs(a['modded']) do
        if v['online'] then
            i = i + 1
            mon.setCursorPos(2, i + 2)
            mon.write('   ' .. truncateString(v['name'], 10) .. " - " .. formatTime(v['playtime']))
            onlinePlayers = onlinePlayers + 1
        end
    end

    mon.setCursorPos(1, 3)
    mon.write("Online Players - " .. onlinePlayers)

    local i = 1
    for k, v in ipairs(a['modded']) do
        if not v['online'] then
            i = i + 1
            if i + 3 + onlinePlayers < y then
                mon.setCursorPos(2, i + 3 + onlinePlayers)
                mon.write('   ' .. truncateString(v['name'], 10) .. " - " .. formatTime(v['playtime']))
            end
            offlinePlayers = offlinePlayers + 1
        end
    end

    mon.setCursorPos(1, onlinePlayers + 4)
    mon.write("Offline Players - " .. offlinePlayers)

    mon.setCursorPos(18, 1)
    mon.write(onlinePlayers .. " online players")
    mon.setCursorPos(18, 2)
    mon.write(offlinePlayers .. " offline players")

    local str = "IGT " .. getIGT() .. " IRL " .. getRealTime()
    mon.setCursorPos(x - #str, y)
    mon.write(str)

    mon.update()

    os.sleep(1)
end

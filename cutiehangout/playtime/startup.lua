
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
        formattedTime = formattedTime..months.." months, "
    end

    if weeks > 0 then
        formattedTime = formattedTime..weeks.." weeks, "
    end

    if days > 0 then
        formattedTime = formattedTime..days.." days, "
    end

    if hours > 0 then
        formattedTime = formattedTime..hours.." hours, "
    end

    if minutes > 0 then
        formattedTime = formattedTime..minutes.." minutes, "
    end

    formattedTime = formattedTime..seconds.." seconds"

    return formattedTime
end

function truncateString(str, length)
    if #str > length then
        return str:sub(1, length).."..."
    else
        spaces = ''
        for i = 1, length - #str do
            spaces = spaces..' '
        end
        return str .. spaces
    end
end

for k, v in pairs(a['modded']) do
    if v['online'] then
        print(truncateString(v['name'], 20).." - "..formatTime(v['playtime']))
    end
end

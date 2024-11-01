
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
        formattedTime = formattedTime..months.."mo "
    end

    if weeks > 0 then
        formattedTime = formattedTime..weeks.."w "
    end

    if days > 0 then
        formattedTime = formattedTime..days.."d "
    end

    if hours > 0 then
        formattedTime = formattedTime..hours.."h "
    end

    if minutes > 0 then
        formattedTime = formattedTime..minutes.."m "
    end

    formattedTime = formattedTime..seconds.."s "

    return formattedTime
end

function truncateString(str, length)
    if #str > length then
        return str:sub(1, length - 3).."..."
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
        print('   '..truncateString(v['name'], 16).." - "..formatTime(v['playtime']))
    end
end

-- ComputerCraftScripts
-- Copyright (C) 2024  mldchan

-- This program is free software: you can redistribute it and/or modify it under the terms of the
-- GNU General Public License as published by the Free Software Foundation, either version 3 of
-- the License, or (at your option) any later version.

-- This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
-- even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License along with this program.
-- If not, see <https://www.gnu.org/licenses/>.

VERSION = "1.1"

require("utils")
local json = require("json")

config_file = readFile("config.json")
config = json.decode(config_file)

local mon = peripheral.wrap(config.side)

if config.text_scale ~= nil then
    mon.setTextScale(config.text_scale)
end

local mon_width, mon_height = mon.getSize()

while true do
    mon.clear()
    mon.setCursorPos(2, 2)
    mon.write("Deprecation Warning")
    mon.setCursorPos(1, 4)
    prettyWrite(mon, "This software is deprecated and has stopped working on 2024/10/31. This software's servers have shut down. Example data from recent will be displayed.")
    mon.setCursorPos(2, mon_height - 2)
    mon.write("[ Continue ]")
    
    local event, p1, p2, p3, p4, p5 = os.pullEvent()
    print(event, p2, p3)
    if event == "monitor_touch" and p2 > 2 and p2 < 14 and p3 == mon_height - 2 then
        break
    end
end


local has_loaded = false
local api_parsed = {
    motd = "VelkySMP status monitor demo",
    online = 1,
    max = 20,
    ping = 123,
    players = {
        {
            name = "mldchan",
            humantime = "2d 14h 43m",
            online = true,
            profileStyle = {
                ccColor = "white"
            }
        },
        {
            name = "gimsmorf",
            humantime = "4w 1d 12h 16m",
            online = false,
            profileStyle = {
                ccColor = "white"
            }
        },
        {
            name = "norm_selling",
            humantime = "3w 9h 41m",
            online = false,
            profileStyle = {
                ccColor = "white"
            }
        },
        {
            name = "Backlashshadow",
            humantime = "1w 3d 17h 53m",
            online = false,
            profileStyle = {
                ccColor = "white"
            }
        },
        {
            name = "Typera",
            humantime = "1w 2d 22h 18m",
            online = false,
            profileStyle = {
                ccColor = "white"
            }
        },
        {
            name = "RoofWithAFloor",
            humantime = "1w 2d 14h 44m",
            online = false,
            profileStyle = {
                ccColor = "white"
            }
        },
        {
            name = "Mischevio",
            humantime = "1w 2d 12h 31m",
            online = false,
            profileStyle = {
                ccColor = "white"
            }
        },
        {
            name = "Beaver0084",
            humantime = "1w 1d 12h 31m",
            online = false,
            profileStyle = {
                ccColor = "white"
            }
        },
        {
            name = "xRieri",
            humantime = "1w 1d 6h 41m",
            online = false,
            profileStyle = {
                ccColor = "white"
            }
        }
    }
}

function drawMainScreen()
    if not has_loaded then
        -- local api_content = http.get("https://velkysmp-mon.vercel.app/api/get").readAll()
        -- api_parsed = json.decode(api_content)
        has_loaded = true
    end
    local api_sorted = {}

    for k, i in ipairs(api_parsed.players) do
        if i.online then
            table.insert(api_sorted, i)
        end
    end

    for k, i in ipairs(api_parsed.players) do
        if not i.online then
            table.insert(api_sorted, i)
        end
    end

    mon_width, mon_height = mon.getSize()

    mon.clear()
    mon.setCursorPos(1, 1)
    prettyWrite(mon, "mldchan's VelkySMP monitor - since 2024/02/25!")

    local items_count = mon_height - 3
    for k, v in ipairs(api_sorted) do
        if k > items_count then
            break
        end

        color = v.profileStyle.ccColor or "white"

        mon.setCursorPos(2, 2 + k)
        table.foreach(colors, function(k, v)
            if type(v) == "number" and k == color then
                mon.setTextColor(v)
            end
        end)
        mon.write(k .. ". " .. v.name)
        mon.setTextColor(colors.white)
        mon.setCursorPos(mon_width - 20, 2 + k)
        mon.write(v.humantime)

        if v.online then
            mon.setCursorPos(mon_width - 5, 2 + k)
            mon.write("Online")
        end
    end

    mon.setCursorPos(mon_width - #"Version " - #VERSION + 1, mon_height)
    mon.write("Version " .. VERSION)
end

mon.clear()

mon.setCursorPos(1, 1)
mon.write("mldchan's VelkySMP monitor - since 2024/02/25!")

mon.clear()

mon.setCursorPos(2, 3)
mon.write("Refreshing... this may take a while")

drawMainScreen()

timer = os.startTimer(30)

timer2 = os.startTimer(3600)

while true do
    event, p1, p2, p3, p4, p5 = os.pullEventRaw()
    if event == "peripheral_detach" then
        -- p1 - side, p2 - type
        if config.webhook ~= nil and config.webhook ~= "" then
            http.post(config.webhook, json.encode({
                content = "Peripheral " .. p1 .. " was detached! <@" .. config.userId .. ">"
            }), {
                ["Content-Type"] = "application/json"
            })
        end
    end

    if event == "peripheral" then
        -- p1 - side, p2 - type
        if config.webhook ~= nil and config.webhook ~= "" then
            http.post(config.webhook, json.encode({
                content = "Peripheral " .. p1 .. " was attached! <@" .. config.userId .. ">"
            }), {
                ["Content-Type"] = "application/json"
            })
        end
    end

    if event == "monitor_resize" then
        drawMainScreen()
    end

    if event == "timer" and p1 == timer then
        print("Refresh screen after 30 seconds")
        drawMainScreen()
        timer = os.startTimer(30)
    elseif event == "timer" and p1 == timer2 then
        print("Full refresh after 1 hour")
        -- local api_content = http.get("https://velkysmp-mon.vercel.app/api/get").readAll()
        -- api_parsed = json.decode(api_content)
        drawMainScreen()
        timer2 = os.startTimer(3600)
    end
end

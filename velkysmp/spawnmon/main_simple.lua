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



VERSION = "1.08"

local rebootTimer = os.startTimer(300)

local mon = peripheral.wrap("right")
mon.setTextScale(0.5)
local mon_width, mon_height = mon.getSize()

local has_loaded = false
local api_parsed = {}
local setting_show_online_first = redstone.getInput("front")

function drawMainScreen()
    -- Fetch the data for the first time
    if not has_loaded then
        local api_content = http.get("https://velkysmp-mon.vercel.app/api/get").readAll()
        api_parsed = json.decode(api_content)
        has_loaded = true
    end

    api_sorted = {}

    if setting_show_online_first then
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
    else
        api_sorted = api_parsed.players
    end

    mon_width, mon_height = mon.getSize()

    mon.clear()
    mon.setCursorPos(1, 1)
    mon.write("mldchan's VelkySMP monitor - since 2024/02/25!")

    mon.setCursorPos(1, 2)
    mon.write(
    "The times played are total times on both the old and this server. Due to MC limitations, only 12 players will be online at once.")

    mon.setCursorPos(1, 3)
    if setting_show_online_first then
        mon.write("Top players by online and playtime")
    else
        mon.write("Top players by playtime")
    end

    local items_count = mon_height - 8
    for k, v in ipairs(api_sorted) do
        if k > items_count then
            break
        end

        mon.setCursorPos(2, 4 + k)
        mon.write(k .. ". " .. v.name)
        mon.setCursorPos(mon_width - 20, 4 + k)
        mon.write(v.humantime)

        if v.online then
            mon.setCursorPos(mon_width - 5, 4 + k)
            mon.write("Online")
        end
    end

    mon.setCursorPos(1, mon_height - 2)
    mon.write("mldchan's VelkySMP Status Monitor v" .. VERSION .. ": CC edition")
    mon.setCursorPos(1, mon_height - 1)
    mon.write("Check her out on mldkyt.nekoweb.org and sign the guestbook at mldchan.atabook.org!")
    mon.setCursorPos(1, mon_height)
    mon.write("The online version of this software is on velkysmp-mon.vercel.app")
end

json = require("json")

mon.clear()

mon.setCursorPos(1, 1)
mon.write("mldchan's VelkySMP monitor - since 2024/02/25!")

mon.setCursorPos(2, 3)
mon.write("Refreshing... this may take a while")

drawMainScreen()

while true do
    -- Wait for an event, or sleep for a short duration
    local event, p1, p2, p3, p4, p5 = os.pullEventRaw()
    if event == "monitor_resize" then
        drawMainScreen()
    elseif event == "redstone" then
        setting_show_online_first = redstone.getInput("front")
        drawMainScreen()
    elseif event == "timer" then
        if p1 == rebootTimer then
            os.reboot()
        end
    end
end

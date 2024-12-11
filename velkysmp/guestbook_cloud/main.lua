-- ComputerCraftScripts: Guestbook Script
-- Copyright (C) 2024  mldchan
-- This program is free software: you can redistribute it and/or modify it under the terms of the
-- GNU General Public License as published by the Free Software Foundation, either version 3 of
-- the License, or (at your option) any later version.
-- This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
-- even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- You should have received a copy of the GNU General Public License along with this program.
-- If not, see <https://www.gnu.org/licenses/>.

print("mldchan's Guestbook (Online Version) has started")

require("utils")
local json = require("json")

local guestbookEntries = {}

print("Fetching guestbook entries...")
request = http.get("https://mldchan-api.vercel.app/api/velkysmpguestbook/get")
guestbookEntries = json.decode(request.readAll())
request.close()

print("Fetched guestbook entries: ", #guestbookEntries)

local screen = "main"

local mon = peripheral.wrap("back")
local mon_width, mon_height = mon.getSize()

local scanner = peripheral.wrap("left")

local managementIndex = 1
local lastLocalTime = os.time("utc")

function drawScreen()
    mon.setBackgroundColor(colors.black)
    mon.setTextColor(colors.white)

    mon.clear()

    if screen == "main" then
        local time = os.time()
        local dayUnfinished = os.day()
        local year = math.floor(dayUnfinished / 365) + 1
        --- make year always display in 4 digits e.g. 0002
        local month = math.floor((dayUnfinished - (year - 1) * 365) / 30) + 1
        local day = dayUnfinished - (year - 1) * 365 - (month - 1) * 30 + 1
        year = year + 2000
        year = string.format("%04d", year)
        month = string.format("%02d", month)
        day = string.format("%02d", day)
        local hours = math.floor(time)
        local minutes = math.floor((time - hours) * 100 * 0.6)
        hours = string.format("%02d", hours)
        minutes = string.format("%02d", minutes)

        mon.setCursorPos(1, 1)
        mon.write("mldchan's guestbook - " .. tostring(year) .. "/" ..
            tostring(month) .. "/" .. tostring(day) .. " " ..
            tostring(hours) .. ":" .. tostring(minutes) .. " IGT")

        local entries_to_display = math.floor((mon_height - 3) / 3)
        local startIndex = math.max(1,
            #guestbookEntries - entries_to_display + 1)

        for index = startIndex, #guestbookEntries do
            local value = guestbookEntries[index]
            local y = (index - startIndex) * 3 + 3

            mon.setCursorPos(2, y)
            mon.write(value.title)
            mon.setCursorPos(3, y + 1)
            mon.write(value.content)
        end

        mon.setCursorPos(2, mon_height - 1)
        mon.write("[ Sign this guestbook ]")
    elseif screen == "sign" then
        mon.setCursorPos(2, 2)
        prettyWrite(mon, "Please enter the title of your entry.")

        local playerName = ""
        local distance = 999
        local lastDistance = distance
        local scanned = scanner.getPlayers()

        for _, value in ipairs(scanned) do
            distance = math.min(value.distance, distance)
            if distance ~= lastDistance then
                lastDistance = distance
                playerName = value.name
            end
        end

        if playerName == "" then
            mon.setTextColor(colors.red)
            mon.write("A player wasn't found nearby...")
            os.sleep(1)
            mon.clear()
            screen = "main"
            drawScreen()
        end

        mon.setCursorPos(2, 2)
        prettyWrite(mon, "Please enter the message.")
        mon.setCursorPos(2, 4)
        prettyWrite(mon, "The closest player (" .. playerName .. ") was used for the title.")

        os.loadAPI("keyboard")
        local content = keyboard.inputKeyboard(mon)
        os.unloadAPI("keyboard")
        mon.clear()

        mon.setCursorPos(2, 10)
        mon.write("Sending your entry to mldchan's API server...")
        table.insert(guestbookEntries, { title = playerName, content = content })

        request = http.post({
            url = "https://mldchan-api.vercel.app/api/velkysmpguestbook/add",
            body = json.encode({ title = playerName, content = content }),
            headers = { ["Content-Type"] = "application/json" }
        })
        request.close()

        mon.clear()

        screen = "main"
        refetchTimer = os.startTimer(30)
        print("Refetch timer ID is ", refetchTimer)
        drawScreen()
    elseif screen == "gnu" then
        -- show gnu gpl license
    end
end

drawScreen()

refetchTimer = os.startTimer(30)
print("Refech timer ID is ", refetchTimer)

while true do
    os.queueEvent("tick")
    event, p1, p2, p3, p4, p5 = os.pullEventRaw()
    if event == "monitor_touch" then
        if screen == "main" then
            if p2 > 1 and p2 < 25 and p3 == mon_height - 1 then
                screen = "sign"
                drawScreen()
            end
        end
    end

    if lastLocalTime ~= os.time("utc") then
        lastLocalTime = os.time("utc")
        drawScreen()
    end

    if screen == "main" and event == "timer" and p1 == refetchTimer then
        print("Refetching guestbook entries...")
        mon.clear()
        mon.setCursorPos(2, 10)
        mon.write("Refetching guestbook entries...")

        request = http.get("https://mldchan-api.vercel.app/api/velkysmpguestbook/get")
        guestbookEntries = json.decode(request.readAll())
        request.close()

        mon.clear()
        drawScreen()
        refetchTimer = os.startTimer(30)
        print("Refetch timer ID is ", refetchTimer)
    end
end

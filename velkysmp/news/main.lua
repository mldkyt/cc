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

require("utils")
local json = require("json")
local config = json.decode(readFile("config.json"))
local mon = peripheral.wrap("monitor_1")

local news, message = http.get("https://mldkyt.nekoweb.org/news.json")
print("Message: ", message)
local news1 = news.readAll()
print("Response: ", news1)
news.close()
local newsJson = json.decode(news1)

local monWidth, monHeight = mon.getSize()
local maxWidth = 0
local currentPos = 0

mon.setTextScale(1.5)

for i, v in ipairs(newsJson) do
    maxWidth = math.max(maxWidth, #v.date + #v.title + #v.content + 8 + monWidth)
end

function renderDisplay()
    mon.clear()
    for index, value in ipairs(newsJson) do
        if i == 3 then
            break
        end
        mon.setCursorPos(monWidth - currentPos, index)
        mon.write(value.date .. " -- " .. value.title .. " -- " .. value.content)
    end
end

while true do
    os.queueEvent("tick")
    evt, p1, p2, p3, p4, p5 = os.pullEventRaw()

    currentPos = currentPos + 1
    if currentPos > maxWidth then
        mon.setTextScale(3)
        mon.setCursorPos(1, 1)
        mon.write("Make sure to visit")
        mon.setCursorPos(1, 2)
        mon.write("mldchan.is-a.dev!")
        os.sleep(5)
        mon.clear()
        mon.setCursorPos(1, 1)
        mon.setTextScale(1.5)
        currentPos = 0
    end

    renderDisplay()
    os.sleep(0.1)
end

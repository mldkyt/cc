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

function getIgt()
    local time = os.time()
    local hours = math.floor(time)
    local minutes = math.floor((time - hours) * 100 * 0.6)
    hours = string.format("%02d", hours)
    minutes = string.format("%02d", minutes)
    return "In Game Time: " .. hours .. ":" .. minutes
end

per = peripheral.wrap("back")

canvas = per.canvas()
canvas.clear()

timeText = canvas.addText({x = 1, y = 1}, getIgt())


while true do
    os.sleep(1)
    timeText.setText(getIgt())
end

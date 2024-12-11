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

local con = peripheral.wrap("back")
local can = con.canvas()

can.clear()

local ents = can.addText({x=4,y=4}, "")

while true do
  os.sleep(1)

  local scan = con.sense()
  local scanReady = {}

  for _, value in pairs(scan) do
    if scanReady[value.name] == nil then
      scanReady[value.name] = 1
    else
      scanReady[value.name] = scanReady[value.name] + 1
    end
  end

  local message = ""

  for key, value in pairs(scanReady) do
    message = message .. key .. " x" .. tostring(value) .. "\n"
  end

  ents.setText(message)
end



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

local timer = os.time("utc")
local con = peripheral.wrap("back")

while true do
  os.queueEvent("tick")
  local evt, p1, p2, p3, p4, p5 = os.pullEvent()

  if timer ~= os.time("utc") then
    timer = os.time("utc")

    local random = math.random(1000)
    print("Random value: ", random)
    if random == 1000 then
      local choices1 = {"Meow", "Nya", "Mrow", "Mroow", "Mraow"}
      local choices2 = {"~", ""}
      local choices3 = {":3", "", ":3c", ">:3"}

      local msg = choices1[math.random(#choices1)] .. choices2[math.random(#choices2)] .. " " .. choices3[math.random(#choices3)]

      con.say(msg)
    end
  end
end


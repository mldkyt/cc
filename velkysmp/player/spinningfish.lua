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
local can = con.canvas3d()
local rot = 0

while true do
  os.sleep(0.05)
  rot = rot + 12

  local mobsScan = con.sense()
  local mobs = {}

  for _, value in ipairs(mobsScan) do
    table.insert(mobs, value)
  end

  can.clear()

  for _, value in ipairs(mobs) do
    local can3d = can.create({x=value.x,y=value.y,z=value.z})
    local fish = can3d.addItem({x=0,y=1,z=0}, "minecraft:fish")

    fish.setRotation(0, rot, 0)
  end
end


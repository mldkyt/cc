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

local mobsList = {}

function tableContains(tabl, el)
    for _, value in pairs(tabl) do
        if value.id == el.id then
            return true
        end
    end
    return false
end

while true do
  os.sleep(1)
  local mobsScan = con.sense()
  local mobs = {}

  for _, value in ipairs(mobsScan) do
    if value.id ~= nil then
      local detail = con.getMetaByID(value.id)
      if detail ~= nil then
        if detail.food ~= nil then
          table.insert(mobs, value)
        end
      end
    end
  end

  for _, value in ipairs(mobs) do
    local el = {
      id = value.id,
      displayName = value.displayName
    }

    if not tableContains(mobsList, el) then
      table.insert(mobsList, el)
      con.say("Hello, " .. el.displayName .. "!")
    end
  end

  for index, value in ipairs(mobsList) do
    if not tableContains(mobs, value) then
      table.remove(mobsList, index)
      con.say("Goodbye, " .. value.displayName .. "!")
    end
  end

end


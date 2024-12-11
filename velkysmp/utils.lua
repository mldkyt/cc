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



function readFile(filename)
    -- check if file exists, if not, return empty string
    if not fs.exists(filename) then
        return ""
    end

    file = fs.open(filename, "r")
    content = file.readAll()
    file.close()
    return content
end

function writeFile(filename, data)
    file = fs.open(filename, "w")
    file.write(data)
    file.close()
end

function prettyWrite(term, text)
    -- Make it wrap too
    local width, height = term.getSize()
    local x, y = term.getCursorPos()
    local lines = {}
    local line = ""
    for word in text:gmatch("%S+") do
        if #line + #word + 1 > width then
            table.insert(lines, line)
            line = ""
        end
        line = line .. word .. " "
    end
    table.insert(lines, line)
    for i, line in ipairs(lines) do
        term.setCursorPos(x, y + i - 1)
        term.write(line)
    end
end

function prompt(prompt)
    local content = ""
    
    while true do
        term.clearLine()
        local pos = {term.getCursorPos()}
        term.setCursorPos(1, pos[2])
        term.write(prompt .. " " .. content)

        event, p1 = os.pullEventRaw()
        if event == "char" then
            content = content .. p1
        elseif event == "key" then
            if p1 == 14 then
                content = content:sub(1, -2)
            elseif p1 == 28 then
                print()
                return content
            end
        end
    end
end

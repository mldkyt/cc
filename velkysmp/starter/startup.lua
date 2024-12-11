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

-- wget run https://mldkyt.nekoweb.org/cc/velkysmp/starter/startup.lua

function downloadFile(f, l)
    print(f .. ": downloading update..")
    -- Get string
    local startupUpdate, errorMessage = http.get(l)
    if startupUpdate == nil then
        printError("Error while trying to download file " .. errorMessage)
    end
    local status, message = startupUpdate.getResponseCode()
    if status ~= 200 then
        printError("Server responded with message " .. message)
        return
    end

    local fileC = startupUpdate.readAll()

    print(f .. ": deleting...")
    -- Delete the startup file
    fs.delete(f .. ".lua")

    print(f .. ": replacing..")
    -- Recreate the startup file
    local file = fs.open(f .. ".lua", "w")
    file.write(fileC)
    file.close()
    print(f .. ": done updating.")
end

downloadFile("startup", "https://mldkyt.nekoweb.org/cc/velkysmp/starter/startup.lua")
downloadFile("json", "https://raw.githubusercontent.com/rxi/json.lua/master/json.lua")
downloadFile("utils", "https://mldkyt.nekoweb.org/cc/velkysmp/utils.lua")
downloadFile("main", "https://mldkyt.nekoweb.org/cc/velkysmp/starter/main.lua")

require("utils")
local json = require("json")

-- startup alret
http.post("https://mldkyt.nekoweb.org/webhook", json.encode({
    content = "Computer " .. os.getComputerID() .. " has been started!"
}), {
    ["Content-Type"] = "application/json"
})

shell.run("main.lua")

-- reboot and alert

http.post("https://mldkyt.nekoweb.org/webhook", json.encode({
    content = "Computer " .. os.getComputerID() .. " has been rebooted!"
}), {
    ["Content-Type"] = "application/json"
})

os.reboot()

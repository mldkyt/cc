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



peripheral.call("right", "clear")

print("Checking updates...")

function downloadFile()
    print("Startup: downloading update..")
    -- Get string
    local startupUpdate = http.get("https://mldkyt.nekoweb.org/cc/velkysmp/spawnmon/startup_simple.lua")
    local startusCode, statusMessage = startupUpdate.getResponseCode()
    if startusCode ~= 200 then
        printError("Server responded with message " .. statusMessage)
        return
    end

    local startupFileContent = startupUpdate.readAll()

    print("Startup: deleting...")
    -- Delete the startup file
    fs.delete("startup.lua")

    print("Startup: replacing..")
    -- Recreate the startup file
    local file = fs.open("startup.lua", "w")
    file.write(startupFileContent)
    file.close()
    print("Startup: done updating.")
end

downloadFile()
fs.delete("json.lua")
shell.run("wget https://raw.githubusercontent.com/rxi/json.lua/master/json.lua json.lua")
fs.delete("main.lua")
shell.run("wget https://mldkyt.nekoweb.org/cc/velkysmp/spawnmon/main_simple.lua main.lua")

term.clear()

print("Running main.lua...")
shell.run("main.lua")

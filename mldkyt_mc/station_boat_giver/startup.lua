-- ComputerCraftScripts
-- Copyright (C) 2024  mldkyt

-- This program is free software: you can redistribute it and/or modify it under the terms of the
-- GNU General Public License as published by the Free Software Foundation, either version 3 of
-- the License, or (at your option) any later version.

-- This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
-- even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License along with this program.
-- If not, see <https://www.gnu.org/licenses/>.

function downloadFile(f, l)
    print(f .. ": downloading update..")
    -- Get string
    local startupUpdate, errorMessage = http.get(l)
    if startupUpdate == nil then
        printError(f .. ".lua: Error while trying to download file " .. errorMessage)
        return
    end
    local status, message = startupUpdate.getResponseCode()
    if status ~= 200 then
        printError(f .. ".lua: Server responded with message " .. message)
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

downloadFile("startup", "https://git.mldkyt.com/mldkyt/cc/raw/branch/main/mldkyt_mc/station_boat_giver/startup.lua")
downloadFile("json", "https://raw.githubusercontent.com/rxi/json.lua/master/json.lua")
downloadFile("main", "https://git.mldkyt.com/mldkyt/cc/raw/branch/main/mldkyt_mc/station_boat_giver/main.lua")

shell.run("main.lua")

os.sleep(1)
os.reboot()

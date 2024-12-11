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



while true do
    os.sleep(0.1)
    fs.delete("startup.lua")
    shell.run("wget https://mldkyt.nekoweb.org/cc/velkysmp/ticketserver/startup.lua startup.lua")
    fs.delete("json.lua")
    shell.run("wget https://raw.githubusercontent.com/rxi/json.lua/master/json.lua json.lua")
    fs.delete("main.lua")
    shell.run("wget https://mldkyt.nekoweb.org/cc/velkysmp/ticketserver/main.lua main.lua")
    fs.delete("utils.lua")
    shell.run("wget https://mldkyt.nekoweb.org/cc/velkysmp/utils.lua utils.lua")
    shell.run("main.lua")
    print("Process has crashed! Restarting...")
end

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

con = peripheral.wrap("back")

function updateLib()
  fs.delete("mldchan.lua")
  shell.run("wget https://mldkyt.nekoweb.org/cc/velkysmp/player/mldchan.lua")
  fs.delete("startup.lua")
  shell.run("wget https://mldkyt.nekoweb.org/cc/velkysmp/player/startup.lua")
end

con.tell("Starting mldchanOS...")
updateLib()

require("mldchan")

con.tell("Checking for updates and downloading them...")
checkForUpdates()
con.tell("Checking for updates was finished.")

-- Say starting messages
con.tell("[Starting] Automatic meowing")
con.tell("[Starting] Net logger")
con.tell("[Starting] User interface")
con.tell("[Starting] Base notifications")

-- Meowing
shell.run("bg /meow.lua")
con.tell("[Started] Automatic meowing")

-- Entity display
-- con.tell("[Starting] Entity display list")
-- shell.run(bg .. " /entdisplay.lua")
-- con.tell("[Started] Entity display list")

-- Spinning fish :3 
-- con.tell("[Starting] Spinning fish")
-- shell.run(bg .. " /spinningfish.lua")
-- con.tell("[Started] Spinning fish")

-- Net logger
shell.run("bg /netlogger.lua")
con.tell("[Started] Net logger")

-- UI
shell.run("bg /ui.lua")
con.tell("[Started] User interface")

-- Base notifications
shell.run("bg /basenotifs.lua")
con.tell("[Started] Base notifications")
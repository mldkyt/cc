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

function checkForUpdates()
  fs.delete("entdisplay.lua")
  shell.run("wget https://mldkyt.nekoweb.org/cc/velkysmp/player/entdisplay.lua")

  fs.delete("entsense.lua")
  shell.run("wget https://mldkyt.nekoweb.org/cc/velkysmp/player/entsense.lua")

  fs.delete("meow.lua")
  shell.run("wget https://mldkyt.nekoweb.org/cc/velkysmp/player/meow.lua")

  fs.delete("spinningfish.lua")
  shell.run("wget https://mldkyt.nekoweb.org/cc/velkysmp/player/spinningfish.lua")

  fs.delete("netlogger.lua")
  shell.run("wget https://mldkyt.nekoweb.org/cc/velkysmp/player/netlogger.lua")

  fs.delete("ui.lua")
  shell.run("wget https://mldkyt.nekoweb.org/cc/velkysmp/player/ui.lua")

  fs.delete("basenotifs.lua")
  shell.run("wget https://mldkyt.nekoweb.org/cc/velkysmp/player/basenotifs.lua")

  fs.delete("aeslua.lua")
  shell.run("wget https://gist.githubusercontent.com/perara/77b82012bdd2a702c98a714b57e1fb85/raw/ccea5f652cc33a979de02d6e0fe193db0c5bdfb1/aeslua.lua")

  fs.delete("json.lua")
  shell.run("wget https://raw.githubusercontent.com/rxi/json.lua/master/json.lua json.lua")

  fs.delete("utils.lua")
  shell.run("wget https://mldkyt.nekoweb.org/cc/velkysmp/utils.lua utils.lua")
end

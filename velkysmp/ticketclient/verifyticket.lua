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


require("aeslua")
require("utils")
local json = require("json")
local config = json.decode(readFile("config.json"))

local ticket = prompt("Ticket number: ")

local message = json.encode({type = "verifyticket", ticket = tonumber(ticket)})
message = encrypt(config.aesPassword, message)

rednet.open(config.modemSide)

local host = rednet.lookup("mldchan", "ticketserver")

if host == nil then
    print("Ticket server not found!")
    return
end

rednet.send(host, message, "mldchan")

local computer, message = rednet.receive("mldchan", 1)

if computer == nil then
    print("Ticket is not valid!")
    return
end

message = decrypt(config.aesPassword, message)
message = json.decode(message)

print("The ticket is valid and belongs to " .. tostring(message.name))

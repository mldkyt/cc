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


MODEM_SIDE = "left"

require("aeslua")
require("utils")
local json = require("json")
local config = json.decode(readFile("config.json"))

rednet.open(MODEM_SIDE)
local ticketServer = rednet.lookup("mldchan", "ticketserver")

if ticketServer == nil then
	print("Ticket server not found!")
	return
end

local name = prompt("Enter your name: ")

message1 = json.encode({ type = "generateticket", name = name })
message1 = encrypt(config.aesPassword, message1)

rednet.send(ticketServer, message1, "mldchan")
local computer, message = rednet.receive("mldchan", 1)
if computer == nil then
	print("Ticket server did not respond!")
	return
end

message = decrypt(config.aesPassword, message)
message = json.decode(message)
if message.type ~= "ticketgenerated" then
	print("Ticket server did not respond with a ticket!")
	return
end

print("Your ticket is: " .. tostring(message.ticket))

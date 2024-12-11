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

require("utils")
require("aeslua")
local json = require("json")
local config = json.decode(readFile("config.json"))

if not fs.exists("data.json") then
	print("Creating data.json")
	json.encode({})
end

rednet.open(config.modemSide)
rednet.host("mldchan", "ticketserver")

while true do
	computer, message = rednet.receive("mldchan", 1)
	if computer ~= nil then
		message = decrypt(config.aesPassword, message)
		if message ~= nil then
			message = json.decode(message)
			if message.type == "generateticket" then
				local data = json.decode(readFile("data.json"))
				local ticket = {
					name = message.name,
					ticket = math.random(100000, 999999)
				}
				table.insert(data, ticket)
				writeFile("data.json", json.encode(data))
				message = json.encode({ type = "ticketgenerated", ticket = ticket.ticket })
				message = encrypt(config.aesPassword, message)
				rednet.send(computer, message, "mldchan")
			elseif message.type == "verifyticket" then
				local data = json.decode(readFile("data.json"))
				for k, v in ipairs(data) do
					if v.ticket == message.ticket then
						message = { type = "ticketverified", name = v.name }
						message = json.encode(message)
						message = encrypt(config.aesPassword, message)
						rednet.send(computer, message, "mldchan")
						break
					end
				end
			end
		end
	end

	os.sleep(0)
end

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

radar = peripheral.wrap("back") -- Radar peripheral

rednet.open("left")

local playersKnown = {} -- Names of players currently known

while true do
	os.queueEvent("tesuto")
	event, p1, p2, p3, p4, p5 = os.pullEventRaw()

	local playersScanned = radar.getPlayers()

	-- Add players not known to playersKnown, the format is [{distance, name}]

	for _, player in ipairs(playersScanned) do
		local playerKnown = false
		for _, known in ipairs(playersKnown) do
			if known == player.name then
				playerKnown = true
				break
			end
		end

		if not playerKnown then
			table.insert(playersKnown, player.name)
			http.post(
				config.webhook,
				json.encode({
					content = "Player " .. player.name .. " has entered the base!",
					username = "Radar",
				}),
				{
					["Content-Type"] = "application/json",
				}
			)
			rednet.broadcast(encrypt(config.password, json.encode({
				action = "enter",
				player = player.name
			})))
		end
	end

	-- Remove players not scanned from playersKnown

	for i = #playersKnown, 1, -1 do
		local playerKnown = false
		for _, player in ipairs(playersScanned) do
			if playersKnown[i] == player.name then
				playerKnown = true
				break
			end
		end

		if not playerKnown then
			http.post(
				config.webhook,
				json.encode({
					content = "Player " .. playersKnown[i] .. " has left the base!",
					username = "Radar",
				}),
				{
					["Content-Type"] = "application/json",
				}
			)
			rednet.broadcast(encrypt(config.password, json.encode({
				action = "leave",
				player = playersKnown[i]
			})))
			table.remove(playersKnown, i)
		end
	end
end

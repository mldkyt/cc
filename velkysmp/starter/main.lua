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

local function scanNetwork()
    print("Scanning network for offline computers...")

    local computers = {}

    -- Get a list of all connected peripherals
    local peripherals = peripheral.getNames()

    -- Filter out the computers
    for _, peripheralName in ipairs(peripherals) do
        if peripheral.getType(peripheralName) == "computer" then
            table.insert(computers, peripheral.wrap(peripheralName))
        end
    end

    -- Check the status of each computer
    for _, computer in ipairs(computers) do
        if not computer.isOn() then
            print("Computer offline: " .. computer.getID())
        end
    end

    print("Network scan complete.")
end

scanNetwork()

local function turnOnAllComputers()
    print("Turning on all computers...")

    local computers = {}

    -- Get a list of all connected peripherals
    local peripherals = peripheral.getNames()

    -- Filter out the computers
    for _, peripheralName in ipairs(peripherals) do
        if peripheral.getType(peripheralName) == "computer" then
            table.insert(computers, peripheral.wrap(peripheralName))
        end
    end

    -- Check the status of each computer and turn it on if it's offline
    for _, computer in ipairs(computers) do
        if not computer.isOn() then
            computer.turnOn()
            print("Computer turned on: " .. computer.getID())
        else
            print("Computer already online: " .. computer.getID())
        end
    end

    print("All computers turned on.")
end

turnOnAllComputers()

while true do
    scanNetwork()
    turnOnAllComputers()
    os.sleep(10)
end


print("Estrogen Manager - 1.0 by mldchan")

local estrogenTank = peripheral.wrap("create:fluid_tank_0")
local pissTank = peripheral.wrap("create:fluid_tank_1")

local displayLink = peripheral.wrap("create:display_link_0")

local estrogen = estrogenTank.tanks()[1].amount
local piss = pissTank.tanks()[1].amount

displayLink.setCursorPos(1, 1)
displayLink.setText("Estrogen: "..estrogen.." mB")
displayLink.setCursorPos(1, 2)
displayLink.setText("Piss: "..piss.." mB")


print("Estrogen Manager - 1.0 by mldchan")

local estrogenTank = peripheral.wrap("create:fluid_tank_0")
local pissTank = peripheral.wrap("create:fluid_tank_1")

local displayLink = peripheral.wrap("left")

while true do
    os.sleep(0.1)
    local estrogen = estrogenTank.tanks()[1].amount
    local piss = pissTank.tanks()[1].amount

    local estrogenUnit = "mB"
    local pissUnit = "mB"

    if estrogen > 1000 then
        estrogen = estrogen / 1000
        estrogenUnit = "B"
    end

    if piss > 1000 then
        piss = piss / 1000
        pissUnit = "B"
    end

    displayLink.clear()
    displayLink.update()
    displayLink.setCursorPos(1, 1)
    displayLink.write("Estrogen: "..estrogen..estrogenUnit)
    displayLink.setCursorPos(1, 2)
    displayLink.write("Piss: "..piss..pissUnit)
    displayLink.update()
end
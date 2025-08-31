
count = 0

local function main()
    local flipped = false
    while true do
        if not turtle.forward() then
            if flipped then
                turtle.turnRight()
                if not turtle.forward() then
                    turtle.turnRight()
                else
                    turtle.turnRight()
                    flipped = false
                end
            else
                turtle.turnLeft()
                if not turtle.forward() then
                    turtle.turnLeft()
                else
                    turtle.turnLeft()
                    flipped = true
                end
            end
        end

        turtle.placeDown()

        if count > 3 then
            turtle.suckDown()
            count = 0
        end

        count = count + 1

        os.sleep(0.05)
    end
end

main()


function readFile(filename)
    -- check if file exists, if not, return empty string
    if not fs.exists(filename) then
        return ""
    end

    file = fs.open(filename, "r")
    content = file.readAll()
    file.close()
    return content
end

function writeFile(filename, data)
    file = fs.open(filename, "w")
    file.write(data)
    file.close()
end

function connectRednet()
    local peripherals = peripheral.getNames()
    for k, v in ipairs(peripherals) do
        if v == "modem" then
            rednet.open(v)
            return true
        end
    end

    return false
end

-- Setup tasks --


if not fs.exists("etc") then
    fs.makeDir("etc")
end

if not fs.exists("etc/hostname") then
    term.write("Hostname: ")
    local hostname = read()
    writeFile("etc/hostname", hostname)
end


if not connectRednet() then
    print("Rednet host requires internet.")
    return
end

rednet.host("app", readFile("etc/hostname"))

if not fs.exists("pack") then
    fs.makeDir("pack")
end

local packages = fs.list("pack")
local packagesCount = tostring(#packages)

while true do
    os.sleep(0.05)
    os.queueEvent("tick")
    event, p1, p2, p3, p4, p5 = os.pullEvent()
    if event == "rednet_message" then
        if p2 == "packageCount" then
            rednet.send(p1, packagesCount)
        end
    end
end

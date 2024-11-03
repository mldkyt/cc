
VERSION = "1.0"

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

function setTextColor(color)
    if term.isColor() then
        term.setTextColor(color)
    end
end

if not fs.exists("/opt/app/disclaimer_shown") then
    print("app in ComputerCraft is based on a decentralized network of app servers.")
    print("By continuing, app will seek out to the network to find any app servers to download from. This might take upwards of a few seconds.")
    read()
    writeFile("/opt/app/disclaimer_shown", "true")
end

function connectRednet()
    local peripherals = peripheral.getNames()
    for k, v in ipairs(peripherals) do
        local type = peripheral.getType(v)
        if type == "modem" then
            rednet.open(v)
            return true
        end
    end

    return false
end

function fetchPackages()
    term.write("Searching for app servers... ")
    local appServers = {rednet.lookup("app")}
    print(#appServers .. " found")
    
    local totalPackagesCount = 0

    for _, v in ipairs(appServers) do
        term.write("Getting from ")
        rednet.send(v, "name")
        local hostname = rednet.receive("app", 1)
        if hostname == nil then
            setTextColor(colors.red)
            print("No hostname received")
            setTextColor(colors.white)
        else
            term.write(hostname .. "... ")
            rednet.send(v, "packageCount", "app")
            local packageCount = rednet.receive("app")
            setTextColor(colors.green)
            totalPackagesCount = tonumber(packageCount) + totalPackagesCount
            print(packageCount .. " packages")
            setTextColor(colors.white)
        end
    end

    return totalPackagesCount
end

-- MAIN CODE

if not connectRednet() then
    print("Could not connect to the network. app is unable to download packages.")
    return
end

print("APP version " .. VERSION)

local packages = fetchPackages()
print("A total of " .. packages .. " packages was found on the servers.")

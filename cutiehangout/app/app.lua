
VERSION = "1.0"

if not fs.exists("/opt/app/disclaimer_shown") then
    print("app in ComputerCraft is based on a decentralized network of app servers.")
    print("By continuing, app will seek out to the network to find any app servers to download from. This might take upwards of a few seconds.")
    read()
    writeFile("/opt/app/disclaimer_shown", "true")
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

function fetchPackages()
    term.write("Searching for APT servers... ")
    local aptServers = rednet.lookup("apt")
    print(#aptServers .. " found")
    
    for _, v in ipairs(aptServers) do
        term.write("Getting from " .. v "... ")
        rednet.send(v, "listPackages")
        term.setTextColor(colors.green)
        print("done")
        term.setTextColor(colors.white)
    end
end

if not connectRednet() then
    print("Could not connect to the network. APT is unable to download packages.")
    return
end

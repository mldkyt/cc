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

if not fs.exists("/opt/app/disclaimer_shown") then
    print("APP is based on a decentralized network of app servers.")
    print(
        "By continuing, app will seek out to the network to find any app servers to download from. This might take upwards of a few seconds.")
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
    local appServers = { rednet.lookup("app") }
    print(#appServers .. " found")

    local packages = {}

    for _, remote in ipairs(appServers) do
        rednet.send(remote, "name", "app")
        local pc, hostname = rednet.receive("app", 0.2)

        if pc ~= nil then
            term.write("Repository " .. hostname .. "... ")
            os.sleep(0.05)
            rednet.send(remote, "list", "app")

            local thisRemote = 0
            while true do
                local _, package = rednet.receive("app", 0.05)
                if package ~= nil then
                    table.insert(packages, {
                        remote = remote,
                        hostname = hostname,
                        package = package
                    })
                    print("inserting package")
                    print({
                        remote = remote,
                        hostname = hostname,
                        package = package
                    })
                    thisRemote = thisRemote + 1
                else
                    break
                end
            end

            print(thisRemote .. " packages")
        end
    end

    return packages
end

function printUsage()
    print("APP usage:")
    print("    install <package> - Installs an app to the computer")
    print("    remove <package> - Removes an app from the computer")
    print("    available - Lists available packages for download")
    print("    installed - Shows installed applications")
end

function receivePackage(packages, package)
    -- Check if package is valid
    packageValid = false

    for k, v in ipairs(packages) do
        if v['package'] == package then
            packageValid = true
        end
    end

    if not packageValid then
        print("Error downloading " .. package .. ": Not found")
        return
    end

    rednet.send(package['remote'], 'package', 'app')
    os.sleep(0.05)
    rednet.send(package['remote'], package['package'], 'app')

    local pc, packageCode = rednet.receive('app', 0.1)

    print("Downloaded package code, as a test, printing to log")
    print(packageCode)
end

-- MAIN CODE

if not connectRednet() then
    print("Could not connect to the network. app is unable to download packages.")
    return
end

print("APP version " .. VERSION)

local packages = fetchPackages()
print("A total of " .. #packages .. " packages was found on the servers.")

local parameters = { ... }

if #parameters == 0 then
    printUsage()
elseif #parameters == 1 then
    if parameters[1] == "available" then
        for k, v in ipairs(packages) do
            print(v['package'])
        end
    elseif parameters[1] == "installed" then
        print("To do!")
    else
        printUsage()
    end
elseif #parameters == 2 then
    if parameters[1] == "install" then
        receivePackage(packages, parameters[2])
    elseif parameters[1] == "remove" then
        print("Remove", parameters[2])
    end
end

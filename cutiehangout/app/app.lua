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

function fetchApps()
    term.write("Searching for app servers... ")
    local appServers = { rednet.lookup("app") }
    print(#appServers .. " found")

    local apps = {}

    for _, remote in ipairs(appServers) do
        rednet.send(remote, "name", "app")
        local pc, hostname = rednet.receive("app", 0.2)

        if pc ~= nil then
            term.write("Repository " .. hostname .. "... ")
            os.sleep(0.05)
            rednet.send(remote, "list", "app")

            local thisRemote = 0
            while true do
                local _, app = rednet.receive("app", 0.05)
                if app ~= nil then
                    table.insert(apps, {
                        remote = remote,
                        hostname = hostname,
                        app = app
                    })
                    thisRemote = thisRemote + 1
                else
                    break
                end
            end

            print(thisRemote .. " packages")
        end
    end

    return apps
end

function printUsage()
    print("APP usage:")
    print("    install <app> - Installs an app to the computer")
    print("    remove <app> - Removes an app from the computer")
    print("    available - Lists available packages for download")
    print("    installed - Shows installed applications")
end

function downloadApp(apps, app)
    print("Checking for " .. app .. " validity...")
    -- Check if package is valid
    appValid = false

    for k, v in ipairs(apps) do
        if v['package'] == app then
            appValid = true
            app = v
            break
        end
    end

    if not appValid then
        print("App " .. app .. " was not found in servers.")
        return
    end

    print("Installing app " .. app['app'] .. " from " .. app['hostname'])

    if not appValid then
        print("Error downloading " .. app .. ": Not found")
        return
    end

    rednet.send(app['remote'], 'app', 'app')
    os.sleep(0.05)
    rednet.send(app['remote'], app['app'], 'app')

    local pc, appCode = rednet.receive('app', 0.1)

    if not fs.exists("/bin") then
        fs.makeDir("/bin")
    end

    writeFile("/bin/" .. app['app'], appCode)

    print("Installed app " .. app['app'] .. " from " .. app["hostname"] .. " successfully.")
end

function deleteApp(app)
    print("Removing app  " .. app .. "...")

    if fs.exists("/bin/" .. app) then
        fs.delete("/bin/" .. app)
        print("App " .. app .. " was found and removed.")
    else
        print("App " .. app .. " was not found.")
    end
end

function listInstalledApps(apps)
    print("Listing installed packages...")

    for k, v in ipairs(apps) do
        if fs.exists("/bin/" .. v['app']) then
            print("App " .. v['app'] .. " from " .. v["hostname"])
        end
    end

    print("Listing done.")
end

-- MAIN CODE

if not connectRednet() then
    print("Could not connect to the network. app is unable to download apps.")
    return
end

print("APP version " .. VERSION)

local apps = fetchApps()
print("A total of " .. #apps .. " apps was found on the servers.")

local args = { ... }

print()
print()

if #args == 0 then
    printUsage()
elseif #args == 1 then
    if args[1] == "available" then
        for k, v in ipairs(apps) do
            print(v['app'])
        end
    elseif args[1] == "installed" then
        listInstalledApps(apps)
    else
        printUsage()
    end
elseif #args == 2 then
    if args[1] == "install" then
        downloadApp(apps, args[2])
    elseif args[1] == "remove" then
        deleteApp(args[2])
    end
end

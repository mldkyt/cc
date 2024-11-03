
VERSION = "0.07"

function reset()
    rednet.close()
end

function downloadFile(f, l)
    -- Get string
    local startupUpdate, errorMessage = http.get(l, {
        ["User-Agent"] = "CutieHangout/1.0"
    })
    if startupUpdate == nil then
        print("Error while trying to download file " .. errorMessage)
        return
    end
    local status, message = startupUpdate.getResponseCode()
    if status ~= 200 then
        print("Server responded with message " .. message)
        return
    end

    local fileC = startupUpdate.readAll()

    -- Delete the startup file
    fs.delete(f .. ".lua")

    -- Recreate the startup file
    local file = fs.open(f .. ".lua", "w")
    file.write(fileC)
    file.close()
end


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
    local opened = false
    for k, v in ipairs(peripherals) do

        local type = peripheral.getType(v)
        if type == "modem" then
            rednet.open(v)
            opened = true
        end
    end

    return opened
end

local args = {...}

if args[1] == "daemon" then

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

    -- Host APP server

    if not fs.exists("pack") then
        fs.makeDir("pack")
    end

    local packages = fs.list("pack")
    local packagesCount = tostring(#packages)

    print("APP server" .. VERSION .. " started. Listening for package requests.")
    print("Hosting " .. packagesCount .. " packages.")

    while true do
        os.sleep(0)
        event, p1, p2, p3, p4, p5 = os.pullEvent()
        if event == "rednet_message" and p3 == "app" then
            if p2 == "packageCount" then
                os.sleep(0.05)
                rednet.send(p1, packagesCount, "app")
            end

            if p2 == "name" then
                os.sleep(0.05)
                rednet.send(p1, readFile("etc/hostname"), "app")
            end

            if p2 == "package" then
                local pc, packageName = rednet.receive("app", 0.05)
                if pc ~= nil and fs.exists("pack/" .. packageName .. ".lua") then
                    rednet.send(p1, readFile("pack/" .. packageName .. ".lua"), "app")
                end
            end

            if p2 == "list" then
                local packages = fs.list("pack")

                for _, v in ipairs(packages) do
                    v = string.sub(v, 1, -5)
                    print(v)
                    rednet.send(p1, v, "app")
                end
            end
        end
    end
end

downloadFile("startup", "https://git.mldchan.dev/mld/cc/-/raw/main/cutiehangout/app/server.lua?ref_type=heads&inline=false")

print("APP server bootstrapper ".. VERSION .. ": Starting server")

shell.run("startup daemon")

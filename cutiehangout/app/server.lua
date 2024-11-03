
function reset()
    rednet.close()
end

function downloadFile(f, l)
    print(f .. ": downloading update..")
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

    print(f .. ": deleting...")
    -- Delete the startup file
    fs.delete(f .. ".lua")

    print(f .. ": replacing..")
    -- Recreate the startup file
    local file = fs.open(f .. ".lua", "w")
    file.write(fileC)
    file.close()
    print(f .. ": done updating.")
end

downloadFile("startup", "https://git.mldchan.dev/mld/cc/-/raw/main/cutiehangout/app/startup.lua?ref_type=heads&inline=false")

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

        local type = peripheral.getType(v)
        if type == "modem" then
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

-- Host APP server

if not fs.exists("pack") then
    fs.makeDir("pack")
end

local packages = fs.list("pack")
local packagesCount = tostring(#packages)

print("APP server started. Listening for package requests.")

while true do
    os.sleep(0.05)
    os.queueEvent("tick")
    event, p1, p2, p3, p4, p5 = os.pullEvent()
    if event == "rednet_message" and p3 == "app" then
        if p2 == "packageCount" then
            rednet.send(p1, packagesCount)
        end

        if p2 == "name" then
            print("Sending name to " .. p1)
            rednet.send(p1, readFile("etc/hostname"))
        end
    end
end

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

downloadFile("startup", "https://git.mldchan.dev/mld/cc/-/raw/main/cutiehangout/basedisplay/startup.lua?ref_type=heads&inline=false")
downloadFile("main", "https://git.mldchan.dev/mld/cc/-/raw/main/cutiehangout/basedisplay/main.lua?ref_type=heads&inline=false")

while true do
    os.sleep(0.5)
    shell.run("main")
    print("Program crashed, restarting...")
end

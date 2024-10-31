
function downloadFile(f, l)
    print(f .. ": downloading update..")
    -- Get string
    local startupUpdate, errorMessage = http.get(l)
    if startupUpdate == nil then
        printError("Error while trying to download file " .. errorMessage)
    end
    local status, message = startupUpdate.getResponseCode()
    if status ~= 200 then
        printError("Server responded with message " .. message)
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

downloadFile("startup.lua", "https://git.mldchan.dev/mld/cc/-/raw/main/cutiehangout/estrogen/startup.lua?ref_type=heads")
downloadFile("update.lua", "https://git.mldchan.dev/mld/cc/-/raw/main/cutiehangout/estrogen/update.lua?ref_type=heads")
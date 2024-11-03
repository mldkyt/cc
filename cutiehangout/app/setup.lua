
function writeFile(filename, data)
    file = fs.open(filename, "w")
    file.write(data)
    file.close()
end

shell.run("mkdir /bin")
shell.run("mkdir /opt")
shell.run("mkdir /opt/apt")
shell.run("copy /disk/apt /bin/apt")

local file = "{\"apps\":[{\"name\":\"apt\",\"version\":\"1.0\"}]}"
writeFile("/opt/apt/packages", file)

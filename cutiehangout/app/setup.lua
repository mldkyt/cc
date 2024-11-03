
function writeFile(filename, data)
    file = fs.open(filename, "w")
    file.write(data)
    file.close()
end

shell.run("mkdir /bin")
shell.run("mkdir /opt")
shell.run("mkdir /opt/app")
shell.run("copy /disk/app /bin/app")

local file = "{\"apps\":[{\"name\":\"app\",\"version\":\"1.0\"}]}"
writeFile("/opt/app/packages", file)

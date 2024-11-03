
print("app Disk Creator for CC")

shell.run("wget https://git.mldchan.dev/mld/cc/-/raw/main/cutiehangout/app/setup.lua?ref_type=heads&inline=false /disk/setup.lua")
shell.run("wget https://git.mldchan.dev/mld/cc/-/raw/main/cutiehangout/app/app.lua?ref_type=heads&inline=false /disk/app.lua")

print("Disk creation finished. Running app from the disk will install app to your computer.")

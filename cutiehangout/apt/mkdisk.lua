
print("APT Disk Creator for CC")

shell.run("wget https://git.mldchan.dev/mld/cc/-/raw/main/cutiehangout/apt/setup.lua?ref_type=heads&inline=false /disk/setup")
shell.run("wget https://git.mldchan.dev/mld/cc/-/raw/main/cutiehangout/apt/apt.lua?ref_type=heads&inline=false /disk/apt")

print("Disk creation finished. Running APT from the disk will install APT to your computer.")

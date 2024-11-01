
a = http.get("https://chb.mldchan.dev/api/get", {
    "Accept" = "application/json",
    "User-Agent" = "CutieHangout/1.0"
})

print(a.readAll())
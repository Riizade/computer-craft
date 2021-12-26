--- this script is the entry point for all other programs ---
--- execute "pastebin get cumLvdB9 update" to install this script ---
--- then execute "update", which should always give you the latest version of all scripts (including the update script) ---

args = {...}
first_arg = args[1]

function download_from_github(filename)
    print("updating " .. filename .. "...")
    local response = http.get("https://raw.githubusercontent.com/Riizade/computer-craft/main/lua/" .. filename .. ".lua")
    shell.run("delete", filename) --- clear the old version
    local file = fs.open(filename, "w") --- open and write file
    file.write(response.readAll())
    file.close()
end

function update_files(files)
    for index, filename in pairs(files) do
        download_from_github(filename)
    end
end

--- if "ready" is passed as the first argument, update all other scripts ---
if first_arg == "ready" then
    files = {"mine", "strip_mine", "min_fuel", "fell2", "floor", "items"}
    update_files(files)
else --- otherwise only update the update script, then call it to update other scripts ---
    files = {"update"}
    update_files(files)
    shell.run("update", "ready")
end

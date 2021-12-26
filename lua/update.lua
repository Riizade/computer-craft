--- this script updates all other scripts ---
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

files = {"mine", "strip_mine", "min_fuel", "fell2", "floor", "items"}
update_files(files)

local json = require("json")

--- this script updates all other scripts ---
function download_from_github(filename, commit)
    print("updating " .. filename .. "...")
    local response = http.get("https://raw.githubusercontent.com/Riizade/computer-craft/" .. commit .. "/lua/" .. filename .. ".lua")
    shell.run("delete", filename) --- clear the old version
    local file = fs.open(filename, "w") --- open and write file
    file.write(response.readAll())
    file.close()
end

function get_latest_commit()
    response = http.get("https://api.github.com/repos/Riizade/computer-craft/commits/main")
    data = json.decode(response.readAll())
    return data["sha"]
end

function update_files(files)
    local commit = get_latest_commit()
    print("fetching commit SHA " .. commit)
    for index, filename in pairs(files) do
        download_from_github(filename, commit)
    end
end

files = {"mine", "strip_mine", "min_fuel", "fell2", "floor", "items"}
update_files(files)

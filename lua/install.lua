--- this script is the entry point for all other programs ---
--- execute "pastebin get cumLvdB9 install" to install this script ---
--- then execute "install", which should always give you the latest version of all scripts (including the update script) ---

args = {...}

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

files = {"update"}
update_files(files)
shell.run("update", "ready")

return {download_from_github = download_from_github, update_files = update_files}

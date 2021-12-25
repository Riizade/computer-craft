--- create a table of program_name -> pastebin id ---
local programs = {}
programs["mine"] = "5eaKrXse"
programs["strip_mine"] = "7L3KVmHF"
programs["min_fuel"] = "eDLZ8RC5"
programs["fell"] = "Pxy0qa3c"
programs["install_all"] = "GisFepzJ"
programs["update"] = "cumLvdB9"

--- delete existing programs ---
for key, v in pairs(programs) do
    shell.run("delete", key)
end

--- install programs from pastebin ---
for key, value in pairs(programs) do
    shell.run("pastebin", "get", value, key)
end

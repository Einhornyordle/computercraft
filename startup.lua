local mapping = {
    modem = "storageTerminal",
    geoScanner = "areaSearch"
}

if mapping[peripheral.getType("back")] then
    shell.run(mapping[peripheral.getType("back")])
end
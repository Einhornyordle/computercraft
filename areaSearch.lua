local geo = peripheral.find("geoScanner")

local blocks = {
    ["allthemodium:allthemodium_ore"] = true,
    ["minecraft:ancient_debris"] = true,
    ["minecraft:emerald_ore"] = true,
    ["minecraft:deepslate_emerald_ore"] = true,
    ["minecraft:diamond_ore"] = true,
    ["minecraft:deepslate_diamond_ore"] = true
}

while true do
    term.clear()
    term.setCursorPos(1, 1)
    local scanResult = geo.scan(16)
    local sortedTable = {}
    if scanResult then
        for index, block in pairs(scanResult) do
            if blocks[block.name] then
                local direction = ""
                if block.z > 0 then
                    direction = direction .. "S"
                elseif block.z < 0 then
                    direction = direction .. "N"
                end
                if block.x > 0 then
                    direction = direction .. "E"
                elseif block.x < 0 then
                    direction = direction .. "W"
                end
                table.insert(sortedTable,
                    { block.name, block.x + block.y + block.z, direction, block.x, block.y, block.z })
            end
        end
        table.sort(sortedTable, function(a, b)
            return a[2] < b[2]
        end)
        for index, block in pairs(sortedTable) do
            print(block[1])
            print(block[3], block[4], block[5], block[6])
        end
    end
    sleep(geo.getOperationCooldown("scanBlocks") / 1000)
end
